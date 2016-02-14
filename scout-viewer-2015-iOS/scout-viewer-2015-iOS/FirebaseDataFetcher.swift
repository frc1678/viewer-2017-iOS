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

class FirebaseDataFetcher: NSObject, UITableViewDelegate {
    
    var teams = [Team]()
    var matches = [AnyObject]()
    var allTheData = NSDictionary()
    var firebase = Firebase(url: "https://1678-dev-2016.firebaseio.com")
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
        //"timesCrossedDefensesTele",
    ]
    
    var teamCalcKeys = ["actualSeed",
        "avgBallControl",
        "avgBallsKnockedOffMidlineAuto",
        "avgDefense",
        "avgEvasion",
        //"avgFailedTimesCrossedDefensesAuto",
        //"avgFailedTimesCrossedDefensesTele",
        "avgGroundIntakes",
        "avgHighShotsAuto",
        "avgHighShotsTele",
        "avgLowShotsAuto",
        "avgLowShotsTele",
        "avgMidlineBallsIntakedAuto",
        "avgShotsBlocked",
        "avgSpeed",
        //"avgSuccessfulTimesCrossedDefensesAuto",
        //"avgSuccessfulTimesCrossedDefensesTele",
        "avgTorque",
        "challengePercentage",
        "disabledPercentage",
        "disfunctionalPercentage",
        //"driverAbility",
        "firstPickAbility",
        "highShotAccuracyAuto",
        "highShotAccuracyTele",
        "incapacitatedPercentage",
        "lowShotAccuracyAuto",
        "lowShotAccuracyTele",
        "numAutoPoints",
        "numRPs",
        "numScaleAndChallengePoints",
        "predictedSeed",
        "reachPercentage",
        "scalePercentage",
        "sdBallsKnockedOffMidlineAuto",
        //"sdFailedDefenseCrossesAuto",
        //"sdFailedDefenseCrossesTele",
        "sdGroundIntakes",
        "sdHighShotsAuto",
        "sdHighShotsTele",
        "sdLowShotsAuto",
        "sdLowShotsTele",
        "sdMidlineBallsIntakedAuto",
        "sdShotsBlocked",
        //"sdSuccessfulDefenseCrossesAuto",
        //"sdSuccessfulDefenseCrossesTele",
        //"secondPickAbility",
        "siegeAbility",
        "siegeConsistency",
        "siegePower"]
    
    override init() {
        super.init()
        self.getAllTheData()
    }
    
    
    
    func getAllTheData() {
        
        
        
        
        let matchReference = Firebase(url: "https://1678-dev-2016.firebaseio.com/Matches")
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
            if(self.matches.count == 95) { //This is sketch and should not be done in this way
                NSNotificationCenter.defaultCenter().postNotificationName("updateLeftTable", object:nil)
            }
            
            
        })
        let teamReference = Firebase(url:"https://1678-dev-2016.firebaseio.com/Teams")
        teamReference.observeEventType(.ChildAdded, withBlock: { snapshot in
            let team = Team()
            let d = snapshot.value as! NSDictionary
            if let name = (d["name"] as? String) {
                team.name = name
                team.number = (d["number"] as? Int)!
                let teamDict = (d["calculatedData"] as? NSDictionary)!
                team.calculatedData = self.getcalcDataForTeamFromDict(teamDict)
                
                self.teams.append(team)
            }
            
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
                print("Does this work?")
                TIMData.setValue(dankMeme?.objectForKey(key), forKey: key)
            }
            print("pls no")
            print(dankMeme)
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
    func valuesInCompetitionOfPathForTeams(path:NSString) -> NSArray {
        let array = NSMutableArray()
        for team in self.teams {
            array.addObject(team.valueForKeyPath(path as String)!)
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
        return NSArray(array: self.teams).sortedArrayUsingDescriptors([descriptor]) as! [Team]
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
            if match.number == number {
                array.append(match as! Match)
            }
        }
        return array
    }
    func getMatchCalculatedDatafromDict(dict: NSDictionary) -> MatchCalculatedData {
        
        let matchData = MatchCalculatedData()
        matchData.blueRPs = (dict.objectForKey("actualBlueRPs") as? Int)!
        matchData.numDefenseCrossesByBlue = (dict.objectForKey("numDefensesCrossedByBlue") as? Int)!
        matchData.numDefenseCrossesByRed = (dict.objectForKey("numDefensesCrossedByRed") as? Int)!
        if let predictedBlueScore = dict.objectForKey("predictedBlueScore") as? NSMutableDictionary {
            matchData.predictedBlueScore = predictedBlueScore["score"] as! Int
        } else {
            matchData.predictedBlueScore = dict.objectForKey("predictedBlueScore") as! Int
        }
        if let predictedRedScore = dict.objectForKey("predictedRedScore") as? NSMutableDictionary {
            matchData.predictedRedScore = predictedRedScore["score"] as! Int
        } else {
            matchData.predictedRedScore = dict.objectForKey("predictedRedScore") as! Int
        }
        matchData.redRPs = (dict.objectForKey("actualRedRPs") as? Int)!
        
        return matchData
        
    }
    func getTeamCalculatedDataFromDict(dict:NSDictionary) -> CalculatedTeamData {
        let teamData = CalculatedTeamData()
        print(dict)
        return teamData
    }
    
    func getIntMatch(matchNumbah:Int) -> Match {
        return self.matches[matchNumbah] as! Match 
    }
    
    func getcalcDataForTeamFromDict(dict:NSDictionary) -> CalculatedTeamData {
        let calcData = CalculatedTeamData()
        for key in self.teamCalcKeys {
            let value = dict.objectForKey(key) as? Int
            calcData.setValue(value, forKey: key)
        }
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
    
    func getFirstPickList() -> [Team] {
        let sortedArray = self.teams.sort { $0.calculatedData.firstPickAbility < $1.calculatedData.firstPickAbility }
        print(sortedArray.count)
        return sortedArray
    }
    
    func getSecondPickList() -> [Team] {
        let sortedArray = self.teams.sort { $0.calculatedData.secondPickAbility < $1.calculatedData.secondPickAbility }
        print(sortedArray.count)
        return sortedArray
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
        let sortedArray = self.teams.sort { $0.calculatedData.actualSeed < $1.calculatedData.actualSeed }
        return sortedArray
    }
    func predSeedList() -> [Team] {
        let sortedArray = self.teams.sort { $0.calculatedData.predictedSeed < $1.calculatedData.predictedSeed }
        return sortedArray
    }
    
}