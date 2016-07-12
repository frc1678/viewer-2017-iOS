//
//  FirebaseDataFetcher.swift
//  scout-viewer-2015-iOS
//
//  Created by Samuel Resendez on 1/23/16.
//  Copyright © 2016 Citrus Circuits. All rights reserved.
//

import UIKit
import Firebase
import Haneke

class FirebaseDataFetcher: NSObject, UITableViewDelegate {
    var notificationCounter = 0
    let cache = Shared.dataCache
    let imageCache = Shared.imageCache
    let notificationManager : NotificationManager
    var NSCounter = -2
    var hasUpdatedMatchOnSetup = false
    var firstCurrentMatchUpdate = true
    let currentMatchManager : CurrentMatchManager
    
    var matchCounter = 0
    var TIMDCounter = 0
    var teamCounter = 0
    
    var teams = [Team]()
    let firebaseURLFirstPart = "https://1678-scouting-2016.firebaseio.com/"
    
    let scoutingToken = "qVIARBnAD93iykeZSGG8mWOwGegminXUUGF2q0ee"
    let dev3Token = "AEduO6VFlZKD4v10eW81u9j3ZNopr5h2R32SPpeq"
    let dev2Token = "hL8fStivTbHUXM8A0KXBYPg2cMsl80EcD7vgwJ1u"
    let devToken = "j1r2wo3RUPMeUZosxwvVSFEFVcrXuuMAGjk6uPOc"
    let stratDevToken = "IMXOxXD3FjOOUoMGJlkAK5pAtn89mGIWAEnaKJhP"
    var matches = [Match]()
    var teamInMatches = [TeamInMatchData]()
    var imageUrls = [Int: String]()
    var allTheData = NSDictionary()
    
    let firebase : FIRDatabaseReference
    
