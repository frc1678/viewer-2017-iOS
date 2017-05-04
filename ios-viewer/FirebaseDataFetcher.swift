//
//  FirebaseDataFetcher.swift
//  scout-viewer-2016-iOS
//
//  Created by Samuel Resendez on 1/23/16.
//  Copyright © 2016 Citrus Circuits. All rights reserved.
//

import UIKit
import Firebase
import Haneke
import UserNotifications
import SwiftyJSON

fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


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
    //beginning of url for firebase
    let firebaseURLFirstPart = "https://1678-scouting-2016.firebaseio.com/"
    
    let scoutingToken = "qVIARBnAD93iykeZSGG8mWOwGegminXUUGF2q0ee"
    let dev3Token = "AEduO6VFlZKD4v10eW81u9j3ZNopr5h2R32SPpeq"
    let dev2Token = "hL8fStivTbHUXM8A0KXBYPg2cMsl80EcD7vgwJ1u"
    let devToken = "j1r2wo3RUPMeUZosxwvVSFEFVcrXuuMAGjk6uPOc"
    let stratDevToken = "IMXOxXD3FjOOUoMGJlkAK5pAtn89mGIWAEnaKJhP"
    //array of all matches
    var matches = [Match]()
    //array of all TIMDs
    var teamInMatches = [TeamInMatchData]()
    //image urls
    var imageUrls = [Int: String]()
    var allTheData = NSDictionary()
    
    let firebase : FIRDatabaseReference
    
    override init() {
        //reference to firebase
        firebase = FIRDatabase.database().reference()
        //initiate currentmatchmanager
        self.currentMatchManager = CurrentMatchManager()
        //initiate notification manager
        self.notificationManager = NotificationManager(secsBetweenUpdates: 5, notifications: [])
        super.init()
        
        self.notificationManager.notifications.append(NotificationManager.Notification(name: "updateLeftTable"))
        //self.notificationManager.notifications.append(NotificationManager.Notification(name: "currentMatchUpdated"))
        
       DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async {
            self.getAllTheData()
        }
        
    }
    
    //returns a match given a snapshot
    func makeMatchFromSnapshot(_ snapshot: FIRDataSnapshot) -> Match {
        
        return Match(json: JSON(snapshot.value!))
    }
    
    //returns a team given a snapshot
    func makeTeamFromSnapshot(_ snapshot: FIRDataSnapshot) -> Team {
        return Team(json: JSON(snapshot.value!))
    }
    
    // MARK: Image Fetching Methods
    func getDataFromUrl(_ url:URL, completion: @escaping ((_ data: Data?, _ error: NSError? ) -> Void)) {
        URLSession.shared.dataTask(with: url, completionHandler: {  (data, _, error) in //Should already be async
            completion(data, error as NSError?)
            URLSession.shared.invalidateAndCancel()
            }) .resume()
    }
    
    //get and cache an image for a team and url
    func cacheImage(_ teamNum : Int, url : String?) {
        if let urlString = url {
            let url = URL(string: urlString)
            //get the info from the url that's passed in
            getDataFromUrl(url!) { [unowned self] (data, error) in
                guard let data = data , error == nil else { return }
                //cache the image to the team
                self.imageCache.set(value: UIImage(data: data) ?? UIImage(), key: "\(teamNum)")
                //warn that memory updated?
                UIApplication.shared.perform(Selector(("_performMemoryWarning")))
            }
        }
    }
    
    //get an image for a team
    func getImageForTeam(_ teamNumber : Int, fetchedCallback : @escaping (UIImage)->(), couldNotFetch: @escaping ()->()) { // Is already async
        //go into the cache and find a team. get the image from the team
        self.imageCache.fetch(key: "\(teamNumber)").onSuccess { (image) -> () in
            fetchedCallback(image)
            }.onFailure { (E) -> () in
                couldNotFetch()
        }
    }
    
    //input a team, store as snap
    func updateCacheIfNeeded(_ snap : FIRDataSnapshot, team : Team) {
        let defaults = UserDefaults.standard
        //check if the user wants to aggressively download
        let shouldAggressivelyDownload = defaults.bool(forKey: "predownloadPreference")
        if shouldAggressivelyDownload {
            //look for the selected image url on firebase
            if let newURL = snap.childSnapshot(forPath: "selectedImageURL").value {
                //if the url has changed
                if team.pitSelectedImageName != newURL as? String {
                    //cache the new image under the team's number
                    cacheImage(snap.childSnapshot(forPath: "number").value as! Int, url: newURL as? String)
                }
            }
        }
    }
    
    // MARK: Data Fetching
    func getAllTheData() {
        self.firebase.observeSingleEvent(of: .value, with: { [unowned self] (snap) -> Void in
            //create a firebase reference that points to Matches
            let matchReference = self.firebase.child("Matches")
            
            //if a child is added to the matches on firebase, make a snapshot
            matchReference.observe(.childAdded, with: { [unowned self] snapshot in
                //appends a match for the current snapshot to the matches
                self.matches.append(self.makeMatchFromSnapshot(snapshot))
                //this line seems redundant but I don't have a lightning cable to test... test this, future me!
                self.currentMatchManager.currentMatch = self.currentMatchManager.currentMatch
                if self.hasUpdatedMatchOnSetup == false {
                    self.hasUpdatedMatchOnSetup = true
                    self.notificationManager.queueNote("updateLeftTable", specialObject: nil)
                }
                })
            //if a child has changed, make a snapshot
            matchReference.observe(.childChanged, with: { [unowned self] snapshot in
                //increase matchCounter
                self.matchCounter += 1
                print(self.currentMatchManager.currentMatch)
                //once again, future me: test commenting out this line
                self.currentMatchManager.currentMatch = self.currentMatchManager.currentMatch
                //gets the match number
                let number = (snapshot.childSnapshot(forPath: "number").value as? Int)!
                for matchIndex in 0..<self.matches.count {
                    let match = self.matches[matchIndex]
                    if match.number == number {
                        //update the appropriate match
                        self.matches[matchIndex] = self.makeMatchFromSnapshot(snapshot)
                        
                        if match.redScore == -1 && self.matches[matchIndex].redScore != -1 {
                        }
                        self.notificationManager.queueNote("updateLeftTable", specialObject: nil)
                    }
                }
                })
            //create a reference to teams
            let teamReference = self.firebase.child("Teams")
            //if there's a new child, make a snapshot
            teamReference.observe(.childAdded, with: { [unowned self] snapshot in
                DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async {
                    //makes a team
                    let team = self.makeTeamFromSnapshot(snapshot)
                    //if the team is a real team
                    if team.number != -1 {
                        //update cache
                        self.updateCacheIfNeeded(snapshot, team: team)
                        DispatchQueue.main.async {
                            //add the team to the list
                            self.teams.append(team)
                            self.notificationManager.queueNote("updateLeftTable", specialObject: team)
                        }
                    }
                }
                })
            
            //if a team has changed
            teamReference.observe(.childChanged, with: { [unowned self] snapshot in
               DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async {
                    //increase the team counter
                    self.teamCounter += 1
                    //make a team out of the snapshot
                    let team = self.makeTeamFromSnapshot(snapshot)
                    //if the team's real
                    if team.number != -1 {
                        //update cache
                        self.updateCacheIfNeeded(snapshot, team: team)
                        DispatchQueue.main.async {
                            //filter the teams to find the changed team
                            let te = self.teams.filter({ (t) -> Bool in
                                if t.number == team.number { return true }
                                return false
                            })
                            if te.count > 0 {
                            if let index = self.teams.index(of: te[0]) {
                                self.teams[index] = team
                                
                                self.notificationManager.queueNote("updateLeftTable", specialObject: team)
                                self.NSCounter = 0
                                self.teamCounter = 0
                                
                            }
                            }
                        }
                    }
                }
                })
            //get a ref to timds
            let timdRef = self.firebase.child("TeamInMatchDatas")
            //if a new timd was added
            timdRef.observe(.childAdded, with: { [unowned self] (snap) -> Void in
                DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async {
                    //get a timd for the snapshot
                    let timd = TeamInMatchData(json: JSON(snap.value!))
                    DispatchQueue.main.async {
                        //add the timd to the list
                        self.teamInMatches.append(timd)
                        self.notificationManager.queueNote("updateLeftTable", specialObject: nil)
                    }
                }
                })
            
            //if a timd was updated
            timdRef.observe(.childChanged, with: { [unowned self] (snap) -> Void in
                DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async {
                    //increase the counter
                    self.TIMDCounter += 1
                    //get the timd
                    let timd = TeamInMatchData(json: JSON(snap.value!))
                    DispatchQueue.main.async {
                        //filter to get the appropriate match
                        let tm = self.teamInMatches.filter({ (t) -> Bool in
                            if t.teamNumber == timd.teamNumber && t.matchNumber == timd.matchNumber { return true }
                            return false
                        })
                        //find the index of the timd
                        if let index = self.teamInMatches.index(of: tm[0]) {
                            //replace the timd
                            self.teamInMatches[index] = timd
                        }
                        
                    }
                }
                })
            
            self.firstCurrentMatchUpdate = false
            
            //get the current match
            let currentMatchFetch = self.getMatch(self.currentMatchManager.currentMatch)
            
            let m : [String: Any] = ["num":self.currentMatchManager.currentMatch, "redTeams": currentMatchFetch?.redAllianceTeamNumbers ?? [0,0,0], "blueTeams": currentMatchFetch?.blueAllianceTeamNumbers ?? [0,0,0]]
            UserDefaults.standard.set(m, forKey: "match")
            })
        
    }
    
    //returns all timds for a given team
    func getTIMDataForTeam(_ team: Team) -> [TeamInMatchData] {
        return self.teamInMatches.filter { $0.teamNumber == team.number }
    }
    
    //returns a timd for a team in a match
    func getTIMDataForTeamInMatch(_ team:Team, inMatch: Match) -> TeamInMatchData? {
        //gets timds for the team
        let TIMData = self.getTIMDataForTeam(team)
        //if the team has timds
        if TIMData.count > 0 {
            //filter to get the timd with the match number of inMatch
            let correctTIMDs = TIMData.filter { $0.matchNumber == inMatch.number} //Hopefully there is exactly one
            
            if correctTIMDs.count == 1 {
                return correctTIMDs[0]
            }
        }
        print("Problem geting TIMData")
        return nil
    }
    
    //returns a team for a number
    func getTeam(_ teamNum: Int) -> Team? {
        //filter to end up with only the team(s) with the given number
        let myTeams = teams.filter { $0.number == teamNum }
        if myTeams.count == 1 { return myTeams[0] }
        else if myTeams.count > 1 {
            print("More than 1 team with number \(teamNum)")
            return nil
        } else {
            print("No Teams with number \(teamNum)")
            return nil
        }
    }
    
    //gets a match for a number
    func getMatch(_ matchNum: Int) -> Match? {
        //filter to get the match(es) with the given number
        let myMatches = matches.filter { $0.number == matchNum }
        if myMatches.count == 1 { return myMatches[0] }
        else if myMatches.count > 1 {
            print("More than 1 match with number \(matchNum)")
            return nil
        } else {
            print("No Matches with number \(matchNum)")
            return nil
        }
    }
    
    //returns an array of teams with the numbers passed in
    func getTeamsFromNumbers(_ teamNums: [Int]?) -> [Team] {
        var teams = [Team]()
        if teamNums != nil {
            for teamNum in teamNums! {
                if let team = self.getTeam(teamNum) {
                    teams.append(team)
                }
            }
        }
        return teams
    }
    
    //gets all teams in a given match
    func allTeamsInMatch(_ match: Match) -> [Team]  {
        let redTeams = getTeamsFromNumbers(match.redAllianceTeamNumbers! as [Int])
        let blueTeams = getTeamsFromNumbers(match.blueAllianceTeamNumbers! as [Int])
        return redTeams + blueTeams
    }
    
    //returns an array of matches that contain a team specified by number
    func getMatchesForTeamWithNumber(_ number:Int) -> [Match] {
        var array = [Match]()
        //iterate thru all matches
        for match in self.matches {
            //iterate thru all red teams
            for teamNumber in match.redAllianceTeamNumbers! {
                //if the team matches, add that match
                if (teamNumber as Int) == number {
                    array.append(match)
                }
            }
            //iterate thru all blue teams
            for teamNumber in match.blueAllianceTeamNumbers! {
                //if the team matches, add that match
                if (teamNumber as Int) == number {
                    array.append(match)
                }
            }
        }
        //sort array by # and return it
        return array.sorted { Int($0.number) < Int($1.number) }
    }
    
    //returns an array of match numbers for a team specified by number
    func matchNumbersForTeamNumber(_ number: Int) -> [Int] {
        func matchNum(_ match : Match) -> Int {
            return match.number
        }
        return self.getMatchesForTeamWithNumber(number).map(matchNum)
    }
    
    //I think this does the same thing as getMatchesForTeamWithNumber
    func getMatchesForTeam(_ teamNumber: Int) -> [Match] {
        var importantMatches = [Match]()
        for match in self.matches {
            let teamNumArray = match.redAllianceTeamNumbers! + match.blueAllianceTeamNumbers!
            for number in teamNumArray {
                if (number as Int) == (teamNumber as Int) {
                    importantMatches.append(match)
                }
            }
        }
        importantMatches.sort { Int($0.number) > Int($1.number) }
        return importantMatches
    }
    
    
    // MARK: Rank
    //returns first pick list
    func getFirstPickList() -> [Team] {
        //sorts teams by first pick ability
        return teams.sorted { $0.calculatedData?.firstPickAbility > $1.calculatedData!.firstPickAbility }
    }
    
    //returns second pick list
    func getOverallSecondPickList() -> [Team] {
        return self.teams.sorted { $0.calculatedData?.allRotorsAbility > $1.calculatedData?.allRotorsAbility }
    }
    
    /*func getConditionalSecondPickList(_ teamNum: Int) -> [Team] {
        var tupleArray = [(Team,Int)]()
        for team in teams {
            if(team.calculatedData?.secondPickAbility?.object(forKey: String(teamNum)) != nil) {
                tupleArray.append(team, ((team.calculatedData!.secondPickAbility!.object(forKey: String(teamNum))) as? Int)!)
            }
        }
        let sortedTuple = tupleArray.sorted { $0.1 > $1.1 }
        var teamArray = [Team]()
        for (k,_) in sortedTuple {
            teamArray.append(k)
        }
        return teamArray
    }*/
    
    //get list of teams sorted by seed
    func seedList() -> [Team] {
        return teams.sorted { $0.calculatedData!.actualSeed < $1.calculatedData!.actualSeed }
    }
    
    //get list of teams sorted by predicted seed
    func predSeedList() -> [Team] {
        return teams.sorted { $0.calculatedData!.predictedSeed < $1.calculatedData!.predictedSeed }
    }
    
    //returns how many rps we think a team will get
    func predictedRPsKeyForTeamNum(_ teamNumber: Int, matchNum: Int) -> String {
        let match = getMatch(matchNum)
        if (match?.redAllianceTeamNumbers!.contains(teamNumber))! {
                    return "calculatedData.predictedRedRPs"
        } else {
            return "calculatedData.predictedBlueRPs"
        }
    }
    
    //returns the rank of a team for a given characteristic
    func rankOfTeam(_ team: Team, withCharacteristic: String) -> Int {
        var counter = 0
        //sort teams by the characteristic
        let sortedTeams : [Team] = self.getSortedListbyString(withCharacteristic)
        
        //iterate thru the sorted teams
        for loopTeam in sortedTeams {
            //increase the counter
            counter += 1
            //if team is found
            if loopTeam.number == team.number {
                //return rank (how many teams it went thru before it got this team)
                return counter
            }
        }
        return counter
    }
    
    //see rankOfTeam
    func reverseRankOfTeam(_ team: Team, withCharacteristic:String) -> Int {
        var counter = 0
        let sortedTeams : [Team] = self.getSortedListbyString(withCharacteristic).reversed()
        
        for loopTeam in sortedTeams {
            counter += 1
            if loopTeam.number == team.number {
                return counter
            }
        }
        return counter
    }
    
    //
    func ranksOfTeamInMatchDatasWithCharacteristic(_ characteristic: NSString, forTeam: Team) -> [Int] {
        var array = [Int]()
        let TIMDatas = getTIMDataForTeam(forTeam)
        for timData in TIMDatas {
            array.append(self.rankOfTeamInMatchData(timData, withCharacteristic: characteristic))
        }
        return array
    }
    
    func rankOfTeamInMatchData(_ timData: TeamInMatchData, withCharacteristic: NSString) -> Int {
        var values = [Int]()
        let teamNum = timData.teamNumber!
        let TIMDatas = getTIMDataForTeam(self.getTeam(teamNum)!)
        for timData in TIMDatas {
            values.append(timData.matchNumber!)
        }
        return values.index(of: teamNum)! + 1
    }
    
    //ranks all teams by a characteristic
    func ranksOfTeamsWithCharacteristic(_ characteristic: NSString) -> [Int] {
        var array = [Int]()
        for team in self.teams {
            array.append(self.rankOfTeam(team, withCharacteristic: characteristic as String))
        }
        //array of all teams in numerical order, represented by rank with characteristic
        return array
    }
    
    func getSortedListbyString(_ path: String) -> [Team] {
        
        return teams.sorted(by: { (t1, t2) -> Bool in
            
            if let t1v = t1.value(forKeyPath: path) {
                if let t2v = t2.value(forKeyPath: path) {
                    if (t1v as AnyObject).doubleValue > (t2v as AnyObject).doubleValue {
                        return true
                    }
                }
            }
            
            return false
        })
    }
    
    
    
    // MARK: Getting Custom Objects From Dictionaries
    
    
    
    //deprecated
    func getAverageDefenseValuesForDict(_ dict: NSDictionary) -> [Int] {
        var valueArray = [Int]()
        let keyArray = dict.allKeys as? [String]
        for key in keyArray! {
            let subDict = dict.object(forKey: key) as? NSDictionary
            let subKeyArray = subDict?.allKeys
            
            for subKey in subKeyArray! {
                valueArray.append((subDict!.object(forKey: subKey) as? Int)!)
            }
        }
        return valueArray
    }
    
    
    // MARK: Search Bar
    //filters matches according to the search string when set to matches
    func filteredMatchesForMatchSearchString(_ searchString:String) -> [Match] {
        var filteredMatches = [Match]()
        for match in self.matches  {
            //if the match contains the search field
            if String(describing: match.number).range(of: searchString) != nil {
                filteredMatches.append(match)
            }
        }
        return filteredMatches
    }
    
    //filters matches according to the search string when set to teams, see filteredMatchesForMatchSearchString
    func filteredMatchesforTeamSearchString(_ searchString: String) -> [Match] {
        var filteredMatches = [Match]()
        for match in self.matches  {
            for teamNum in match.redAllianceTeamNumbers! {
                if String(describing: teamNum).range(of: searchString) != nil {
                    filteredMatches.append(match)
                }
            }
            for teamNum in match.blueAllianceTeamNumbers! {
                if String(describing: teamNum).range(of: searchString) != nil {
                    filteredMatches.append(match)
                }
            }
        }
        return filteredMatches
    }
    
    //filters general searches
    func filteredTeamsForSearchString(_ searchString: String) -> [Team] {
        var filteredTeams = [Team]()
        for team in self.teams {
            //if team number contains search field
            if String(describing: team.number).range(of: searchString) != nil {
                filteredTeams.append(team)
            }
        }
        return filteredTeams
    }
    
    
    
    // MARK: Grapher Class
    func valuesInTeamMatchesOfPath(_ path: NSString, forTeam: Team) -> NSArray {
        let array = NSMutableArray()
        let teamInMatchDatas = self.getTIMDataForTeam(forTeam)
        for data in teamInMatchDatas {
            array.add((data.value(forKeyPath: path as String)! as? Int)!)
        }
        return array
    }
    
    func valuesInCompetitionOfPathForTeams(_ path: String) -> NSArray {
        let array = NSMutableArray()
        //iterate thru all teams
        for team in self.teams {
            //if the team's value for the key you put in...
            if team.value(forKeyPath: path) != nil {
                //add to the array the value
                array.add(team.value(forKeyPath: path)!)
            }
        }
        //so this is an array of all of the non-nil values for a certain path, for every team
        return array
    }
    
    func boolValue(value: Any) -> Bool? {
        let boolValue: Bool
        if let boolBoolValue = value as? Bool { //Such ugly
            boolValue = boolBoolValue
        } else {
            boolValue = value as? String == "true" ? true : false
        }
        return boolValue
    }
    
    /**
     Used by the graphing class If you get -1111.1 for any of the values, that means you haz problem.
     
     - parameter path:    Path to datapoint. Uses `match.valueForKeyPath(path)`.
     - parameter forTeam: The team you want the datapoint for.
     
     - returns: The second value in the tuple is the alternate value mapping. E.g. Yes and No instead of 1 and 0
     */
    func getMatchDataValuesForTeamForPath(_ path: String, forTeam: Team) -> ([Float], [CGFloat : String]?) {
        let matches = getMatchesForTeam(forTeam.number)
        var valueArray = [Float]()
        var altValueMapping : [CGFloat : String]?
        
        for match in matches {
            let value : AnyObject?
            var newPath = path
            if path == "calculatedData.predictedNumRPs" {
                newPath = predictedRPsKeyForTeamNum(forTeam.number, matchNum: match.number)
            }
            value = match.value(forKeyPath: newPath) as AnyObject?
            
            if value != nil {
                if let floatVal = value as? Float {
                    valueArray.append(floatVal)
                } else { // Pretty much, if its false it's 0, if its true it's 1
                    altValueMapping = [CGFloat(1.0): "Yes", CGFloat(0.0): "No"]
                    valueArray.append((boolValue(value: value!)! ? 1.0 : 0.0))
                }
            } else {
                print("In getMatchDataValuesForTeamForPath, the value for the key \(path) seems to be nil.")
                valueArray.append(-1111.1)
            }
        }
        return (valueArray, altValueMapping)
    }
    /**
     See Description for `getMatchDataValuesForTeamForPath`
     */
    func getMatchValuesForTeamForPath(_ path: String, forTeam: Team) -> ([Float], [CGFloat : String]?) {
        let TIMDs = getTIMDataForTeam(forTeam).sorted { Int($0.matchNumber!) < Int($1.matchNumber!) }
        
        var valueArray = [Float]()
        var altValueMapping : [CGFloat: String]?
        
        for TIMD in TIMDs {
            var value : Any?
            if path.contains("calculatedData") {
                value = (TIMD.calculatedData!.dictionaryRepresentation() as NSDictionary).object(forKey: path.replacingOccurrences(of: "calculatedData.", with: ""))
            } else if path.contains("gearsPlacedByLiftAuto") {
                value = TIMD.gearsPlacedByLiftAuto?[path.components(separatedBy: ".")[1]]
            } else {
                value = (TIMD.dictionaryRepresentation() as NSDictionary).object(forKey: path)
            }
            if value != nil {
                if let floatValue = value as? Float {
                    valueArray.append(floatValue)
                } else if let intVal = value as? Int {
                    valueArray.append(Float(intVal))
                } else { // Pretty much, if its false it's 0, if its true it's 1
                    altValueMapping = [CGFloat(1.0): "Yes", CGFloat(0.0): "No"]
                    valueArray.append((boolValue(value: value!)! ? 1.0 : 0.0))
                }
            } else {
                print("In getMatchValuesForTeamForPath, the value for the key \(path) seems to be nil.")
                valueArray.append(-1111.1)
            }
        }
        return (valueArray, altValueMapping)
    }
    
    // MARK: Dealing With Current Match
    /**
     This puts up the little banner at the top, and increases the badge number on the app.
     
     - parameter notificationBody: What the text of the notification should be (that the person reads).
     */
    func postNotification(_ notificationBody:String) {
        let content = UNMutableNotificationContent()
        content.body = notificationBody
        content.sound = UNNotificationSound.default()
        content.badge = NSNumber(integerLiteral: UIApplication.shared.applicationIconBadgeNumber + 1)
        content.title = "Upcoming Starred Match"
        let localNotification = UNNotificationRequest(identifier: "ViewerNotification", content: content, trigger: nil)
        UNUserNotificationCenter.current().add(localNotification, withCompletionHandler: nil)
    }
    
    func didReceiveCurrentMatchNum (notificationObject : Notification) {
        
    }
    
    func matchesUntilTeamNextMatch(_ teamNumber : Int) -> String? {
        let sortedMatches = self.matches.sorted { Int($0.number) < Int($1.number) }
        if self.currentMatchManager.currentMatch < sortedMatches.count {
            if let indexOfCurrentMatch = sortedMatches.index(of: self.getMatch(self.currentMatchManager.currentMatch) ?? sortedMatches[0]) {
                var counter = 0
                for i in indexOfCurrentMatch + 1..<self.matches.count {
                    let match = sortedMatches[i]
                    counter += 1
                    if (match.redAllianceTeamNumbers?.filter { Int($0) == teamNumber }.count != 0) || (match.blueAllianceTeamNumbers?.filter { Int($0) == teamNumber }.count != 0) {
                        return "\(counter)"
                    }
                }
            }
        }
        return nil
    }
    
    func remainingMatchesForTeam(_ teamNum:Int) -> Int {
        let matchArray = getMatchesForTeam(teamNum)
        var remainingArray = [Match]()
        for match in matchArray {
            if match.number > self.currentMatchManager.currentMatch {
                remainingArray.append(match)
            }
        }
        return remainingArray.count
    }
    
}

