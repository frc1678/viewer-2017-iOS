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
    var matches = [AnyObject]()
    var allTheData = NSDictionary()
    var dataStack : DATAStack = DATAStack()
    var teamInMatchKeys = [
        "ballsIntakedAuto",
        "didChallengeTele",
        "didGetDisabled",
        "didGetIncapacitated",
        "didReachAuto",
        "didScaleTele",
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
        "driverAbility",
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
        "siegeConsistency",
        "siegePower"]
    
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
    
    func getAllTheData() {
        //Firebase.defaultConfig().persistenceEnabled = true
        let matchReference = Firebase(url: "https://1678-dev2-2016.firebaseio.com/Matches")
        matchReference.observeEventType(.ChildAdded, withBlock: { snapshot in
            let match = Match()
            //var hello = (snapshot.value.objectForKey("blueAllianceDidCapture") as? String)!
            match.blueAllianceTeamNumbers = (snapshot.value.objectForKey("blueAllianceTeamNumbers") as? [Int])!
            match.blueDefensePositions = (snapshot.value.objectForKey("blueDefensePositions") as? [String])!
            match.blueScore = (snapshot.value.objectForKey("blueScore") as? Int)!
            let calculatedDict = (snapshot.value.objectForKey("calculatedData") as? NSDictionary)!
            match.calculatedData = self.getMatchCalculatedDatafromDict(calculatedDict)
            match.number = (snapshot.value.objectForKey("number") as? Int)!
            //match.redAllianceDidCapture = (snapshot.value.objectForKey("redAllianceDidCapture") as? Bool)!
            match.redAllianceTeamNumbers = (snapshot.value.objectForKey("redAllianceTeamNumbers") as? [Int])!
            match.redDefensePositions = (snapshot.value.objectForKey("redDefensePositions") as? [String])!
            match.redScore = snapshot.value.objectForKey("redScore") as! Int
            
            self.matches.append(match)
           
            NSNotificationCenter.defaultCenter().postNotificationName("updateLeftTable", object:nil)
            
            
        })
        let teamReference = Firebase(url:"https://1678-dev2-2016.firebaseio.com/Teams")
        teamReference.observeEventType(.ChildAdded, withBlock: { snapshot in
            let team = Team()
            team.name = (snapshot.value.objectForKey("name") as? String)!
            team.number = (snapshot.value.objectForKey("number") as? Int)!
            team.pitDriveBaseLength = (snapshot.value.objectForKey("pitDriveBaseLength") as? Int)!
            team.pitBumperHeight = (snapshot.value.objectForKey("pitBumperHeight") as? Int)!
            team.pitDriveBaseWidth = (snapshot.value.objectForKey("pitDriveBaseWidth") as? Int)!
            team.pitLowBarCapability = (snapshot.value.objectForKey("pitLowBarCapability") as? Bool)!
            team.pitNotes = (snapshot.value.objectForKey("pitNotes") as? String)!
            team.pitNumberOfWheels = (snapshot.value.objectForKey("pitNumberOfWheels") as? Int)!
            team.pitOrganization = (snapshot.value.objectForKey("pitOrganization") as? Int)!
            team.pitPotentialLowBarCapability = (snapshot.value.objectForKey("pitPotentialLowBarCapability") as? Int)!
            team.pitPotentialMidlineBallCapability = (snapshot.value.objectForKey("pitPotentialMidlineBallCapability") as? Int)!
            team.pitPotentialShotBlockerCapability = (snapshot.value.objectForKey("pitPotentialShotBlockerCapability") as? Int)!
            team.selectedImageUrl = (snapshot.value.objectForKey("selectedImageUrl") as? String)!
            let teamDict = (snapshot.value.objectForKey("calculatedData") as? NSDictionary)!
            team.calculatedData = self.getcalcDataForTeamFromDict(teamDict)
            
            self.teams.append(team)
            NSNotificationCenter.defaultCenter().postNotificationName("updateLeftTable", object:nil)
        })
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
        let dankString = "https://1678-dev-2016.firebaseio.com/TeamInMatchDatas/"
        let TIMRef = Firebase(url:dankString)
        let TIMData = TeamInMatchData()
        TIMRef.observeEventType(.Value, withBlock: { snapshot in
            let key = String(team.number)+"Q"+String(inMatch.number)
            let dankMeme = (snapshot.value.objectForKey(key))
            for key in self.teamInMatchKeys {
        
                TIMData.setValue(dankMeme?.objectForKey(key), forKey: key)
            }
        })
        return TIMData
        
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
            if loopTeam.number == team.number {
                return counter
            }
        }
        return counter
    }
    func getTeamsFromNumbers(teamNums:[Int]) -> [Team] {
        var teams = [Team]()
        for teamNum in teamNums {
            teams.append(self.fetchTeam(teamNum))
        }
        return teams
    }
    func getTeamInMatchDatasForTeam(team:Team) -> [TeamInMatchData]{
        let ref = Firebase(url:"https://1678-dev-2016.firebaseio.com/TeamInMatchDatas")
        var TIMDatas = [TeamInMatchData]()
        let teamNum = String(team.number)
        ref.observeEventType(.ChildAdded, withBlock: { datasnapshot in
            let range = Range(start:teamNum.startIndex,end:teamNum.endIndex)
            if datasnapshot.key.substringWithRange(range) == teamNum {
                TIMDatas.append((datasnapshot.value as? TeamInMatchData)!)
            }
        })
        return TIMDatas
    }
    func valuesInTeamMatchesOfPath(path:NSString, forTeam:Team) -> NSMutableArray {
        let array = NSMutableArray()
        let teamInMatchDatas = self.getTeamInMatchDatasForTeam(forTeam)
        for data in teamInMatchDatas {
            array.addObject(data.valueForKey(path as String)!)
            
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
        let TIMDatas = self.getTeamInMatchDatasForTeam(self.fetchTeam(timData.teamNumber))
        for timData in TIMDatas {
            values.append(timData.teamNumber)
        }
        return values.indexOf(timData.matchNumber)! + 1
    }
    func valuesInCompetitionOfPathForTeams(path:String) -> NSArray {
        let array = NSMutableArray()
        for team in self.teams {
            array.addObject(team.valueForKeyPath(path)!)
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
                return matche as! Match 
            }
        }
        return Match()
    }
    func allTeamsInMatch(match:Match) -> [Team]  {
        let redTeams = getTeamsFromNumbers(match.redAllianceTeamNumbers)
        let blueTeams = getTeamsFromNumbers(match.blueAllianceTeamNumbers)
        
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
            if let matche = match as? Match {
                for teamNumber in matche.redAllianceTeamNumbers {
                    if teamNumber == number {
                        array.append(matche)
                    }
                }
                for teamNumber in matche.blueAllianceTeamNumbers {
                    if teamNumber == number {
                        array.append(matche)
                    }
                }
            }
        }
        return array
    }
    func getMatchCalculatedDatafromDict(dict:NSDictionary) -> MatchCalculatedData {
        
        let matchData = MatchCalculatedData()
        matchData.blueRPs = (dict.objectForKey("actualBlueRPs") as? Int)!
        matchData.numDefenseCrossesByBlue = (dict.objectForKey("numDefensesCrossedByBlue") as? Int)!
        matchData.numDefenseCrossesByRed = (dict.objectForKey("numDefensesCrossedByRed") as? Int)!
        matchData.predictedBlueScore = (dict.objectForKey("predictedBlueScore") as? Int)!
        matchData.predictedRedScore = (dict.objectForKey("predictedRedScore") as? Int)!
        matchData.redRPs = (dict.objectForKey("actualRedRPs") as? Int)!
        
        return matchData
        
    }
    func getTeamCalculatedDataFromDict(dict:NSDictionary) -> CalculatedTeamData {
        let teamData = CalculatedTeamData()
        return teamData
    }
    
    func getIntMatch(matchNumbah:Int) -> Match {        
        return self.matches[matchNumbah] as! Match 
    }
    
    func getcalcDataForTeamFromDict(dict:NSDictionary) -> CalculatedTeamData {
        let calcData = CalculatedTeamData()
        for key in self.teamCalcKeys {
            let value = dict.objectForKey(key)
            calcData.setValue(value, forKey: key)
        }
        let valueArray = self.getAverageDefenseValuesForDict((dict.objectForKey("avgSuccessfulTimesCrossedDefensesTele") as? NSDictionary)!)
        calcData.avgCdfCrossed = valueArray[0]
        calcData.avgPcCrossed = valueArray[1]
        calcData.avgMtCrossed = valueArray[2]
        calcData.avgRtCrossed = valueArray[3]
        calcData.avgDbCrossed = valueArray[4]
        calcData.avgSpCrossed = valueArray[5]
        calcData.avgRtCrossed = valueArray[6]
        calcData.avgRwCrossed = valueArray[7]
        calcData.avgLbCrossed = valueArray[8]
        return calcData
        
    }
    func getteamInMatchDataForDict(dict:NSDictionary) -> TeamInMatchData {
        let TIMData = TeamInMatchData()
        for key in self.teamInMatchKeys {
            print("GettingTIM!")
            let value = dict.objectForKey(key) as? Int
            TIMData.setValue(value, forKey: key)
        }
        return TIMData
    }
    
    func getPickList() -> [Team] {
        let sortedArray = self.teams.sort { $0.calculatedData.firstPickAbility > $1.calculatedData.firstPickAbility }
        return sortedArray;
    }
    func getMatchesForTeam(teamNumbah:Int) -> [Match] {
        var matches = [Match]()
        for match in self.matches {
            let teamNumArray = (match as? Match)!.redAllianceTeamNumbers + match.blueAllianceTeamNumbers
            for number in teamNumArray {
                if number == teamNumbah {
                    matches.append(match as! Match)
                }
            }
        }
        return matches
    }
    
    func seedList() -> [Team] {
        let sortedArray = self.teams.sort { $0.calculatedData.actualSeed > $1.calculatedData.actualSeed }
        return sortedArray
    }
    func predSeedList() -> [Team] {
        let sortedArray = self.teams.sort { $0.calculatedData.predictedSeed > $1.calculatedData.predictedSeed }
        return sortedArray
    }
