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

@objc class FirebaseDataFetcher: NSObject, UITableViewDelegate {
    
    var currentMatchNum = 0
    var starredMatchesArray = NSMutableArray()
    
    var teams = [Team]()
    let firebaseURLFirstPart = "https://1678-dev3-2016.firebaseio.com/"
    let scoutingToken = "qVIARBnAD93iykeZSGG8mWOwGegminXUUGF2q0ee"
    let dev3Token = "AEduO6VFlZKD4v10eW81u9j3ZNopr5h2R32SPpeq"
    let dev2Token = "hL8fStivTbHUXM8A0KXBYPg2cMsl80EcD7vgwJ1u"
    var matches = [Match]()
    var teamInMatches = [TeamInMatchData]()
    var imageUrls = Dictionary<Int,String>()
    var allTheData = NSDictionary()
    var dataStack : DATAStack = DATAStack()
    
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
        "rankEvasion",
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
        "numRPs",
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
        "numRPs",
        "numAutoPoints",
        "numScaleAndChallengePoints",
        "RScoreDefense",
        "RScoreBallControl",
        "RScoreDrivingAbility",
        "citrusDPR",
        "overallSecondPickAbility",
        "scoreContribution"
    ]
    
    
    override init() {
        super.init()
        NSNotificationCenter.defaultCenter().addObserver(self,selector:"currentMatchChanged",name:"currentNumberChanged",object:nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "lpgrTriggered:", name: "lpgrTriggered", object: nil)
        self.getAllTheData()
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
    
    func getAllTheData() {
        let firebase = Firebase(url: self.firebaseURLFirstPart)
        firebase.authWithCustomToken(dev3Token) { (E, A) -> Void in
            
            firebase.observeSingleEventOfType(.Value, withBlock: { (snap) -> Void in
                
                let numTeams = snap.childSnapshotForPath("Teams").childrenCount
                let matchReference = Firebase(url: "\(self.firebaseURLFirstPart)/Matches")
                matchReference.observeEventType(.ChildAdded, withBlock: { snapshot in
                    self.matches.append(self.makeMatchFromSnapshot(snapshot))
                    NSNotificationCenter.defaultCenter().postNotificationName("updateLeftTable", object:nil)
                })
                
                matchReference.observeEventType(.ChildChanged, withBlock: { snapshot in
                    let number = (snapshot.childSnapshotForPath("number").value as? Int)!
                    self.checkForNotification()
                    for matchIndex in Range(start: 0, end: self.matches.count) {
                        let match = self.matches[matchIndex]
                        if match.number == number {
                            self.matches[matchIndex] = self.makeMatchFromSnapshot(snapshot)
                            NSNotificationCenter.defaultCenter().postNotificationName("updateLeftTable", object:nil)
                            break
                        }
                    }
                })
                
                let teamReference = Firebase(url:"\(self.firebaseURLFirstPart)/Teams")
                teamReference.observeEventType(.ChildAdded, withBlock: { snapshot in
                    let team = self.makeTeamFromSnapshot(snapshot)
                    self.teams.append(team)
                    NSNotificationCenter.defaultCenter().postNotificationName("updateLeftTable", object:team.number)
                    if(UInt(self.teams.count) == numTeams) {
                        self.getCurrentMatch()
                    }
                })
                
                teamReference.observeEventType(.ChildChanged, withBlock: { snapshot in
                    let team = self.makeTeamFromSnapshot(snapshot)
                    let te = self.teams.filter({ (t) -> Bool in
                        if t.number == team.number { return true }
                        return false
                    })
                    if let index = self.teams.indexOf(te[0]) {
                        self.teams[index] = team
                        NSNotificationCenter.defaultCenter().postNotificationName("updateLeftTable", object:team.number)
                        
                    }
                })
                
                let timdRef = Firebase(url:"\(self.firebaseURLFirstPart)/TeamInMatchDatas")
                timdRef.observeEventType(.ChildAdded, withBlock: { (snap) -> Void in
                    let timd = self.getTeamInMatchDataForDict(snap.value as! NSDictionary, key: snap.key)
                    
                    let team = self.fetchTeam(timd!.teamNumber as! Int)
                    team.TeamInMatchDatas.append(timd!)
                    
                    self.teamInMatches.append(timd!)
                    NSNotificationCenter.defaultCenter().postNotificationName("updateLeftTable", object: nil)
                })
                
                timdRef.observeEventType(.ChildChanged, withBlock: { (snap) -> Void in
                    let timd = self.getTeamInMatchDataForDict(snap.value as! NSDictionary, key: snap.key)
                    
                    let tm = self.teamInMatches.filter({ (t) -> Bool in
                        if t.teamNumber == timd!.teamNumber && t.matchNumber == timd!.matchNumber { return true }
                        return false
                    })
                    if let index = self.teamInMatches.indexOf(tm[0]) {
                        self.teamInMatches[index] = timd!
                        NSNotificationCenter.defaultCenter().postNotificationName("updateLeftTable", object:nil)
                    }
                    let team = self.fetchTeam(timd?.teamNumber as! Int)
                    let i = team.TeamInMatchDatas.indexOf { $0.matchNumber == timd!.matchNumber }
                    if i != nil {
                        team.TeamInMatchDatas[i!] = timd!
                    }
                })
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
            for key in PDFRenderer.allPropertyNamesForClass(TeamInMatchCalculatedData) {
                if let value = dict!.objectForKey(key) {
                    CTIMD.setValue(value, forKey: key as! String)
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
        let sortedArray = self.teams.sort { $0.calculatedData!.firstPickAbility?.floatValue > $1.calculatedData!.firstPickAbility?.floatValue }
        return sortedArray;
    }
    
    func getSecondPickList() -> [Team] {
        let sortedArray = self.teams.sort { $0.calculatedData!.overallSecondPickAbility?.floatValue > $1.calculatedData!.overallSecondPickAbility?.floatValue }
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
    
    func getMatchDataValuesForTeamForPath(var path: String, forTeam: Team) -> [Float] {
        let matches = getMatchesForTeam(forTeam.number as! Int)
        var valueArray = [Float]()

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
        return valueArray
    }
    
    
    func getMatchValuesForTeamForPath(path: String, forTeam: Team) -> [Float] {
        var timDatas = getTIMDataForTeam(forTeam)
        timDatas.sortInPlace { Int($0.matchNumber!) < Int($1.matchNumber!) }
        print(forTeam.TeamInMatchDatas)
        let sortedTimDatas = timDatas.sort { $0.matchNumber!.integerValue < $1.matchNumber?.integerValue }
        var valueArray = [Float]()
        for timData in sortedTimDatas {
            let value : AnyObject?
            print(timData.matchNumber!.integerValue)
            
            value = timData.valueForKeyPath(path)
            
            
            if value != nil {
                
                if let floatVal = value as? Float {
                    valueArray.append(floatVal)
                    
                } else { // Pretty much, if its false it's 0, if its true it's 1
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
        return valueArray
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
        let sortedMatches = self.matches.sort { $0.matchNumber?.integerValue > $1.matchNumber?.integerValue }
        var counter = 0
        for match in sortedMatches {
            counter += 1
            if match.redScore == nil || match.redScore?.integerValue == -1 && match.blueScore == nil || match.blueScore?.integerValue == -1 {
                print("This is the current match")
                print(counter)
                self.currentMatchNum = counter
                return counter
            }
        }
        return 1;
    }
    
    func checkForNotification() {
        let swiftArray = self.starredMatchesArray as AnyObject as! [String]
        let currentMatch = self.getCurrentMatch()
        if swiftArray.contains(String(currentMatch)) {
            postNotification("Match coming up: " + String(currentMatch))
        }
        if swiftArray.contains(String(currentMatch + 1)) {
            postNotification("Match coming up: " + String(currentMatch + 1 ))
        }
        if swiftArray.contains(String(currentMatch + 2)) {
            postNotification("Match coming up: " + String(currentMatch + 2))
        }
    }
    
    func lpgrTriggered(notification:NSNotification) {
        let array = self.starredMatchesArray
        let swiftArray = array as AnyObject as! [String]
        let currentMatch = self.getCurrentMatch()
        if swiftArray.contains(String(currentMatch)) || swiftArray.contains(String(currentMatch + 1)) || swiftArray.contains(String(currentMatch + 2)) {
            postNotification("Starred Match coming up!")
        }
    }
    
}