/// Custom Class for managing NSNotifications about things. Not to be confused with the kind of notifications that pop up and make a dinging sound on your phone.
class NotificationManager : NSObject {
    let timer = Timer()
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
                if selector!.range(of: ":") == nil {
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
                NotificationCenter.default.addObserver(self, selector: Selector(selector), name: NSNotification.Name(rawValue: note.name), object: nil)
            }
        }
        Timer.scheduledTimer(timeInterval: secsBetweenUpdates, target: self, selector: #selector(NotificationManager.notify(_:)), userInfo: nil, repeats: false)
        
    }
    
    func queueNote(_ name: String, specialObject: AnyObject?) {
        self.notificationNamesToPost[name] = specialObject
    }
    
    func postNotification(_ noteName : String, specialObject : AnyObject?) {
        let noteArray = self.notifications.filter { $0.name == noteName }
        if noteArray.count > 0 {
            let note = noteArray[0]
            if specialObject != nil {
                NotificationCenter.default.post(name: Foundation.Notification.Name(rawValue: note.name), object: specialObject, userInfo: nil)
            } else {
                NotificationCenter.default.post(name: Foundation.Notification.Name(rawValue: note.name), object: note.object, userInfo: nil)
            }
        }
    }
    
    func notify(_ timer : Timer) {
        for (noteName, specialObject) in self.notificationNamesToPost {
            postNotification(noteName, specialObject: specialObject)
        }
        notificationNamesToPost = [String: AnyObject?]()
        self.timer.invalidate()
        Timer.scheduledTimer(timeInterval: secsBetweenUpdates, target: self, selector: #selector(NotificationManager.notify(_:)), userInfo: nil, repeats: false)
    }
}
