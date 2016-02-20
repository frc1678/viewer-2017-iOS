//
//  FirebaseDataFetcher.swift
//  scout-viewer-2015-iOS
//
//  Created by Samuel Resendez on 1/23/16.
//  Copyright © 2016 Citrus Circuits. All rights reserved.
//

import UIKit
import firebase_schema_2016_ios
import Firebase
import Sync
import DATAStack

@objc class FirebaseDataFetcher: NSObject, UITableViewDelegate {
    
    
    var teams = [Team]() {
        willSet {
            
        }
    }
    let firebaseURLFirstPart = "https://1678-scouting-2016.firebaseio.com/"
    var matches = [Match]()
    var teamInMatches = [TeamInMatchData]()
    var imageUrls = Dictionary<Int,String>()
    var allTheData = NSDictionary()
    var dataStack : DATAStack = DATAStack()
    var teamInMatchKeys = [
        "ballsIntakedAuto",
        //"didChallengeTele",
        //"didGetDisabled",
        //"didGetIncapacitated",
        //"didReachAuto",
        //"didScaleTele",
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
        // "timesCrossedDefensesAuto",
        "timesCrossedDefensesTele",
    ]
    var defenseKeys = ["avgFailedTimesCrossedDefensesAuto",
        "avgFailedTimesCrossedDefensesTele",
        "avgSuccessfulTimesCrossedDefensesAuto",
        "avgSuccessfulTimesCrossedDefensesTele",
        "sdFailedDefenseCrossesAuto",
    ]
    
    var teamCalcKeys = ["actualSeed",
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
        "secondPickAbility",
        "siegeAbility",
        "siegeConsistency"]
    
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
    
    override init() {
        super.init()
        self.getAllTheData()
    }
    
    //    func coreDataImport() {
    //        let fb = Firebase(url: "https://1678-dev-2016.firebaseio.com/")
    //        fb.observeEventType(.Value, withBlock: { snapshot in
    //            Sync.changes(
    //                WHEEEEEE, ERROR HERE: You need the JSON thing that is being used in pit scout.
    //                changes: JSON(snapshot.value),
    //                inEntityNamed: String,
    //                dataStack: self.dataStack,
    //                completion: {
    //                    
    //            })
    //        }
    //        
    //    }
    
    func makeMatchFromSnapshot(snapshot: FDataSnapshot) -> Match {
        let match = Match()
        //var hello = (snapshot.value.objectForKey("blueAllianceDidCapture") as? String)!
        match.blueAllianceTeamNumbers = (snapshot.value.objectForKey("blueAllianceTeamNumbers") as? [Int])
        match.blueDefensePositions = (snapshot.value.objectForKey("blueDefensePositions") as? [String])
        match.blueScore = (snapshot.value.objectForKey("blueScore") as? Int)
        let calculatedDict = (snapshot.value.objectForKey("calculatedData") as? NSDictionary)
        match.calculatedData = self.getMatchCalculatedDatafromDict(calculatedDict)
        print("Heres the matchNumber")
        
        print(snapshot.value.objectForKey("number"))
        match.number = (snapshot.value.objectForKey("number") as? Int)
        //match.redAllianceDidCapture = (snapshot.value.objectForKey("redAllianceDidCapture") as? Bool)!
        match.redAllianceTeamNumbers = (snapshot.value.objectForKey("redAllianceTeamNumbers") as? [Int])
        match.redDefensePositions = (snapshot.value.objectForKey("redDefensePositions") as? [String])
        match.redScore = (snapshot.value.objectForKey("redScore") as? Int)
        
        return match
    }
    
