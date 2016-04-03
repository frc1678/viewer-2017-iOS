//
//  FirebaseDataFetcher.swift
//  scout-viewer-2015-iOS
//
//  Created by Samuel Resendez on 1/23/16.
//  Copyright © 2016 Citrus Circuits. All rights reserved.
//

import UIKit
//import firebase_schema_2016_ios
import Firebase
import Sync
import DATAStack
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
    let firebaseURLFirstPart = "https://1678-dev3-2016.firebaseio.com/"
    let scoutingToken = "qVIARBnAD93iykeZSGG8mWOwGegminXUUGF2q0ee"
    let dev3Token = "AEduO6VFlZKD4v10eW81u9j3ZNopr5h2R32SPpeq"
    let dev2Token = "hL8fStivTbHUXM8A0KXBYPg2cMsl80EcD7vgwJ1u"
    let devToken = "j1r2wo3RUPMeUZosxwvVSFEFVcrXuuMAGjk6uPOc"
    let stratDevToken = "IMXOxXD3FjOOUoMGJlkAK5pAtn89mGIWAEnaKJhP"
    var matches = [Match]()
    var teamInMatches = [TeamInMatchData]()
    var imageUrls = Dictionary<Int,String>()
    var allTheData = NSDictionary()
    
    var teamInMatchKeys = [
        "firstPickAbility",
        "ballsIntakedAuto",
        "matchNumber",
        "numBallsKnockedOffMidlineAuto",
        "numGroundIntakesTele",
        "numHighShotsMadeAuto",
        "numHighShotsMadeTele",
        "numHighShotsMissedAuto",
        "numHighShotsMissedTele",
        "numLowShotsMadeAuto",
        "numLowShotsMadeTele",
        "numLowShotsMissedAuto",
        "numLowShotsMissedTele",
        "numShotsBlockedTele",
        "rankBallControl",
        "rankDefense",
        "rankAgility",
        "rankSpeed",
        "rankTorque",
        "teamNumber",
        "timesCrossedDefensesAuto",
        "timesCrossedDefensesTele",
    ]
    
    var defenseKeys = ["avgFailedTimesCrossedDefensesAuto",
        "avgFailedTimesCrossedDefensesTele",
        "avgSuccessfulTimesCrossedDefensesAuto",
        "avgSuccessfulTimesCrossedDefensesTele",
        "sdFailedDefenseCrossesAuto"
    ]
    
    var teamCalcKeys = [
        "actualSeed",
        "avgBallControl",
        "avgBallsKnockedOffMidlineAuto",
        "avgDefense",
        "avgEvasion",
        "avgFailedTimesCrossedDefensesAuto",
        "avgFailedTimesCrossedDefensesTele",
        "avgGroundIntakes",
        "avgHighShotsAuto",
        "avgHighShotsTele",
        "avgLowShotsAuto",
        "avgLowShotsTele",
        "avgMidlineBallsIntakedAuto",
        "avgShotsBlocked",
        "avgSpeed",
        "avgSuccessfulTimesCrossedDefensesAuto",
        "avgTorque",
        "challengePercentage",
        "disabledPercentage",
        "disfunctionalPercentage",
        "firstPickAbility",
        "highShotAccuracyAuto",
        "highShotAccuracyTele",
        "incapacitatedPercentage",
        "lowShotAccuracyAuto",
        "lowShotAccuracyTele",
        "numAutoPoints",
        "actualNumRPs",
        "predictedNumRPs",
        "numScaleAndChallengePoints",
        "predictedSeed",
        "reachPercentage",
        "scalePercentage",
        "sdBallsKnockedOffMidlineAuto",
        "sdFailedDefenseCrossesAuto",
        "sdFailedDefenseCrossesTele",
        "sdGroundIntakes",
        "sdHighShotsAuto",
        "sdHighShotsTele",
        "sdLowShotsAuto",
        "sdLowShotsTele",
        "sdMidlineBallsIntakedAuto",
        "sdShotsBlocked",
        "sdSuccessfulDefenseCrossesAuto",
        "sdSuccessfulDefenseCrossesTele",
        "overallSecondPickAbility",
        "secondPickAbility",
        "siegeAbility",
        "siegeConsistency"
    ]
    
    let calculatedTeamInMatchDataKeys = [
        "calculatedData.firstPickAbility",
        "calculatedData.RScoreTorque",
        "calculatedData.RScoreEvasion",
        "calculatedData.RScoreSpeed",
        "calculatedData.highShotAccuracyAuto",
        "calculatedData.lowShotAccuracyAuto",
        "calculatedData.highShotAccuracyTele",
        "calculatedData.lowShotAccuracyTele",
        "calculatedData.siegeAbility",
        "calculatedData.numRPs",
        "calculatedData.numAutoPoints",
        "calculatedData.numScaleAndChallengePoints",
        "calculatedData.RScoreDefense",
        "calculatedData.RScoreBallControl",
        "calculatedData.RScoreDrivingAbility",
        "calculatedData.citrusDPR",
        "calculatedData.secondPickAbility",
        "calculatedData.overallSecondPickAbility",
        "calculatedData.scoreContribution"
    ]
    let calculatedTIMDataKeys = [
        "firstPickAbility",
        "RScoreTorque",
        "RScoreEvasion",
        "RScoreSpeed",
        "highShotAccuracyAuto",
        "lowShotAccuracyAuto",
        "highShotAccuracyTele",
        "lowShotAccuracyTele",
        "siegeAbility",
        "actualNumRPs",
        "numAutoPoints",
        "numScaleAndChallengePoints",
        "RScoreDefense",
        "RScoreBallControl",
        "RScoreDrivingAbility",
        "citrusDPR",
        "overallSecondPickAbility",
        "scoreContribution"
    ]
    let firebase : Firebase
    
    
    
    override init() {
        firebase = Firebase(url: self.firebaseURLFirstPart)
        self.currentMatchManager = CurrentMatchManager()
        self.notificationManager = NotificationManager(secsBetweenUpdates: 5, notifications: [])
        super.init()
        
        self.notificationManager.notifications.append(NotificationManager.Notification(name: "updateLeftTable"))
        //self.notificationManager.notifications.append(NotificationManager.Notification(name: "currentMatchUpdated"))
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), {
            self.getAllTheData()
        })
        
    }
    
    
    func makeMatchFromSnapshot(snapshot: FDataSnapshot) -> Match {
        let match = Match()
        
        for key in Match().propertys() {
            if key == "calculatedData" {
                match.calculatedData = self.getMatchCalculatedDatafromDict(snapshot.value.objectForKey("calculatedData") as? NSDictionary)
            } else {
                match.setValue(snapshot.value.objectForKey(key), forKey: key)
            }
        }
        /*
        match.blueAllianceTeamNumbers = (snapshot.value.objectForKey("blueAllianceTeamNumbers") as? [Int])
        match.blueDefensePositions = (snapshot.value.objectForKey("blueDefensePositions") as? [String])
        match.blueScore = (snapshot.value.objectForKey("blueScore") as? Int)
        let calculatedDict = (snapshot.value.objectForKey("calculatedData") as? NSDictionary)
        match.calculatedData = self.getMatchCalculatedDatafromDict(calculatedDict)
        
        match.number = (snapshot.value.objectForKey("number") as? Int)
        match.redAllianceTeamNumbers = (snapshot.value.objectForKey("redAllianceTeamNumbers") as? [Int])
        match.redDefensePositions = (snapshot.value.objectForKey("redDefensePositions") as? [String])
        match.redScore = (snapshot.value.objectForKey("redScore") as? Int)
        */
        return match
    }
    
    func makeTeamFromSnapshot(snapshot: FDataSnapshot) -> Team {
        let team = Team()
        if let v = snapshot.value as? NSDictionary {
            if let _ = (v.objectForKey("name") as? String) {
                
                for key in team.propertys() {
                    if key == "calculatedData" {
                        let teamCDDict = (v.objectForKey("calculatedData") as? NSDictionary)
                        team.calculatedData = self.getcalcDataForTeamFromDict(teamCDDict)
                    } else {
                        team.setValue(snapshot.value.objectForKey(key), forKey: key)
                        
                    }
                }
            }
        }
        return team
    }
    
    func getDataFromUrl(url:NSURL, completion: ((data: NSData?, error: NSError? ) -> Void)) {
        NSURLSession.sharedSession().dataTaskWithURL(url) {  (data, _, error) in //Should already be async
            completion(data: data, error: error)
            //
            
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
    
    func fetchImageForTeam(teamNumber : Int, fetchedCallback : (UIImage)->(), couldNotFetch: ()->()) { // Is already async
        self.imageCache.fetch(key: "\(teamNumber)").onSuccess { (image) -> () in
            fetchedCallback(image)
            }.onFailure { (E) -> () in
                couldNotFetch()
        }
    }
    
    func updateCacheIfNeeded(snap : FDataSnapshot, team : Team) {
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
    
    func getAllTheData() {
        
        firebase.authWithCustomToken(dev3Token) { [unowned self] (E, A) -> Void in //TOKENN
            
            self.firebase.observeSingleEventOfType(.Value, withBlock: { [unowned self] (snap) -> Void in
                let matchReference = Firebase(url: "\(self.firebaseURLFirstPart)/Matches")
                
                matchReference.observeEventType(.ChildAdded, withBlock: { [unowned self] snapshot in
                    self.matches.append(self.makeMatchFromSnapshot(snapshot))
                    self.currentMatchManager.currentMatch = self.getCurrentMatch()
                    if self.hasUpdatedMatchOnSetup == false {
                        self.hasUpdatedMatchOnSetup = true
                        //self.getCurrentMatch()
                        self.notificationManager.queueNote("updateLeftTable", specialObject: nil)
                        
                    }
                    
                    
                    
                    })

                
                
                matchReference.observeEventType(.ChildChanged, withBlock: { [unowned self] snapshot in
                    self.matchCounter++
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
                
                
                
                let teamReference = Firebase(url:"\(self.firebaseURLFirstPart)/Teams")
                teamReference.observeEventType(.ChildAdded, withBlock: { [unowned self] snapshot in
                    
                    let team = self.makeTeamFromSnapshot(snapshot)
                    self.updateCacheIfNeeded(snapshot, team: self.fetchTeam(team.number as! Int))
                    self.teams.append(team)
                    
                    self.notificationManager.queueNote("updateLeftTable", specialObject: team)
                    
                    })
                
                
                teamReference.observeEventType(.ChildChanged, withBlock: { [unowned self] snapshot in
                    self.teamCounter++
                    let team = self.makeTeamFromSnapshot(snapshot)
                    self.updateCacheIfNeeded(snapshot, team: team)
                    
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
                    })
                
                //Here
                
                let timdRef = Firebase(url:"\(self.firebaseURLFirstPart)/TeamInMatchDatas")
                timdRef.observeEventType(.ChildAdded, withBlock: { [unowned self] (snap) -> Void in
                    
                    
                    let timd = self.getTeamInMatchDataForDict(snap.value as! NSDictionary, key: snap.key)
                    let team = self.fetchTeam(timd!.teamNumber as! Int)
                    team.TeamInMatchDatas.append(timd!)
                    
                    self.teamInMatches.append(timd!)
                    self.notificationManager.queueNote("updateLeftTable", specialObject: nil)
                    
                    })
                
                timdRef.observeEventType(.ChildChanged, withBlock: { [unowned self] (snap) -> Void in
                    self.TIMDCounter += 1
                    let timd = self.getTeamInMatchDataForDict(snap.value as! NSDictionary, key: snap.key)
                    
                    let tm = self.teamInMatches.filter({ (t) -> Bool in
                        if t.teamNumber == timd!.teamNumber && t.matchNumber == timd!.matchNumber { return true }
                        return false
                    })
                    if let index = self.teamInMatches.indexOf(tm[0]) {
                        self.teamInMatches[index] = timd!
                    }
                    let team = self.fetchTeam(timd?.teamNumber as! Int)
                    let i = team.TeamInMatchDatas.indexOf { $0.matchNumber == timd!.matchNumber }
                    if i != nil {
                        team.TeamInMatchDatas[i!] = timd!
                    }
                    })
                
                self.firstCurrentMatchUpdate = false
            })
        }
    }
    
    func getTIMDataForTeam(team: Team) -> [TeamInMatchData] {
        var array = [TeamInMatchData]()
        for TIM in self.teamInMatches {
            if TIM.teamNumber == team.number {
                array.append(TIM)
            }
        }
        return array
    }
    
    func getTimDataForTeamInMatch(team:Team, inMatch:Match) -> TeamInMatchData? {
        let TIMDatas = getTIMDataForTeam(team)
        for TIMData in TIMDatas {
            if TIMData.matchNumber?.integerValue == inMatch.matchNumber?.integerValue {
                return TIMData
            }
        }
        return nil
    }
    
    func fetchTeam(teamNum: Int) -> Team{
        for team in self.teams {
            if team.number == teamNum {
                return team
            }
        }
        return Team()
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
    
    func getTeamsFromNumbers(teamNums: [Int]?) -> [Team] {
        var teams = [Team]()
        if teamNums != nil {
            for teamNum in teamNums! {
                teams.append(self.fetchTeam(teamNum))
            }
        }
        return teams
    }
    
    func getTeamInMatchDatasForTeam(team: Team) -> [TeamInMatchData]{
        let ref = Firebase(url:"\(self.firebaseURLFirstPart)/TeamInMatchDatas")
        var TIMDatas = [TeamInMatchData]()
        if let teamNumber = team.number {
            let teamNum = "\(teamNumber)"
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), {
                ref.observeEventType(.ChildAdded, withBlock: { datasnapshot in
                    if datasnapshot.key.containsString(teamNum) {
                        let TIMData = self.getTeamInMatchDataForDict((datasnapshot.value as? NSDictionary)!, key: datasnapshot.key)
                        if TIMData != nil {
                            TIMData!.identifier = datasnapshot.key
                            let TIMCalcData = self.getCalculatedTeamInMatchDataForDict((datasnapshot.childSnapshotForPath("calculatedData").value as? NSDictionary))
                            TIMData!.calculatedData = TIMCalcData
                            TIMDatas.append(TIMData!)
                            self.teamInMatches.append(TIMData!)
                            team.TeamInMatchDatas.append(TIMData!)
                        }
                    }
                })
            })
        }
        return TIMDatas
    }
    
    func valuesInTeamMatchesOfPath(path: NSString, forTeam: Team) -> NSArray {
        let array = NSMutableArray()
        let teamInMatchDatas = self.getTIMDataForTeam(forTeam)
        for data in teamInMatchDatas {
            array.addObject((data.valueForKeyPath(path as String)! as? Int)!)
        }
        return array
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
        let TIMDatas = self.fetchTeam(teamNum).TeamInMatchDatas
        for timData in TIMDatas {
            values.append((timData.matchNumber?.integerValue)!)
        }
        return values.indexOf(teamNum)! + 1
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
    
    func ranksOfTeamsWithCharacteristic(characteristic: NSString) -> [Int] {
        var array = [Int]()
        for team in self.teams {
            array.append(self.rankOfTeam(team, withCharacteristic: characteristic as String))
        }
        return array
    }
    
    func getTeamPDFImage(team: Int) -> UIImage {
        let pdfImage = UIImage()
        return pdfImage
    }
    
    func fetchMatch(matchNum: Int) -> Match {
        for m in self.matches {
            if m.number == matchNum {
                return m
            }
        }
        return Match()
    }
    
    func allTeamsInMatch(match: Match) -> [Team]  {
        let redTeams = getTeamsFromNumbers(match.redAllianceTeamNumbers! as? [Int])
        let blueTeams = getTeamsFromNumbers(match.blueAllianceTeamNumbers! as? [Int])
        return redTeams + blueTeams
    }
    
    func fetchMatchesForTeamWithNumber(number:Int) -> [Match] {
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
        array.sortInPlace { Int($0.number!) < Int($1.number!) }
        return array
    }
    
    func matchNumbersForTeamNumber(number: Int) -> [NSNumber] {
        let matches = self.fetchMatchesForTeamWithNumber(number)
        var matchNumbers = [NSNumber]()
        for match in matches {
            matchNumbers.append(match.number!)
        }
        
        return matchNumbers
    }
    
    func getMatchCalculatedDatafromDict(dict:NSDictionary?) -> MatchCalculatedData {
        
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
            
            for key in self.defenseKeys {
                if let obj = dict!.objectForKey(key) as? NSDictionary {
                    calcData.setValue(obj, forKey: key)
                }
            }
            
            /*if let scd = calcData.avgSuccessfulTimesCrossedDefensesTele {
            calcData.avgSuccessfulTimesCrossedDefenses.cdfCrossed = (scd["cdf"] as? Int)
            calcData.pcCrossed = (scd["pc"] as? Int)
            calcData.mtCrossed = (scd["mt"] as? Int)
            calcData.rpCrossed = (scd["rp"] as? Int)
            calcData.dbCrossed = (scd["db"] as? Int)
            calcData.spCrossed = (scd["sp"] as? Int)
            calcData.rtCrossed = (scd["rt"] as? Int)
            calcData.rwCrossed = (scd["rw"] as? Int)
            }*/
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
    
    func getFirstPickList() -> [Team] {
        let sortedArray = self.teams.sort { $0.calculatedData?.firstPickAbility?.floatValue > $1.calculatedData!.firstPickAbility?.floatValue }
        return sortedArray;
    }
    
    func getSecondPickList() -> [Team] {
        let sortedArray = self.teams.sort { $0.calculatedData?.overallSecondPickAbility?.floatValue > $1.calculatedData?.overallSecondPickAbility?.floatValue }
        return sortedArray;
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
    
    func seedList() -> [Team] {
        let sortedArray = self.teams.sort { $0.calculatedData!.actualSeed?.floatValue < $1.calculatedData!.actualSeed?.floatValue }
        return sortedArray
    }
    
    func predSeedList() -> [Team] {
        let sortedArray = self.teams.sort { $0.calculatedData!.predictedSeed?.floatValue < $1.calculatedData!.predictedSeed?.floatValue }
        return sortedArray
    }
    
    func predictedRPsKeyForTeamNum(teamNumber: Int, matchNum: Int) -> String {
        let match = self.fetchMatch(matchNum)
        if ((match.redAllianceTeamNumbers?.contains(teamNumber)) != nil) {
            return "calculatedData.predictedRedRPs"
        } else {
            return "calculatedData.predictedBlueRPs"
        }
    }
    
    func getSortedListbyString(path: String) -> [Team] {
        let sortedArray = self.teams.sort({ (t1, t2) -> Bool in
            if let t1v = t1.valueForKeyPath(path) {
                if let t2v = t2.valueForKeyPath(path) {
                    if t1v.doubleValue > t2v.doubleValue {
                        return true
                    }
                }
            }
            
            return false
        })
        return sortedArray;
    }
    
    func secondPickList(teamNum: Int) -> [Team] {
        var tupleArray = [(Team,Int)]()
        for team in self.teams {
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
                valueArray.append(-1111.1)
            }
        }
        return (valueArray, altValueMapping)
    }
    
    
    func getMatchValuesForTeamForPath(path: String, forTeam: Team) -> ([Float], [CGFloat : String]?) {
        var timDatas = getTIMDataForTeam(forTeam)
        timDatas.sortInPlace { Int($0.matchNumber!) < Int($1.matchNumber!) }
        
        let sortedTimDatas = timDatas.sort { $0.matchNumber!.integerValue < $1.matchNumber?.integerValue }
        var valueArray = [Float]()
        var altValueMapping : [CGFloat: String]?
        
        for timData in sortedTimDatas {
            let value : AnyObject?
            //print(timData.matchNumber!.integerValue)
            
            value = timData.valueForKeyPath(path)
            
            
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
                valueArray.append(-1111.1)
            }
        }
        return (valueArray, altValueMapping)
    }
    
    func getMatchValuesForTeamForPathForDefense(path: String, forTeam: Team, defenseKey: String) -> ([Float], [CGFloat : String]?) {
        var timDatas = getTIMDataForTeam(forTeam)
        timDatas.sortInPlace { Int($0.matchNumber!) < Int($1.matchNumber!) }
        
        let sortedTimDatas = timDatas.sort { $0.matchNumber!.integerValue < $1.matchNumber?.integerValue }
        var valueArray = [Float]()
        var altValueMapping : [CGFloat: String]?
        
        for timData in sortedTimDatas {
            let value : AnyObject?
            //print(timData.matchNumber!.integerValue)
            let m = self.fetchMatch(timData.matchNumber as! Int)
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
            if match.redScore != nil && match.redScore?.integerValue != -1 && match.blueScore != nil && match.blueScore?.integerValue != -1 {
                print("This is the current match")
                print(counter)
                
                return counter
            }
        }
        return 0
    }
    
    func matchesUntilTeamNextMatch(teamNumber : Int) -> String? {
        let sortedMatches = self.matches.sort { Int($0.number!) < Int($1.number!) }
        if let indexOfCurrentMatch = sortedMatches.indexOf(self.fetchMatch(self.getCurrentMatch() + 1)) {
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
            if match.number?.integerValue >= self.currentMatchManager.currentMatch {
                remainingArray.append(match)
            }
        }
        return remainingArray.count
    }
    
}

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