//    func secondPickList() -> [Team] {
//        let sortedArray = self.teams.sort { $0.calculatedData.secondPickAbility > $1.calculatedData.secondPickAbility }
//        return sortedArray
//    }
    func secondPickListFromDict(dict:NSDictionary) -> [Team] {
        var teamNumberArray = [Int]()
        let array = Array(dict)
        var godSpeed = [(Int,Int)]()
        print("here is the dict")
        print(dict)
        print("this is the array")
        print(array)
        //First Loop ensures type safety
        for (k,v) in array {
            let intermed = k as? String
            let key = Int(intermed!)
            let value = v as? Int
        
            print(key)
            print(value)
            godSpeed.append((key!,value!))
        }
        
       let sortedArray = godSpeed.sort {$0.1 > $1.1 }
        for (k,_) in sortedArray {
            teamNumberArray.append(k)
        }
        print(teamNumberArray)
        return self.getTeamsFromNumbers(teamNumberArray)
    }
    
    func getSortedListbyString(path:String) -> [Team] {
        let sortedArray = self.teams.sort { $0.valueForKey(path) as? Int > $1.valueForKey(path) as? Int }
        return sortedArray;
    }
    func secondPickList(teamNum:Int) -> [Team] {
        var tupleArray = [(Team,Int)]()
        for team in self.teams {
            if(team.calculatedData.secondPickAbility.objectForKey(String(teamNum)) != nil) {
                 tupleArray.append(team,((team.calculatedData.secondPickAbility.objectForKey(String(teamNum))) as? Int)!)
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
            let matche = match as? Match
            print(searchString)
            print(matche!.matchName)
            if String(matche!.number).rangeOfString(searchString) != nil {
                print("do we ever get here")
                filteredMatches.append(matche!)
            }
            
        }
        print(filteredMatches)
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
        print(valueArray)
        return valueArray
    }
    func geteTeamImage(team:Team) -> UIImage {
        
        let url = NSURL(string:"https://dl.dropboxusercontent.com/u/63662632/1678.jpeg")
        let data = NSData(contentsOfURL:url!)
        let image = UIImage(data: data!)
        
        return image!
    }
    func getTeamImage(team: Team){
        let url = NSURL(string:"https://dl.dropboxusercontent.com/u/63662632/1678.jpeg")
        print("Download Started")
        print("lastPathComponent: " + (url!.lastPathComponent ?? ""))
        getDataFromUrl(url!) { (data, response, error)  in
            dispatch_async(dispatch_get_main_queue()) { () -> Void in
                guard let data = data where error == nil else { return }
                print(response?.suggestedFilename ?? "")
                print("Download Finished")
                let image = UIImage(data: data)
                let notification = NSNotification(name: "gotTeamImage", object: image, userInfo: nil)
                NSNotificationCenter.defaultCenter().postNotification(notification)
            }
        }
    }
    func getDataFromUrl(url:NSURL, completion: ((data: NSData?, response: NSURLResponse?, error: NSError? ) -> Void)) {
    NSURLSession.sharedSession().dataTaskWithURL(url) { (data, response, error) in
    completion(data: data, response: response, error: error)
    }.resume()
    }
    
}