    override init() {
        firebase = FIRDatabase.database().reference()
        self.currentMatchManager = CurrentMatchManager()
        self.notificationManager = NotificationManager(secsBetweenUpdates: 5, notifications: [])
        super.init()
        
        self.notificationManager.notifications.append(NotificationManager.Notification(name: "updateLeftTable"))
        //self.notificationManager.notifications.append(NotificationManager.Notification(name: "currentMatchUpdated"))
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            self.getAllTheData()
        })
        
    }
    
    func makeMatchFromSnapshot(snapshot: FIRDataSnapshot) -> Match {
        let match = Match()
        for key in Match().propertys() {
            if key == "calculatedData" {
                match.calculatedData = self.getMatchCalculatedDatafromDict(snapshot.value!.objectForKey("calculatedData") as? NSDictionary)
            } else {
                match.setValue(snapshot.value!.objectForKey(key), forKey: key)
            }
        }
        
        return match
    }
    
    func makeTeamFromSnapshot(snapshot: FIRDataSnapshot) -> Team {
        let team = Team()
        if let v = snapshot.value as? NSDictionary {
            if let _ = (v.objectForKey("name") as? String) {
                for key in team.propertys() {
                    if key == "calculatedData" {
                        let teamCDDict = (v.objectForKey("calculatedData") as? NSDictionary)
                        team.calculatedData = self.getcalcDataForTeamFromDict(teamCDDict)
                    } else {
                        team.setValue(snapshot.value!.objectForKey(key), forKey: key)
                        
                    }
                }
            }
        }
        return team
    }
    
    // MARK: Image Fetching Methods
    func getDataFromUrl(url:NSURL, completion: ((data: NSData?, error: NSError? ) -> Void)) {
        NSURLSession.sharedSession().dataTaskWithURL(url) {  (data, _, error) in //Should already be async
            completion(data: data, error: error)
            NSURLSession.sharedSession().invalidateAndCancel()
            }.resume()
    }
    
    func cacheImage(teamNum : Int, url : String?) {
        if let urlString = url {
            let url = NSURL(string: urlString)
            getDataFromUrl(url!) { [unowned self] (data, error) in
                guard let data = data where error == nil else { return }
                self.imageCache.set(value: UIImage(data: data) ?? UIImage(), key: "\(teamNum)")
                UIApplication.sharedApplication().performSelector("_performMemoryWarning")
            }
        }
    }
    
    func getImageForTeam(teamNumber : Int, fetchedCallback : (UIImage)->(), couldNotFetch: ()->()) { // Is already async
        self.imageCache.fetch(key: "\(teamNumber)").onSuccess { (image) -> () in
            fetchedCallback(image)
            }.onFailure { (E) -> () in
                couldNotFetch()
        }
    }
    
    func updateCacheIfNeeded(snap : FIRDataSnapshot, team : Team) {
        let defaults = NSUserDefaults.standardUserDefaults()
        let shouldAggressivelyDownload = defaults.boolForKey("predownloadPreference")
        if shouldAggressivelyDownload {
            if let newURL = snap.childSnapshotForPath("selectedImageUrl").value {
                if team.selectedImageUrl != newURL as? String {
                    cacheImage(snap.childSnapshotForPath("number").value as! Int, url: newURL as? String)
                }
            }
        }
    }
    // MARK: Data Fetching
    func getAllTheData() {
        self.firebase.observeSingleEventOfType(.Value, withBlock: { [unowned self] (snap) -> Void in
            let matchReference = self.firebase.child("Matches")
            
            matchReference.observeEventType(.ChildAdded, withBlock: { [unowned self] snapshot in
                self.matches.append(self.makeMatchFromSnapshot(snapshot))
                self.currentMatchManager.currentMatch = self.getCurrentMatch()
                if self.hasUpdatedMatchOnSetup == false {
                    self.hasUpdatedMatchOnSetup = true
                    self.notificationManager.queueNote("updateLeftTable", specialObject: nil)
                }
                })
            
            matchReference.observeEventType(.ChildChanged, withBlock: { [unowned self] snapshot in
                self.matchCounter++
                print(self.getCurrentMatch())
                self.currentMatchManager.currentMatch = self.getCurrentMatch()
                let number = (snapshot.childSnapshotForPath("number").value as? Int)!
                for matchIndex in Range(start: 0, end: self.matches.count) {
                    let match = self.matches[matchIndex]
                    if match.number == number {
                        
                        self.matches[matchIndex] = self.makeMatchFromSnapshot(snapshot)
                        if match.redScore == nil && self.matches[matchIndex].redScore != nil {
                        }
                        self.notificationManager.queueNote("updateLeftTable", specialObject: nil)
                    }
                }
                })
            
            let teamReference = self.firebase.child("Teams")
            teamReference.observeEventType(.ChildAdded, withBlock: { [unowned self] snapshot in
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
                    let team = self.makeTeamFromSnapshot(snapshot)
                    if let num = team.number as? Int {
                        self.updateCacheIfNeeded(snapshot, team: self.getTeam(num))
                        dispatch_async(dispatch_get_main_queue()) {
                            self.teams.append(team)
                            self.notificationManager.queueNote("updateLeftTable", specialObject: team)
                        }
                    }
                })
                })
            
            teamReference.observeEventType(.ChildChanged, withBlock: { [unowned self] snapshot in
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
                    self.teamCounter++
                    let team = self.makeTeamFromSnapshot(snapshot)
                    if team.number != nil {
                        self.updateCacheIfNeeded(snapshot, team: team)
                        dispatch_async(dispatch_get_main_queue()) {
                            let te = self.teams.filter({ (t) -> Bool in
                                if t.number == team.number { return true }
                                return false
                            })
                            if let index = self.teams.indexOf(te[0]) {
                                self.teams[index] = team
                                
                                self.notificationManager.queueNote("updateLeftTable", specialObject: team)
                                self.NSCounter = 0
                                self.teamCounter = 0
                                
                            }
                        }
                    }
                })
                })
            
            let timdRef = self.firebase.child("TeamInMatchDatas")
            timdRef.observeEventType(.ChildAdded, withBlock: { [unowned self] (snap) -> Void in
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
                    let timd = self.getTeamInMatchDataForDict(snap.value as! NSDictionary, key: snap.key)
                    let team = self.getTeam(timd!.teamNumber as! Int)
                    dispatch_async(dispatch_get_main_queue()) {
                        team.TeamInMatchDatas.append(timd!)
                        
                        self.teamInMatches.append(timd!)
                        self.notificationManager.queueNote("updateLeftTable", specialObject: nil)
                    }
                })
                })
            
            timdRef.observeEventType(.ChildChanged, withBlock: { [unowned self] (snap) -> Void in
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
                    self.TIMDCounter += 1
                    let timd = self.getTeamInMatchDataForDict(snap.value as! NSDictionary, key: snap.key)
                    dispatch_async(dispatch_get_main_queue()) {
                        let tm = self.teamInMatches.filter({ (t) -> Bool in
                            if t.teamNumber == timd!.teamNumber && t.matchNumber == timd!.matchNumber { return true }
                            return false
                        })
                        if let index = self.teamInMatches.indexOf(tm[0]) {
                            self.teamInMatches[index] = timd!
                        }
                        let team = self.getTeam(timd?.teamNumber as! Int)
                        let i = team.TeamInMatchDatas.indexOf { $0.matchNumber == timd!.matchNumber }
                        if i != nil {
                            team.TeamInMatchDatas[i!] = timd!
                        }
                    }
                })
                })
            
            self.firstCurrentMatchUpdate = false
            
            let currentMatchFetch = self.getMatch(self.currentMatchManager.currentMatch)
            let m : [String: AnyObject] = ["num":self.currentMatchManager.currentMatch, "redTeams": currentMatchFetch.redAllianceTeamNumbers ?? [0,0,0], "blueTeams": currentMatchFetch.blueAllianceTeamNumbers ?? [0,0,0]]
            NSUserDefaults.standardUserDefaults().setObject(m, forKey: "match")
            })
        
    }
    
    func getTIMDataForTeam(team: Team) -> [TeamInMatchData] {
        return self.teamInMatches.filter { $0.teamNumber == team.number }
    }
    
    func getTimDataForTeamInMatch(team:Team, inMatch: Match) -> TeamInMatchData? {
        let TIMData = self.getTIMDataForTeam(team)
        if TIMData.count > 0 {
            let correctTIMDs = TIMData.filter { $0.matchNumber == inMatch.matchNumber} //Hopefully there is exactly one
            if correctTIMDs.count == 1 {
                return correctTIMDs[0]
            }
        }
        print("Problem geting TIMData")
        return nil
    }
    
    func getTeam(teamNum: Int) -> Team {
        return teams.filter { $0.number as! Int == teamNum }[0]
    }
    
    func getMatch(matchNum: Int) -> Match {
        return matches.filter { $0.number as! Int == matchNum }[0]
    }
    
    func getTeamsFromNumbers(teamNums: [Int]?) -> [Team] {
        var teams = [Team]()
        if teamNums != nil {
            for teamNum in teamNums! {
                teams.append(self.getTeam(teamNum))
            }
        }
        return teams
    }
    
    func allTeamsInMatch(match: Match) -> [Team]  {
        let redTeams = getTeamsFromNumbers(match.redAllianceTeamNumbers! as? [Int])
        let blueTeams = getTeamsFromNumbers(match.blueAllianceTeamNumbers! as? [Int])
        return redTeams + blueTeams
    }
    
    func getMatchesForTeamWithNumber(number:Int) -> [Match] {
        var array = [Match]()
        for match in self.matches {
            for teamNumber in match.redAllianceTeamNumbers! {
                if teamNumber == number {
                    array.append(match)
                }
            }
            for teamNumber in match.blueAllianceTeamNumbers! {
                if teamNumber == number {
                    array.append(match)
                }
            }
        }
        return array.sort { Int($0.number!) < Int($1.number!) }
    }
    
    func matchNumbersForTeamNumber(number: Int) -> [NSNumber] {
        func matchNum(match : Match) -> NSNumber {
            return match.number!
        }
        return self.getMatchesForTeamWithNumber(number).map(matchNum)
    }
    
    func getMatchesForTeam(teamNumbah: Int) -> [Match] {
        var matches = [Match]()
        for match in self.matches {
            let teamNumArray = (match).redAllianceTeamNumbers! + match.blueAllianceTeamNumbers!
            for number in teamNumArray {
                if number == teamNumbah {
                    matches.append(match)
                }
            }
        }
        matches.sortInPlace { Int($0.number!) > Int($1.number!) }
        return matches
    }
    
    
    // MARK: Rank
    func getFirstPickList() -> [Team] {
        return teams.sort { $0.calculatedData?.firstPickAbility?.floatValue > $1.calculatedData!.firstPickAbility?.floatValue }
    }
    
    func getOverallSecondPickList() -> [Team] {
        return self.teams.sort { $0.calculatedData?.overallSecondPickAbility?.floatValue > $1.calculatedData?.overallSecondPickAbility?.floatValue }
    }
    
    func getConditionalSecondPickList(teamNum: Int) -> [Team] {
        var tupleArray = [(Team,Int)]()
        for team in teams {
            if(team.calculatedData?.secondPickAbility?.objectForKey(String(teamNum)) != nil) {
                tupleArray.append(team, ((team.calculatedData!.secondPickAbility!.objectForKey(String(teamNum))) as? Int)!)
            }
        }
        let sortedTuple = tupleArray.sort { $0.1 > $1.1 }
        var teamArray = [Team]()
        for (k,_) in sortedTuple {
            teamArray.append(k)
        }
        return teamArray
    }
    
    func seedList() -> [Team] {
        return teams.sort { $0.calculatedData!.actualSeed?.floatValue < $1.calculatedData!.actualSeed?.floatValue }
    }
    
    func predSeedList() -> [Team] {
        return teams.sort { $0.calculatedData!.predictedSeed?.floatValue < $1.calculatedData!.predictedSeed?.floatValue }
    }
    
    func predictedRPsKeyForTeamNum(teamNumber: Int, matchNum: Int) -> String {
        let match = getMatch(matchNum)
        if ((match.redAllianceTeamNumbers?.contains(teamNumber)) != nil) {
            return "calculatedData.predictedRedRPs"
        } else {
            return "calculatedData.predictedBlueRPs"
        }
    }
    
    func rankOfTeam(team: Team, withCharacteristic: String) -> Int {
        var counter = 0
        let sortedTeams : [Team] = self.getSortedListbyString(withCharacteristic)
        
        for loopTeam in sortedTeams {
            counter++
            if loopTeam.number == team.number?.integerValue {
                return counter
            }
        }
        return counter
    }
    
    func reverseRankOfTeam(team: Team, withCharacteristic:String) -> Int {
        var counter = 0
        let sortedTeams : [Team] = self.getSortedListbyString(withCharacteristic).reverse()
        
        for loopTeam in sortedTeams {
            counter++
            if loopTeam.number == team.number?.integerValue {
                return counter
            }
        }
        return counter
    }
    
    func ranksOfTeamInMatchDatasWithCharacteristic(characteristic: NSString, forTeam: Team) -> [Int] {
        var array = [Int]()
        let TIMDatas = forTeam.TeamInMatchDatas
        for timData in TIMDatas {
            array.append(self.rankOfTeamInMatchData(timData, withCharacteristic: characteristic))
        }
        return array
    }
    
    func rankOfTeamInMatchData(timData: TeamInMatchData, withCharacteristic: NSString) -> Int {
        var values = [Int]()
        let teamNum = timData.teamNumber!.integerValue
        let TIMDatas = self.getTeam(teamNum).TeamInMatchDatas
        for timData in TIMDatas {
            values.append((timData.matchNumber?.integerValue)!)
        }
        return values.indexOf(teamNum)! + 1
    }
    
    func ranksOfTeamsWithCharacteristic(characteristic: NSString) -> [Int] {
        var array = [Int]()
        for team in self.teams {
            array.append(self.rankOfTeam(team, withCharacteristic: characteristic as String))
        }
        return array
    }
    
    func getSortedListbyString(path: String) -> [Team] {
        return teams.sort({ (t1, t2) -> Bool in
            if let t1v = t1.valueForKeyPath(path) {
                if let t2v = t2.valueForKeyPath(path) {
                    if t1v.doubleValue > t2v.doubleValue {
                        return true
                    }
                }
            }
            
            return false
        })
    }
    
    
    
    // MARK: Getting Custom Objects From Dictionaries
    func getMatchCalculatedDatafromDict(dict: NSDictionary?) -> MatchCalculatedData {
        let matchData = MatchCalculatedData()
        if dict != nil {
            for key in matchData.propertys() {
                matchData.setValue(dict!.objectForKey(key), forKey: key)
            }
        }
        return matchData
    }
    
    func getcalcDataForTeamFromDict(dict: NSDictionary?) -> CalculatedTeamData {
        let calcData = CalculatedTeamData()
        if dict != nil {
            for key in calcData.propertys() {
                let value = dict!.objectForKey(key)
                calcData.setValue(value, forKey: key)
            }
            for key in Utils.defenseKeys {
                if let obj = dict!.objectForKey(key) as? NSDictionary {
                    calcData.setValue(obj, forKey: key)
                }
            }
        }
        return calcData
    }
    
    func getCalculatedTeamInMatchDataForDict(dict: NSDictionary?) -> TeamInMatchCalculatedData {
        if dict != nil {
            let CTIMD = TeamInMatchCalculatedData()
            for key in CTIMD.propertys() {
                if let value = dict!.objectForKey(key) {
                    CTIMD.setValue(value, forKey: key)
                }
            }
            return CTIMD
        }
        return TeamInMatchCalculatedData()
    }
    
    func getTeamInMatchDataForDict(dict: NSDictionary, key: String) -> TeamInMatchData? {
        let TIMData = TeamInMatchData()
        for key in TIMData.propertys() {
            let value = dict.objectForKey(key)
            if key == "calculatedData" {
                TIMData.calculatedData = self.getCalculatedTeamInMatchDataForDict(value as? NSDictionary)
            } else {
                if value != nil {
                    TIMData.setValue(value, forKey: key)
                }
            }
        }
        
        let matchIDParts = key.componentsSeparatedByString("Q")
        TIMData.teamNumber = Int(matchIDParts[0])
        TIMData.matchNumber = Int(matchIDParts[1])
        
        return TIMData
    }
    
    func getAverageDefenseValuesForDict(dict: NSDictionary) -> [Int] {
        var valueArray = [Int]()
        let keyArray = dict.allKeys as? [String]
        for key in keyArray! {
            let subDict = dict.objectForKey(key) as? NSDictionary
            let subKeyArray = subDict?.allKeys
            
            for subKey in subKeyArray! {
                valueArray.append((subDict!.objectForKey(subKey) as? Int)!)
            }
        }
        return valueArray
    }
    
    
    // MARK: Search Bar
    
    func filteredMatchesForMatchSearchString(searchString:String) -> [Match] {
        var filteredMatches = [Match]()
        for match in self.matches  {
            if String(match.number).rangeOfString(searchString) != nil {
                filteredMatches.append(match)
            }
        }
        return filteredMatches
    }
    
    func filteredMatchesforTeamSearchString(searchString: String) -> [Match] {
        var filteredMatches = [Match]()
        for match in self.matches  {
            for teamNum in match.redAllianceTeamNumbers! {
                if String(teamNum).rangeOfString(searchString) != nil {
                    filteredMatches.append(match)
                }
            }
            for teamNum in match.blueAllianceTeamNumbers! {
                if String(teamNum).rangeOfString(searchString) != nil {
                    filteredMatches.append(match)
                }
            }
        }
        return filteredMatches
    }
    
    func filteredTeamsForSearchString(searchString: String) -> [Team] {
        var filteredTeams = [Team]()
        for team in self.teams {
            if String(team.number).rangeOfString(searchString) != nil {
                filteredTeams.append(team)
            }
        }
        return filteredTeams
    }
    
    
    
    // MARK: Grapher Class
    func valuesInTeamMatchesOfPath(path: NSString, forTeam: Team) -> NSArray {
        let array = NSMutableArray()
        let teamInMatchDatas = self.getTIMDataForTeam(forTeam)
        for data in teamInMatchDatas {
            array.addObject((data.valueForKeyPath(path as String)! as? Int)!)
        }
        return array
    }
    
    func valuesInCompetitionOfPathForTeams(path: String) -> NSArray {
        let array = NSMutableArray()
        for team in self.teams {
            if team.valueForKeyPath(path) != nil {
                array.addObject(team.valueForKeyPath(path)!)
            }
        }
        return array
    }
    
    /**
     Used by the graphing class If you get -1111.1 for any of the values, that means you haz problem.
     
     - parameter path:    Path to datapoint. Uses `match.valueForKeyPath(path)`.
     - parameter forTeam: The team you want the datapoint for.
     
     - returns: The second value in the tuple is the alternate value mapping. E.g. Yes and No instead of 1 and 0
     */
    func getMatchDataValuesForTeamForPath(var path: String, forTeam: Team) -> ([Float], [CGFloat : String]?) {
        let matches = getMatchesForTeam(forTeam.number as! Int)
        var valueArray = [Float]()
        var altValueMapping : [CGFloat : String]?
        
        for match in matches {
            let value : AnyObject?
            if path == "calculatedData.predictedNumRPs" {
                path = predictedRPsKeyForTeamNum(forTeam.number as! Int, matchNum: match.number as! Int)
            }
            value = match.valueForKeyPath(path)
            
            if value != nil {
                if let floatVal = value as? Float {
                    valueArray.append(floatVal)
                    
                } else { // Pretty much, if its false it's 0, if its true it's 1
                    altValueMapping = [CGFloat(1.0): "Yes", CGFloat(0.0): "No"]
                    
                    let boolValue: Bool
                    if let boolBoolValue = value as? Bool { //Such ugly
                        boolValue = boolBoolValue
                    } else {
                        boolValue = value as? String == "true" ? true : false
                    }
                    valueArray.append((boolValue ? 1.0 : 0.0))
                }
            } else {
                print("You haz problem with getMatchDataValuesForTeamForPath")
                valueArray.append(-1111.1)
            }
        }
        return (valueArray, altValueMapping)
    }
    /**
     See Description for `getMatchDataValuesForTeamForPath`
     */
    func getMatchValuesForTeamForPath(path: String, forTeam: Team) -> ([Float], [CGFloat : String]?) {
        var timDatas = getTIMDataForTeam(forTeam)
        timDatas.sortInPlace { Int($0.matchNumber!) < Int($1.matchNumber!) }
        
        let sortedTimDatas = timDatas.sort { $0.matchNumber!.integerValue < $1.matchNumber?.integerValue }
        var valueArray = [Float]()
        var altValueMapping : [CGFloat: String]?
        
        for timData in sortedTimDatas {
            let value : AnyObject?
            value = timData.valueForKeyPath(path)
            
            if value != nil {
                
                if let floatVal = value as? Float {
                    valueArray.append(floatVal)
                    
                } else { // Pretty much, if its false it's 0, if its true it's 1
                    altValueMapping = [CGFloat(1.0): "Yes", CGFloat(0.0): "No"]
                    
                    let boolValue: Bool
                    if let boolBoolValue = value as? Bool { //Such ugly, its for when ppl screw up something on firebase changing values by hand.
                        boolValue = boolBoolValue
                    } else {
                        boolValue = value as? String == "true" ? true : false
                    }
                    valueArray.append((boolValue ? 1.0 : 0.0))
                }
            } else {
                print("You haz problem with getMatchValuesForTeamForPath")
                valueArray.append(-1111.1)
            }
        }
        return (valueArray, altValueMapping)
    }
    /**
     See Description for `getMatchDataValuesForTeamForPath`
     */
    func getMatchValuesForTeamForPathForDefense(path: String, forTeam: Team, defenseKey: String) -> ([Float], [CGFloat : String]?) {
        var timDatas = getTIMDataForTeam(forTeam)
        timDatas.sortInPlace { Int($0.matchNumber!) < Int($1.matchNumber!) }
        
        let sortedTimDatas = timDatas.sort { $0.matchNumber!.integerValue < $1.matchNumber?.integerValue }
        var valueArray = [Float]()
        var altValueMapping : [CGFloat: String]?
        
        for timData in sortedTimDatas {
            let value : AnyObject?
            //print(timData.matchNumber!.integerValue)
            let m = self.getMatch(timData.matchNumber as! Int)
            if m.redDefensePositions != nil {
                if (m.redAllianceTeamNumbers!.filter {$0 == timData.teamNumber}).count > 0 {
                    if (m.redDefensePositions!.filter {$0 == defenseKey}).count > 0 {
                        value = timData.valueForKeyPath(path)
                    } else {
                        value = 0.0
                    }
                } else {
                    if (m.blueDefensePositions!.filter {$0 == defenseKey}).count > 0 {
                        value = timData.valueForKeyPath(path)
                    } else {
                        value = 0.0
                    }
                }
            } else {
                value = 0.0
            }
            
            if value != nil {
                
                if let floatVal = value as? Float {
                    valueArray.append(floatVal)
                    
                } else { // Pretty much, if its false it's 0, if its true it's 1
                    altValueMapping = [CGFloat(1.0): "Yes", CGFloat(0.0): "No"]
                    
                    let boolValue: Bool
                    if let boolBoolValue = value as? Bool { //Such ugly
                        boolValue = boolBoolValue
                    } else {
                        boolValue = value as? String == "true" ? true : false
                    }
                    valueArray.append((boolValue ? 1.0 : 0.0))
                }
            } else {
                valueArray.append(0.0)
            }
        }
        return (valueArray, altValueMapping)
    }
    
    // MARK: Dealing With Current Match
    /**
    This puts up the little banner at the top, and increases the badge number on the app.
    
    - parameter notificationBody: What the text of the notification should be (that the person reads).
    */
    func postNotification(notificationBody:String) {
        let localNotification = UILocalNotification()
        localNotification.fireDate = NSDate(timeIntervalSinceNow: 1)
        localNotification.alertBody = notificationBody
        localNotification.timeZone = NSTimeZone.defaultTimeZone()
        localNotification.soundName = UILocalNotificationDefaultSoundName
        localNotification.applicationIconBadgeNumber = UIApplication.sharedApplication().applicationIconBadgeNumber + 1
        UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
    }
    
    func getCurrentMatch() -> Int {
        let sortedMatches = self.matches.sort { $0.number?.integerValue > $1.number?.integerValue }
        var counter = self.matches.count + 1
        for match in sortedMatches {
            counter -= 1
            if match.redScore != nil || match.redScore?.integerValue != nil {
                return counter
            }
        }
        return 0
    }
    
    func matchesUntilTeamNextMatch(teamNumber : Int) -> String? {
        let sortedMatches = self.matches.sort { Int($0.number!) < Int($1.number!) }
        if let indexOfCurrentMatch = sortedMatches.indexOf(self.getMatch(self.getCurrentMatch() + 1)) {
            var counter = 0
            for i in indexOfCurrentMatch + 1..<self.matches.count {
                let match = sortedMatches[i]
                counter++
                if (match.redAllianceTeamNumbers?.filter { Int($0) == teamNumber }.count != 0) || (match.blueAllianceTeamNumbers?.filter { Int($0) == teamNumber }.count != 0) {
                    return "\(counter)"
                }
            }
        }
        return nil
    }
    
    func remainingMatchesForTeam(teamNum:Int) -> Int {
        let matchArray = getMatchesForTeam(teamNum)
        var remainingArray = [Match]()
        for match in matchArray {
            if match.number?.integerValue > self.currentMatchManager.currentMatch {
                remainingArray.append(match)
            }
        }
        return remainingArray.count
    }
    
}