    func getAllTheData() {
        //Firebase.defaultConfig().persistenceEnabled = true
        
        let matchReference = Firebase(url: "\(self.firebaseURLFirstPart)/Matches")
        matchReference.authWithCustomToken("qVIARBnAD93iykeZSGG8mWOwGegminXUUGF2q0ee") { (E, A) -> Void in
            matchReference.observeEventType(.ChildAdded, withBlock: { snapshot in
                self.matches.append(self.makeMatchFromSnapshot(snapshot))
                NSNotificationCenter.defaultCenter().postNotificationName("updateLeftTable", object:nil)
            })
            matchReference.observeEventType(.ChildChanged, withBlock: { snapshot in
                let number = (snapshot.value.objectForKey("number") as? Int)!
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
                let team = Team()
                let v = snapshot.value as! NSDictionary
                if let name = (v.objectForKey("name") as? String) {
                    team.name = name
                    team.number = (v.objectForKey("number") as? Int)
                    team.pitDriveBaseLength = (v.objectForKey("pitDriveBaseLength") as? Int)
                    team.pitBumperHeight = (v.objectForKey("pitBumperHeight") as? Int)
                    team.pitDriveBaseWidth = (v.objectForKey("pitDriveBaseWidth") as? Int)
                    team.pitLowBarCapability = (v.objectForKey("pitLowBarCapability") as? Bool)
                    team.pitNotes = (v.objectForKey("pitNotes") as? String)
                    team.pitNumberOfWheels = (v.objectForKey("pitNumberOfWheels") as? Int)
                    team.pitOrganization = (v.objectForKey("pitOrganization") as? Int)
                    team.pitPotentialLowBarCapability = (v.objectForKey("pitPotentialLowBarCapability") as? Int)
                    team.pitPotentialMidlineBallCapability = (v.objectForKey("pitPotentialMidlineBallCapability") as? Int)
                    team.pitPotentialShotBlockerCapability = (v.objectForKey("pitPotentialShotBlockerCapability") as? Int)
                    team.selectedImageUrl = (v.objectForKey("selectedImageUrl") as? String)
                    let teamDict = (v.objectForKey("calculatedData") as? NSDictionary)
                    team.calculatedData = self.getcalcDataForTeamFromDict(teamDict)
                    
                    self.teams.append(team)
                    if(self.teams.count == 58) {
                        for team in self.teams {
                            self.getTeamInMatchDatasForTeam(team)
                        }
                        self.downloadAllImages()
                    }
                    NSNotificationCenter.defaultCenter().postNotificationName("updateLeftTable", object:nil)
                }
                
            })
            teamReference.observeEventType(.ChildChanged, withBlock: { snapshot in
                let number = (snapshot.value.objectForKey("number")as? Int)!
                let teame = Team()
                var index = 0
                for team in self.teams {
                    if team.number == number {
                        break;
                    }
                    print(index)
                    index += 1
                    
                }
                teame.name = (snapshot.value.objectForKey("name") as? String)!
                teame.number = (snapshot.value.objectForKey("number") as? Int)!
                teame.pitDriveBaseLength = (snapshot.value.objectForKey("pitDriveBaseLength") as? Int)
                teame.pitBumperHeight = (snapshot.value.objectForKey("pitBumperHeight") as? Int)
                teame.pitDriveBaseWidth = (snapshot.value.objectForKey("pitDriveBaseWidth") as? Int)
                teame.pitLowBarCapability = (snapshot.value.objectForKey("pitLowBarCapability") as? Bool)
                teame.pitNotes = (snapshot.value.objectForKey("pitNotes") as? String)
                teame.pitNumberOfWheels = (snapshot.value.objectForKey("pitNumberOfWheels") as? Int)
                teame.pitOrganization = (snapshot.value.objectForKey("pitOrganization") as? Int)
                teame.pitPotentialLowBarCapability = (snapshot.value.objectForKey("pitPotentialLowBarCapability") as? Int)
                teame.pitPotentialMidlineBallCapability = (snapshot.value.objectForKey("pitPotentialMidlineBallCapability") as? Int)
                teame.pitPotentialShotBlockerCapability = (snapshot.value.objectForKey("pitPotentialShotBlockerCapability") as? Int)
                teame.selectedImageUrl = (snapshot.value.objectForKey("selectedImageUrl") as? String)
                let teamDict = (snapshot.value.objectForKey("calculatedData") as? NSDictionary)
                teame.calculatedData = self.getcalcDataForTeamFromDict(teamDict)
                self.teams[index] = teame
                self.updateImages()
                
            })
        }
        
        //        let matchRef = Firebase(url:"https://1678-dev-2016.firebaseio.com/")
        //        matchRef.observeEventType(.Value, withBlock: { snapshot in
        //            
        //            self.allTheData = (snapshot.value as? NSDictionary)!
        //            print(self.allTheData.objectForKey("Matches"))
        //            let stuff = self.allTheData.objectForKey("Matches")! as? NSDictionary
        //            NSNotificationCenter.defaultCenter().postNotificationName("updateLeftTable", object:nil)
        //            })
        
    }
    func fetchTeamInMatchDataForTeam(team:Team, inMatch: Match) -> TeamInMatchData {
        let dankString = "\(self.firebaseURLFirstPart)/TeamInMatchDatas/"
        let TIMRef = Firebase(url:dankString)
        let TIMData = TeamInMatchData()
        TIMRef.observeEventType(.Value, withBlock: { snapshot in
            let key = String(team.number)+"Q"+String(inMatch.number)
            TIMData.identifier = key
            let dankMeme = (snapshot.value.objectForKey(key))
            for key in self.teamInMatchKeys {
                
                TIMData.setValue(dankMeme?.objectForKey(key), forKey: key)
            }
            let TIMCalcData = self.getCalculatedTeamInMatchDataForDict(snapshot.childSnapshotForPath("calculatedData").value as? NSDictionary)
            TIMData.calculatedData = TIMCalcData
        })
        return TIMData
        
    }
    func getTIMDataForTeam(team:Team) -> [TeamInMatchData] {
        var array = [TeamInMatchData]()
        print("This is the stuff in Firebase")
        //print(self.teamInMatches.count)
        for TIM in self.teamInMatches {
            if TIM.identifier!.rangeOfString(String(team.number)) != nil {
                array.append(TIM)
            }
        }
        return array
    }
    func fetchTeam(teamNum:Int) -> Team{
        for team in self.teams {
            if team.number == teamNum {
                return team
            }
        }
        return Team()
    }
    func rankOfTeam(team:Team, withCharacteristic:NSString) -> Int {
        var counter = 0
        for loopTeam in self.teams {
            counter++
            if loopTeam.number == team.number?.integerValue {
                return counter
            }
        }
        return counter
    }
    func getTeamsFromNumbers(teamNums:[Int]?) -> [Team] {
        var teams = [Team]()
        if teamNums != nil {
            for teamNum in teamNums! {
                teams.append(self.fetchTeam(teamNum))
            }
        }
        return teams
    }
    func getTeamInMatchDatasForTeam(team:Team) -> [TeamInMatchData]{
        let ref = Firebase(url:"\(self.firebaseURLFirstPart)/TeamInMatchDatas")
        var TIMDatas = [TeamInMatchData]()
        let teamNum = String(team.number!)
        ref.observeEventType(.ChildAdded, withBlock: { datasnapshot in
            //let range = Range(start:teamNum.startIndex,end:teamNum.endIndex)
            if datasnapshot.key.containsString(teamNum) {
                let TIMData = self.getTeamInMatchDataForDict((datasnapshot.value as? NSDictionary)!)
                if TIMData != nil {
                    TIMData!.identifier = datasnapshot.key
                    let TIMCalcData = self.getCalculatedTeamInMatchDataForDict((datasnapshot.childSnapshotForPath("calculatedData").value as? NSDictionary))
                    // TIMCalcData.firstPickAbility = (datasnapshot.value.objectForKey("calculatedData.firstPickAbility") as? Int)!
                    TIMData!.calculatedData = TIMCalcData
                    TIMDatas.append(TIMData!)
                    self.teamInMatches.append(TIMData!)
                }
                
                
            }
        })
        return TIMDatas
    }
    func valuesInTeamMatchesOfPath(path:NSString, forTeam:Team) -> NSArray {
        let array = NSMutableArray()
        let teamInMatchDatas = self.getTIMDataForTeam(forTeam)
        
        
        //print(teamInMatchDatas.count)
        for data in teamInMatchDatas {
            array.addObject((data.valueForKeyPath(path as String)! as? Int)!)
            
        }
        return array
    }
    func ranksOfTeamInMatchDatasWithCharacteristic(characteristic:NSString, forTeam:Team) -> [Int] {
        var array = [Int]()
        let TIMDatas = self.getTeamInMatchDatasForTeam(forTeam)
        for timData in TIMDatas {
            array.append(self.rankOfTeamInMatchData(timData, withCharacteristic: characteristic))
        }
        return array
    }
    func rankOfTeamInMatchData(timData:TeamInMatchData, withCharacteristic:NSString) -> Int {
        var values = [Int]()
        let TIMDatas = self.getTeamInMatchDatasForTeam(self.fetchTeam(timData.teamNumber!.integerValue))
        for timData in TIMDatas {
            values.append(timData.teamNumber!.integerValue)
        }
        return values.indexOf(timData.matchNumber!.integerValue)! + 1
    }
    func valuesInCompetitionOfPathForTeams(path:String) -> NSArray {
        let array = NSMutableArray()
        for team in self.teams {
            if team.valueForKeyPath(path) != nil {
                array.addObject(team.valueForKeyPath(path)!)
            }
        }
        return array
    }
    func ranksOfTeamsWithCharacteristic(characteristic:NSString) -> [Int] {
        var array = [Int]()
        for team in self.teams {
            array.append(self.rankOfTeam(team, withCharacteristic: characteristic))
        }
        return array
    }
    func getTeamImagesForTeam(team:Team, callBack:(progress:Float,done:Bool,teamNum:Int)->()) {
        print("ayyylmao")
    }
    func fetchTeamsByDescriptor(descriptor:NSSortDescriptor) -> [Team] {
        return self.teams
    }
    
    func getTeamPDFImage(team:Int) -> UIImage {
        let pdfImage = UIImage()
        return pdfImage
    }
    
    func fetchMatch(match:String) -> Match {
        for matche in self.matches {
            if String(matche.number) == match {
                return matche
            }
        }
        return Match()
    }
    func allTeamsInMatch(match:Match) -> [Team]  {
        let redTeams = getTeamsFromNumbers(match.redAllianceTeamNumbers!)
        let blueTeams = getTeamsFromNumbers(match.blueAllianceTeamNumbers!)
        
        return redTeams + blueTeams
        
    }
    
    func fetchMatches(shouldForce:Bool) -> [AnyObject] {
        return matches
    }
    func downloadAllwithProgressCallback(callback:(Float, Bool)->()) {
        print("OH DEAR GOD SOMEONE TEACH ME THIS PLEASE")
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
        return array
    }
    func getMatchCalculatedDatafromDict(dict:NSDictionary?) -> MatchCalculatedData {
        
        let matchData = MatchCalculatedData()
        if dict != nil {
            matchData.blueRPs = (dict!.objectForKey("actualBlueRPs") as? Int)
            matchData.numDefenseCrossesByBlue = (dict!.objectForKey("numDefensesCrossedByBlue") as? Int)
            matchData.numDefenseCrossesByRed = (dict!.objectForKey("numDefensesCrossedByRed") as? Int)
            matchData.predictedBlueScore = (dict!.objectForKey("predictedBlueScore") as? Int)
            matchData.predictedRedScore = (dict!.objectForKey("predictedRedScore") as? Int)
            matchData.redRPs = (dict!.objectForKey("actualRedRPs") as? Int)
            matchData.optimalBlueDefenses = (dict!.objectForKey("optimalBlueDefenses") as? [String])
            matchData.optimalRedDefenses = (dict!.objectForKey("optimalRedDefenses") as? [String])
            matchData.blueWinChance = (dict!.objectForKey("blueWinChance") as? Int)
            matchData.redWinChance = (dict!.objectForKey("redWinChance") as? Int)
        }
        return matchData
        
    }
    func getTeamCalculatedDataFromDict(dict:NSDictionary) -> CalculatedTeamData {
        let teamData = CalculatedTeamData()
        return teamData
    }
    