/// Custom Class for managing NSNotifications about things. Not to be confused with the kind of notifications that pop up and make a dinging sound on your phone.
class NotificationManager : NSObject {
    let timer = NSTimer()
    let secsBetweenUpdates : Double
    var notifications : [Notification]
    var notificationNamesToPost = [String: AnyObject?]()
    
    struct Notification {
        let name : String
        var selector : String?
        var object : AnyObject?
        
        init(name : String, selector : String?, object: AnyObject?) {
            self.selector = nil
            if selector != nil {
                if selector!.rangeOfString(":") == nil {
                    print("Notification Selector Function Must have exactly one parameter, an NSNotification Object")
                    self.selector = selector
                }
            }
            self.name = name
            self.object = object
        }
        
        init(name : String) {
            self.name = name
            self.selector = nil
            self.object = nil
        }
    }
    
    init (secsBetweenUpdates : Double, notifications: [Notification]) {
        self.secsBetweenUpdates = secsBetweenUpdates
        self.notifications = notifications
        super.init()
        
        for note in notifications {
            if let selector = note.selector {
                NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector(selector), name: note.name, object: nil)
            }
        }
        NSTimer.scheduledTimerWithTimeInterval(secsBetweenUpdates, target: self, selector: "notify:", userInfo: nil, repeats: false)
        
    }
    
    func queueNote(name: String, specialObject: AnyObject?) {
        self.notificationNamesToPost[name] = specialObject
    }
    
    func postNotification(noteName : String, specialObject : AnyObject?) {
        let noteArray = self.notifications.filter { $0.name == noteName }
        if noteArray.count > 0 {
            let note = noteArray[0]
            if specialObject != nil {
                NSNotificationCenter.defaultCenter().postNotificationName(note.name, object: specialObject, userInfo: nil)
            } else {
                NSNotificationCenter.defaultCenter().postNotificationName(note.name, object: note.object, userInfo: nil)
            }
        }
    }
    
    func notify(timer : NSTimer) {
        for (noteName, specialObject) in self.notificationNamesToPost {
            postNotification(noteName, specialObject: specialObject)
        }
        notificationNamesToPost = [String: AnyObject?]()
        self.timer.invalidate()
        NSTimer.scheduledTimerWithTimeInterval(secsBetweenUpdates, target: self, selector: "notify:", userInfo: nil, repeats: false)
    }
}