    func getIntMatch(matchNumbah:Int) -> Match {        
        return self.matches[matchNumbah] 
    }
    
    func getcalcDataForTeamFromDict(dict:NSDictionary?) -> CalculatedTeamData {
        let calcData = CalculatedTeamData()
        if dict != nil {
            for key in self.teamCalcKeys {
                let value = dict!.objectForKey(key)
                
                calcData.setValue(value, forKey: key)
            }
            for key in self.defenseKeys {
                calcData.setValue(dict!.objectForKey(key) as! NSDictionary, forKey: key)
            }
            
            calcData.cdfCrossed = (calcData.avgSuccessfulTimesCrossedDefensesTele!["a"]!["cdf"] as? Int)
            calcData.pcCrossed = (calcData.avgSuccessfulTimesCrossedDefensesTele!["a"]!["pc"] as? Int)
            calcData.mtCrossed = (calcData.avgSuccessfulTimesCrossedDefensesTele!["b"]!["mt"] as? Int)
            calcData.rpCrossed = (calcData.avgSuccessfulTimesCrossedDefensesTele!["b"]!["rp"] as? Int)
            calcData.dbCrossed = (calcData.avgSuccessfulTimesCrossedDefensesTele!["c"]!["db"] as? Int)
            calcData.spCrossed = (calcData.avgSuccessfulTimesCrossedDefensesTele!["c"]!["sp"] as? Int)
            calcData.rtCrossed = (calcData.avgSuccessfulTimesCrossedDefensesTele!["d"]!["rt"] as? Int)
            calcData.rwCrossed = (calcData.avgSuccessfulTimesCrossedDefensesTele!["d"]!["rw"] as? Int)
            // calcData.lbCrossed = (calcData.avgSuccessfulTimesCrossedDefensesTele!["e"]!["lb"] as? Int)
        }
        return calcData
        
    }
    
    func getCalculatedTeamInMatchDataForDict(dict: NSDictionary?) -> TeamInMatchCalculatedData? {
        if dict != nil {
            let CTIMD = TeamInMatchCalculatedData()
            for key in self.calculatedTeamInMatchDataKeys {
                if let value = dict!.objectForKey(key) {
                    CTIMD.setValue(value, forKey: key)
                }
            }
            return CTIMD
        }
        return nil
    }
    
    func getTeamInMatchDataForDict(dict:NSDictionary) -> TeamInMatchData? {
        let TIMData = TeamInMatchData()
        
        for key in self.teamInMatchKeys {
            if let value = dict.objectForKey(key) as? Int {
                TIMData.setValue(value, forKey: key)
                
            }
            //print(value)
        }
        return TIMData
    }
    
    func getPickList() -> [Team] {
        let sortedArray = self.teams.sort { $0.calculatedData!.firstPickAbility?.integerValue > $1.calculatedData!.firstPickAbility?.integerValue }
        return sortedArray;
    }
    func getMatchesForTeam(teamNumbah:Int) -> [Match] {
        var matches = [Match]()
        for match in self.matches {
            let teamNumArray = (match).redAllianceTeamNumbers! + match.blueAllianceTeamNumbers!
            for number in teamNumArray {
                if number == teamNumbah {
                    matches.append(match)
                }
            }
        }
        return matches
    }
    
    func seedList() -> [Team] {
        let sortedArray = self.teams.sort { $0.calculatedData!.actualSeed?.integerValue > $1.calculatedData!.actualSeed?.integerValue }
        return sortedArray
    }
    func predSeedList() -> [Team] {
        let sortedArray = self.teams.sort { $0.calculatedData!.predictedSeed?.integerValue > $1.calculatedData!.predictedSeed?.integerValue }
        return sortedArray
    }
    
    func secondPickListFromDict(dict:NSDictionary) -> [Team] {
        var teamNumberArray = [Int]()
        let array = Array(dict)
        var godSpeed = [(Int,Int)]()
        //print("here is the dict")
        //print(dict)
        //print("this is the array")
        //print(array)
        //First Loop ensures type safety
        for (k,v) in array {
            let intermed = k as? String
            let key = Int(intermed!)
            let value = v as? Int
            
            
            
            godSpeed.append((key!,value!))
        }
        
        let sortedArray = godSpeed.sort {$0.1 > $1.1 }
        for (k,_) in sortedArray {
            teamNumberArray.append(k)
        }
        
        return self.getTeamsFromNumbers(teamNumberArray)
    }
    
    func getSortedListbyString(path:String) -> [Team] {
        let sortedArray = self.teams.sort { $0.valueForKey(path) as? Int > $1.valueForKey(path) as? Int }
        return sortedArray;
    }
    func secondPickList(teamNum:Int) -> [Team] {
        var tupleArray = [(Team,Int)]()
        for team in self.teams {
            if(team.calculatedData?.secondPickAbility?.objectForKey(String(teamNum)) != nil) {
                tupleArray.append(team,((team.calculatedData!.secondPickAbility!.objectForKey(String(teamNum))) as? Int)!)
            }
            else {
                tupleArray.append((team,-1))
            }
            
        }
        let sortedTuple = tupleArray.sort { $0.1 > $1.1 }
        var teamArray = [Team]()
        for (k,_) in sortedTuple {
            teamArray.append(k)
        }
        return teamArray
    }
    func filteredMatchesForSearchString(searchString:String) -> [Match] {
        var filteredMatches = [Match]()
        for match in self.matches  {
            let matche = match
            //print(searchString)
            //print(matche!.matchName)
            if String(matche.number).rangeOfString(searchString) != nil {
                //print("do we ever get here")
                filteredMatches.append(matche)
            }
            
        }
        //print(filteredMatches)
        return filteredMatches
    }
    func filteredTeamsForSearchString(searchString:String) -> [Team] {
        var filteredTeams = [Team]()
        for team in self.teams {
            if String(team.number).rangeOfString(searchString) != nil {
                filteredTeams.append(team)
            }
        }
        return filteredTeams
    }
    func getAverageDefenseValuesForDict(dict:NSDictionary) -> [Int] {
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
    func returnTeamImage(team:Team) -> UIImage {
        let path = getDocumentsPath().stringByAppendingString(self.getTeamFileName(team))
        let data = NSData(contentsOfFile: path)
        var image = UIImage()
        if data != nil {
            image = UIImage(data:data!)!
            
        } else {
            let url = NSURL(string:"https://i.ytimg.com/vi/tntOCGkgt98/maxresdefault.jpg")
            let data = NSData(contentsOfURL: url!)
            image = UIImage(data: data!)!
        }
        
        
        return image
    }
    func returnSynchronousTeamImage(team:Team) -> UIImage? {
        if team.selectedImageUrl != nil {
            let url = NSURL(string:team.selectedImageUrl!)
            if let data = NSData(contentsOfURL: url!) {
                let image = UIImage(data:data)
                return image
            }
        }
        return nil
    }
    func getTeamImage(team: Team) {
        //let fileManager = NSFileManager.defaultManager()
        var paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let documentsDirectory = paths[0]
        let fullPath = documentsDirectory + String(team.number) + "_Selected_Image"
        if let image = UIImage(contentsOfFile: fullPath) {
            print("HERES THE IMAGE")
            let notification = NSNotification(name: "gotTeamImage", object: image, userInfo: nil)
            NSNotificationCenter.defaultCenter().postNotification(notification)
        }
        else {
            let url = NSURL(string:team.selectedImageUrl!)
            //print("Download Started")
            //print("lastPathComponent: " + (url!.lastPathComponent ?? ""))
            if (String(url) != "-1") {
                
                getDataFromUrl(url!) { (data, response, error)  in
                    dispatch_async(dispatch_get_main_queue()) { () -> Void in
                        guard let data = data where error == nil else { return }
                        //print(response?.suggestedFilename ?? "")
                        //print("Download Finished")
                        let image = UIImage(data: data)
                        let notification = NSNotification(name: "gotTeamImage", object: image, userInfo: nil)
                        NSNotificationCenter.defaultCenter().postNotification(notification)
                    }
                }
            }
            
        }
    }
    func getDataFromUrl(url:NSURL, completion: ((data: NSData?, response: NSURLResponse?, error: NSError? ) -> Void)) {
        NSURLSession.sharedSession().dataTaskWithURL(url) { (data, response, error) in
            completion(data: data, response: response, error: error)
            }.resume()
    }
    func saveImage(image:UIImage, withName:String) {
        if let jpgImageData = UIImageJPEGRepresentation(image,1.0) {
            let imagePath = getDocumentsPath().stringByAppendingString(withName)
            jpgImageData.writeToFile(imagePath, atomically:true)
            print("Saved to: " + imagePath)
        }
    }
    func downloadAllImages() {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), {
            for team in self.teams {
                self.imageUrls[team.number!.integerValue] = team.selectedImageUrl
                let name = self.getTeamFileName(team)
                let image = self.returnSynchronousTeamImage(team)
                if image != nil {
                    self.saveImage(image!, withName: name)
                }
            }
        })
    }
    func updateImages() {
        if (self.imageUrls.count == 0) {
            self.downloadAllImages()
        }
        else {
            var image = UIImage()
            var teame = Team()
            for team in self.teams {
                if self.imageUrls[team.number!.integerValue] != team.selectedImageUrl {
                    image = self.returnTeamImage(team)
                    teame = team
                    self.saveImage(image, withName: (getTeamFileName(teame)))
                }
            }
            
        }
    }
    func getDocumentsPath() -> String {
        let documentsPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
        return documentsPath
    }
    func LoadImageForTeam(team:Team) {
        let path = getDocumentsPath().stringByAppendingString(self.getTeamFileName(team))
        let data = NSData(contentsOfFile: path)
        if data != nil {
            let image = UIImage(data:data!)
            //print(image)
            let notification = NSNotification(name: "gotTeamImage", object: image, userInfo: nil)
            NSNotificationCenter.defaultCenter().postNotification(notification)
            
        } else {
            self.test(team)
        }
        
        
    }
    func getTeamFileName(team:Team) -> String {
        return String(team.number) + "_Selected_Image"
    }
    func test(team:Team) {
        let url = NSURL(string:"https://i.ytimg.com/vi/tntOCGkgt98/maxresdefault.jpg")
        let data = NSData(contentsOfURL: url!)
        let image = UIImage(data: data!)
        let notification = NSNotification(name: "gotTeamImage", object: image, userInfo: nil)
        NSNotificationCenter.defaultCenter().postNotification(notification)
    }
    func getMatchValuesForTeamForPath(path:String, forTeam:Team) -> [Float] {
        let timDatas = getTeamInMatchDatasForTeam(forTeam)
        var valueArray = [Float]()
        for timData in timDatas {
            let value = timData.valueForKey(path) as? Float
            valueArray.append(value!)
        }
        return valueArray
    }
}

