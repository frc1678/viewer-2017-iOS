//
//  Utils.swift
//  scout-viewer-2016-iOS
//
//  Created by Citrus Circuits on 2/19/15.
//  Copyright (c) 2016 Citrus Circuits. All rights reserved.
//

import Foundation



func roundValue(_ value: AnyObject?, toDecimalPlaces numDecimalPlaces: Int) -> String {
    if let val = value as? NSNumber {
        let f = NumberFormatter()
        f.numberStyle = NumberFormatter.Style.decimal
        f.maximumFractionDigits = numDecimalPlaces
        
        if val == 0 {
            return "0"
        }
        
        return f.string(from: val as NSNumber!)!
    }
    
    return ""
}

func percentageValueOf(_ number: AnyObject?) -> String {
    if let n = number as? Float {
        return "\(roundValue(NSNumber(value: n * 100), toDecimalPlaces: 1))%"
    }
    
    return ""
}

func insertCommasAndSpacesBetweenCapitalsInString(_ string: String) -> String {
    var toReturn = ""
    for char in string.characters {
        if "\(char)".uppercased() == "\(char)" {
            toReturn += ", \(char)"
        } else {
            toReturn.append(char)
        }
    }
    
    for _ in 0...1 {
        toReturn.remove(at: string.startIndex)
    }
    
    return toReturn
}

func nsNumArrayToIntArray(_ nsNumberArray: [NSNumber]) -> [Int] {
    var values: [Int] = []
    for num in nsNumberArray {
        if let int = Int("\(num)") {
            values.append(int)
        }
    }
    
    return values
}

@objc class Utils: NSObject {
    static let teamDetailsKeys = TeamDetailsKeys()
    struct TeamDetailsKeys {
        let plus1Keys = [
            "pitPotentialLowBarCapability",
            "pitPotentialMidlineBallCapability",
            "pitPotentialShotBlockerCapability"
        ]
        
        let yesNoKeys = [
            "pitLowBarCapability"
        ]
        
        let abilityKeys = [
            "calculatedData.firstPickAbility",
            "calculatedData.overallSecondPickAbility",
            "calculatedData.autoAbility",
            "calculatedData.citrusDPR",
            "calculatedData.RScoreDrivingAbility",
            "calculatedData.avgGroundIntakes",
            "calculatedData.avgTorque",
            "calculatedData.avgEvasion",
            "calculatedData.avgSpeed",
            "calculatedData.numAutoPoints",
            "calculatedData.avgBallControl",
            "calculatedData.avgDefense",
            "calculatedData.actualNumRPs",
            "calculatedData.predictedNumRPs",
            "calculatedData.siegeAbility"
        ]
        
        // Add carrying stability into stacking security
        
        
        
        
        
        
        /* let superKeys = [
        "calculatedData.avgEvasion",
        "calculatedData.avgDefense"
        ]
        */
        
        let notGraphingValues = [
            "First Pick Ability",
            "Second Pick Ability",
            "2 Ball Tried Auto",
            "2 Ball Accuracy Auto",
            "R Score Driving Ability"
        ]
        
        
        let longTextCells = [
            "pitNotes",
            "calculatedData.defensesCrossableAuto"
        ]
        
        let unrankedCells = [
            "selectedImageUrl",
            "otherUrls"
        ]
        
        let percentageValues = [
            "calculatedData.challengePercentage",
            "calculatedData.disabledPercentage",
            "calculatedData.disfunctionalPercentage",
            "calculatedData.incapacitatedPercentage",
            "calculatedData.scalePercentage",
            "calculatedData.siegeConsistency",
            "calculatedData.reachPercentage"
        ]
        
        let otherNoCalcDataValues = [
            "calculatedData.avgShotsBlocked",
            "calculatedData.avgLowShotsTele",
            "calculatedData.avgHighShotsTele",
            "calculatedData.avgBallsKnockedOffMidlineAuto",
            "calculatedData.avgMidlineBallsIntakedAuto"
        ]
        
        let addCommasBetweenCapitals = [
            "calculatedData.reconAcquisitionTypes"
        ]
        
        let boolValues = [
            "calculatedData.challengePercentage",
            "calculatedData.disabledPercentage",
            "calculatedData.incapacitatedPercentage",
        ]
        
        
        let keySetNamesOld = [
            "Information",
            "Ability - High Level",
            "Autonomous",
            "Defenses",
            "TeleOp",
            "Percentages",
            "Pit Scouting / Robot Design",
            "Additional Info",
        ]
        
        func keySetNames(_ minimalist : Bool) -> [String] {
            if minimalist {
                return  [
                    "",
                    "High Level",
                    "Autonomous",
                    "Teleoperated",
                    "A",
                    "B",
                    "C",
                    "D",
                    "LB",
                    "Siege",
                    "Status",
                    //superKeys,
                    //pitKeys,
                ]
            }
            return [
                "",
                "High Level",
                "Autonomous",
                "Teleoperated",
                "A",
                "B",
                "C",
                "D",
                "LB",
                "Siege",
                "Status",
                "Super Scout",
                "Pit Scout",
            ]
            
        }
        func keySets(_ minimalist : Bool) -> [[String]] {
            if minimalist {
                return [
                    defaultKeys,
                    highLevel,
                    autoKeysMini,
                    teleKeysMini,
                    A,
                    B,
                    C,
                    D,
                    LB,
                    siegeKeysMini,
                    statusKeysMini,
                    //superKeys,
                    //pitKeys,
                ]
            }
            return [
                defaultKeys,
                highLevel,
                autoKeys,
                teleKeys,
                A,
                B,
                C,
                D,
                LB,
                siegeKeys,
                statusKeys,
                superKeys,
                pitKeys,
            ]
            
        }
        
        let defaultKeys = [
            "TeamInMatchDatas",
            "matchDatas"
        ]
        
        let highLevel = [
            "calculatedData.firstPickAbility",
            "calculatedData.overallSecondPickAbility"
        ]
        
        let autoKeysMini = [
            //TODO: Add Avg. Num Shots in 2 ball Auto
            "calculatedData.numAutoPoints",
            "calculatedData.avgHighShotsAuto",
            "calculatedData.avgLowShotsAuto",
            "calculatedData.avgNumTimesCrossedDefensesAuto",
            "calculatedData.defensesCrossableAuto",
            //"calculatedData.highShotAccuracyAuto",
            //"calculatedData.lowShotAccuracyAuto",
            //"calculatedData.avgBallsKnockedOffMidlineAuto",
            //"calculatedData.avgMidlineBallsIntakedAuto"
        ]
        
        let autoKeys = [
            //TODO: Add Avg. Num Shots in 2 ball Auto
            "calculatedData.numAutoPoints",
            "calculatedData.avgHighShotsAuto",
            "calculatedData.avgLowShotsAuto",
            "calculatedData.avgNumTimesCrossedDefensesAuto",
            "calculatedData.highShotAccuracyAuto",
            "calculatedData.lowShotAccuracyAuto",
            "calculatedData.defensesCrossableAuto",
            "calculatedData.avgBallsKnockedOffMidlineAuto",
            "calculatedData.avgMidlineBallsIntakedAuto",
            "calculatedData.twoBallAutoTriedPercentage",
            "calculatedData.twoBallAutoAccuracy",
        ]
        
        let teleKeysMini = [
            "calculatedData.avgHighShotsTele",
            //"calculatedData.sdHighShotsTele",
            "calculatedData.avgLowShotsTele",
            "calculatedData.highShotAccuracyTele",
            "calculatedData.lowShotAccuracyTele",
            //"calculatedData.sdLowShotsTele",
            //"calculatedData.avgShotsBlocked",
            //"calculatedData.avgLowShotsAttemptedTele",
            //"calculatedData.avgHighShotsAttemptedTele",
            "calculatedData.teleopShotAbility",
        ]
        
        let teleKeys = [
            "calculatedData.avgHighShotsTele",
            "calculatedData.sdHighShotsTele",
            "calculatedData.avgLowShotsTele",
            "calculatedData.highShotAccuracyTele",
            "calculatedData.lowShotAccuracyTele",
            "calculatedData.sdLowShotsTele",
            "calculatedData.avgShotsBlocked",
            "calculatedData.avgLowShotsAttemptedTele",
            "calculatedData.avgHighShotsAttemptedTele",
            "calculatedData.teleopShotAbility",
        ]
        
        
        let obstacleKeys = [
            "calculatedData.avgSuccessfulTimesCrossedDefensesAuto.cdf",
            "calculatedData.avgSuccessfulTimesCrossedDefensesAuto.pc",
            "calculatedData.avgSuccessfulTimesCrossedDefensesAuto.mt",
            "calculatedData.avgSuccessfulTimesCrossedDefensesAuto.rp",
            "calculatedData.avgSuccessfulTimesCrossedDefensesAuto.db",
            "calculatedData.avgSuccessfulTimesCrossedDefensesAuto.sp",
            "calculatedData.avgSuccessfulTimesCrossedDefensesAuto.rt",
            "calculatedData.avgSuccessfulTimesCrossedDefensesAuto.rw",
            "calculatedData.avgSuccessfulTimesCrossedDefensesAuto.lb",
        ]
        
        let A = [
            "calculatedData.avgSuccessfulTimesCrossedDefensesAuto.cdf",
            "calculatedData.avgSuccessfulTimesCrossedDefensesAuto.pc",
        ]
        let B = [
            "calculatedData.avgSuccessfulTimesCrossedDefensesAuto.mt",
            "calculatedData.avgSuccessfulTimesCrossedDefensesAuto.rp",
        ]
        let C = [
            "calculatedData.avgSuccessfulTimesCrossedDefensesAuto.db",
            "calculatedData.avgSuccessfulTimesCrossedDefensesAuto.sp",
        ]
        let D = [
            "calculatedData.avgSuccessfulTimesCrossedDefensesAuto.rt",
            "calculatedData.avgSuccessfulTimesCrossedDefensesAuto.rw",
        ]
        let LB = [
            "calculatedData.avgSuccessfulTimesCrossedDefensesAuto.lb",
        ]
        
        let obstacleTeleKeys = [
            "calculatedData.avgSuccessfulTimesCrossedDefensesTele.cdf",
            "calculatedData.avgSuccessfulTimesCrossedDefensesTele.pc",
            "calculatedData.avgSuccessfulTimesCrossedDefensesTele.mt",
            "calculatedData.avgSuccessfulTimesCrossedDefensesTele.rp",
            "calculatedData.avgSuccessfulTimesCrossedDefensesTele.db",
            "calculatedData.avgSuccessfulTimesCrossedDefensesTele.sp",
            "calculatedData.avgSuccessfulTimesCrossedDefensesTele.rt",
            "calculatedData.avgSuccessfulTimesCrossedDefensesTele.rw",
            "calculatedData.avgSuccessfulTimesCrossedDefensesTele.lb"
        ]
        
        let siegeKeys = [
            "calculatedData.siegeConsistency",
            "calculatedData.scalePercentage",
            "calculatedData.challengePercentage"
        ]
        
        let siegeKeysMini = [
            //"calculatedData.siegeConsistency",
            "calculatedData.scalePercentage",
            "calculatedData.challengePercentage"
        ]
        
        let statusKeysMini = [
            "calculatedData.disfunctionalPercentage",
            //"calculatedData.disabledPercentage",
            //"calculatedData.incapacitatedPercentage",
        ]
        
        let statusKeys = [
            "calculatedData.disfunctionalPercentage",
            "calculatedData.disabledPercentage",
            "calculatedData.incapacitatedPercentage",
        ]
        
        let superKeys = [
            "calculatedData.RScoreDrivingAbility",
            "calculatedData.RScoreSpeed",
            "calculatedData.RScoreTorque",
            "calculatedData.RScoreAgility",
            "calculatedData.RScoreDefense",
            "calculatedData.RScoreBallControl"
        ]
        
        let pitKeys = [
            "pitOrganization",
            "pitProgrammingLanguage",
            "pitAvailableWeight",
            "pitNumberOfWheels",
            "pitNotes"
        ]
        
        let calculatedTeamInMatchDataHumanReadableKeys = [
            "First Pick Ability",
            "R Score Torque",
            "R Score Evasion",
            "R Score Speed",
            "High Shot Accuracy Auto",
            "Low Shot Accuracy Auto",
            "High Shot Accuracy Tele",
            "Low Shot Accuracy Tele",
            "Avg. High Shots in Tele",
            "Siege Ability",
            "Siege Power",
            "Number of RPs",
            "Number of Auto Points",
            "Number of Scale And Challenge Points",
            "R Score Defense",
            "R Score Ball Control",
            "R Score Driving Ability",
            "Citrus DPR",
            "Second Pick Ability",
            "Overall Second Pick Ability",
            "Score Contribution"
        ]
    }
    
    
    
    //End Team Details Keys
    
    
    static let autoKeys = ["uploadedData.stackedToteSet", "uploadedData.numContainersMovedIntoAutoZone"]
    static let teleKeys = ["uploadedData.numTotesStacked", "uploadedData.numReconLevels", "uploadedData.numNoodlesContributed", "uploadedData.numReconsStacked", "uploadedData.numTeleopReconsFromStep", "uploadedData.numHorizontalReconsPickedUp", "uploadedData.numVerticalReconsPickedUp", "calculatedData.numReconsPickedUp", "uploadedData.numTotesPickedUpFromGround", "uploadedData.numLitterDropped", "uploadedData.numStacksDamaged", "uploadedData.coopActions", "uploadedData.maxFieldToteHeight", "uploadedData.maxReconHeight", "uploadedData.reconAcquisitions" ]
    static let superKeys = ["uploadedData.agility", "uploadedData.stackPlacing" ]
    static let statusKeys = ["uploadedData.incapacitated", "uploadedData.disabled"]
    static let miscKeys = ["uploadedData.miscellaneousNotes"]
    
    
    static let TIMDAutoKeys = [
        "ballsIntakedAuto",
        "numBallsKnockedOffMidlineAuto",
        "numHighShotsMadeAuto",
        "numHighShotsMissedAuto",
        "numLowShotsMadeAuto",
        "numLowShotsMissedAuto"
    ]
     
    static let TIMDTeleKeys = [
        "numGroundIntakesTele",
        "numHighShotsMadeTele",
        "numHighShotsMissedTele",
        "numLowShotsMadeTele",
        "numLowShotsMissedTele",
        "numShotsBlockedTele"
    ]
     
    static let TIMDStatusKeys = [
        "didGetDisabled",
        "didGetIncapacitated"
    ]
    
    static let TIMDSuperKeys = [
        "rankBallControl",
        "rankDefense",
        "rankAgility",
        "rankSpeed",
        "rankTorque"
    ]
    
    static let TIMDKeys = [
        TIMDAutoKeys,
        TIMDTeleKeys,
        TIMDStatusKeys,
        TIMDSuperKeys
    ]
    
    static let defenseGraphableKeys = [
        "calculatedData.avgSuccessfulTimesCrossedDefensesAuto",
        "calculatedData.avgSuccessfulTimesCrossedDefensesTele",
        "calculatedData.avgFailedTimesCrossedDefensesAuto",
        "calculatedData.avgFailedTimesCrossedDefensesTele",
        "calculatedData.numTimesFailedCrossedDefensesTele",
        "calculatedData.avgTimeForDefenseCrossAuto",
        "calculatedData.avgTimeForDefenseCrossTele",
        "calculatedData.beachedPercentage",
        "calculatedData.slowedPercentage"
    ]
    
    static let defenseKeys = [
        "calculatedData.avgSuccessfulTimesCrossedDefensesAuto",
        "calculatedData.avgSuccessfulTimesCrossedDefensesTele",
        "calculatedData.avgFailedTimesCrossedDefensesAuto",
        "calculatedData.avgFailedTimesCrossedDefensesTele",
        
        "calculatedData.avgTimeForDefenseCrossAuto",
        "calculatedData.avgTimeForDefenseCrossTele",
        "calculatedData.predictedSuccessfulCrossingsForDefenseTele",
        "calculatedData.sdFailedDefenseCrossesAuto",
        "calculatedData.sdFailedDefenseCrossesTele",
        "calculatedData.sdSuccessfulDefenseCrossesAuto",
        "calculatedData.sdSuccessfulDefenseCrossesTele",
        
        "calculatedData.beachedPercentage",
        "calculatedData.slowedPercentage"
        
    ]
    
    class func defenseStatKeysToGraphableKeys(_ defenseStatKey: String) -> String {
        switch defenseStatKey {
        case "calculatedData.avgSuccessfulTimesCrossedDefensesAuto": return "calculatedData.numTimesSuccesfulCrossedDefensesAuto"
        case "calculatedData.avgSuccessfulTimesCrossedDefensesTele": return "calculatedData.numTimesSuccesfulCrossedDefensesTele"
        case "calculatedData.avgFailedTimesCrossedDefensesAuto": return "calculatedData.numTimesFailedCrossedDefensesAuto"
        case "calculatedData.avgFailedTimesCrossedDefensesTele": return "calculatedData.numTimesFailedCrossedDefensesTele"
            
        case "calculatedData.avgTimeForDefenseCrossAuto": return "calculatedData.crossingTimeForDefenseAuto"
        case "calculatedData.avgTimeForDefenseCrossTele": return "calculatedData.crossingTimeForDefenseTele"
            //Beached and slowed stay the same
        default: return "NO KEY"
        }
    }
    
    static let graphTitleSwitch = [
        "didScaleTele" : "scalePercentage",
        "didGetIncapacitated" : "incapacitatedPercentage",
        "didGetDisabled" : "disabledPercentage",
        "didChallengeTele" : "challengePercentage",
        "numShotsBlockedTele" : "avgShotsBlocked",
        "numLowShotsMadeTele" : "avgLowShotsTele",
        "numHighShotsMadeTele" : "avgHighShotsTele",
        "numBallsKnockedOffMidlineAuto" : "avgBallsKnockedOffMidlineAuto",
        "calculatedData.numBallsIntakedOffMidlineAuto" : "avgMidlineBallsIntakedAuto",
        "calculatedData.RScoreSpeed" : "calculatedData.avgSpeed",
        "calculatedData.RScoreEvasion" : "calculatedData.avgEvasion",
        "calculatedData.RScoreTorque" : "calculatedData.avgTorque",
        "rankBallControl" : "calculatedData.avgBallControl",
        ]
    
    static let teamCalcKeys = [
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
    
    static let calculatedTeamInMatchDataKeys = [
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
    static let calculatedTIMDataKeys = [
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
    
    static let humanReadableNames = [
        "calculatedData.actualSeed" : "Seed",
        "calculatedData.avgBallControl" : "Avg. Ball Controll",
        "calculatedData.avgBallsKnockedOffMidlineAuto" : "Avg. Mid. Auto Balls Knocked",
        "calculatedData.avgDefense" : "Avg. Defense",
        "calculatedData.avgEvasion" : "Avg. Evasion",
        "calculatedData.avgFailedTimesCrossedDefensesAuto" : "Avg. Cross Fails Auto",
        "calculatedData.avgFailedTimesCrossedDefensesTele" : "Avg. Cross Fails Tele",
        "calculatedData.avgGroundIntakes" : "Avg. Ground Intakes",
        "calculatedData.avgHighShotsAuto" : "Avg. High Shots in Auto",
        "calculatedData.avgHighShotsTele" : "Avg. High Shots in Tele",
        "calculatedData.avgLowShotsAuto" : "Avg. Low Shots in Auto",
        "calculatedData.avgLowShotsTele" : "Avg. Low Shots in Tele",
        "calculatedData.avgMidlineBallsIntakedAuto" : "Avg. Mid. Auto Balls Intaked",
        "calculatedData.avgShotsBlocked" : "Avg. Shots Blocked",
        "calculatedData.avgSpeed" : "Avg. Speed",
        "calculatedData.avgSuccessfulTimesCrossedDefensesAuto" : "Avg. Times Crossed Auto",
        "calculatedData.avgSuccessfulTimesCrossedDefensesTele" : "Avg. Times Crossed Tele",
        "calculatedData.avgTorque" : "Avg. Torque",
        "calculatedData.challengePercentage" : "Challenge Percentage",
        "calculatedData.disabledPercentage" : "Disabled Percentage",
        "calculatedData.disfunctionalPercentage" : "Disfunctional Percentage",
        "calculatedData.driverAbility" : "Driver Ability",
        "calculatedData.firstPickAbility" : "First Pick Ability",
        "calculatedData.highShotAccuracyAuto" : "H Shot Accuracy Auto",
        "calculatedData.highShotAccuracyTele" : "H Shot Accuracy Tele",
        "calculatedData.incapacitatedPercentage" : "Incapacitated Percentage",
        "calculatedData.lowShotAccuracyAuto" : "L Shot Accuracy Auto",
        "calculatedData.lowShotAccuracyTele" : "L Shot Accuracy Tele",
        "calculatedData.numAutoPoints" : "Number of Auto Points",
        "calculatedData.numRPs" : "Number of RPs",
        "calculatedData.actualNumRPs": "# of RPs",
        "calculatedData.predictedNumRPs" : "Predicted # of RPs",
        "calculatedData.numScaleAndChallengePoints" : "Scale and Challenge Points",
        "calculatedData.predictedSeed" : "Predicted Seed",
        "calculatedData.reachPercentage" : "Reach Percentage",
        "calculatedData.scalePercentage" : "Scale Percentage",
        "calculatedData.avgHighShotsAttemptedTele": "Avg. H Shots Tried Tele",
        //"calculatedData.sdBallsKnockedOffMidlineAuto" : "σ Balls off Midline Auto",
        //"calculatedData.sdFailedDefenseCrossesAuto" : "σ Failed Defenses Auto",
        "calculatedData.sdGroundIntakes" : "σ Ground Intakes",
        "calculatedData.sdHighShotsAuto" : "σ High Shots Auto",
        "calculatedData.sdHighShotsTele" : "σ High Shots Tele",
        "calculatedData.sdLowShotsAuto" : "σ Low Shots Auto",
        "calculatedData.sdLowShotsTele" : "σ Low Shots Tele",
        "calculatedData.sdMidlineBallsIntakedAuto" : "σ Midline Balls Intaked",
        "calculatedData.sdShotsBlocked" : "σ Shots Blocked",
        "calculatedData.sdSuccessfulDefenseCrossesAuto" : "σ Successful Defenses Auto",
        "calculatedData.sdSuccessfulDefenseCrossesTele" : "σ Successful Defenses Tele",
        "calculatedData.overallSecondPickAbility" : "Second Pick Ability",
        "calculatedData.siegeAbility" : "Siege Ability",
        "calculatedData.siegeConsistency" : "Siege Consistency",
        "calculatedData.siegePower" : "Siege Power",
        "matchDatas" : "Matches",
        "TeamInMatchDatas" : "TIMDs",
        "pitLowBarCapability": "Low Bar Ability",
        "calculatedData.autoAbility" : "Auto Ability",
        "calculatedData.citrusDPR" : "Citrus DPR",
        "calculatedData.RScoreDrivingAbility": " R Score Driving Ability",
        "calculatedData.drivingAbility": "Driving Ability",
        "pitPotentialLowBarCapability" : "Low Bar Potential",
        "pitHeightOfBallLeavingShooter": "Shot Release Height",
        "pitPotentialMidlineBallCapability" : "Mid Line Ball Potential",
        "pitDriveBaseWidth" : "Drive Base Width",
        "pitDriveBaseLength" : "Drive Base Length",
        "pitBumperHeight" : "Bumper Height",
        "pitPotentialShotBlockerCapability" : "Shot Blocking Potential",
        "pitNotes" : "Pit Notes",
        "pitCheesecakeAbility" : "Cheesecake Ease",
        "pitProgrammingLanguage": "Prog. Lang.",
        "pitAvailableWeight" : "Avail. Weight",
        "pitOrganization" : "Pit Organization",
        "calculatedData.avgSuccessfulTimesCrossedDefensesAuto.cdf": "CDF Times Crossed",
        "calculatedData.avgSuccessfulTimesCrossedDefensesAuto.pc" : "PC Times Crossed",
        "calculatedData.avgSuccessfulTimesCrossedDefensesAuto.mt" : "MT Times Crossed",
        "calculatedData.avgSuccessfulTimesCrossedDefensesAuto.rp" : "RP Times Crossed",
        "calculatedData.avgSuccessfulTimesCrossedDefensesAuto.db" : "DB Times Crossed",
        "calculatedData.avgSuccessfulTimesCrossedDefensesAuto.sp" : "SP Times Crossed",
        "calculatedData.avgSuccessfulTimesCrossedDefensesAuto.rt" : "RT Times Crossed",
        "calculatedData.avgSuccessfulTimesCrossedDefensesAuto.rw" : "RW Times Crossed",
        "calculatedData.avgSuccessfulTimesCrossedDefensesAuto.lb" : "LB Times Crossed",
        "calculatedData.beachedPercentage" : "Beached Percentage",
        "calculatedData.slowedPercentage" : "Slowed Percentage",
        "cdf":"Cheval De Frise",
        "pc" : "Portcullis",
        "mt" : "Moat",
        "rp" : "Ramparts",
        "db" : "DrawBridge",
        "sp" : "Sallyport",
        "rt" : "Rough Terrain",
        "rw" : "Rock Wall",
        "lb" : "Low Bar",
        "rankBallControl" : "Ball Control Rank",
        "didScaleTele" : "Did Scale",
        "didGetIncapacitated" : "Was Incap.",
        "didGetDisabled" : "Was Disabled",
        "didChallengeTele" : "Did Challenge",
        "numShotsBlockedTele" : "Num Shots Blocked Tele",
        "numLowShotsMadeTele" : "Num Low Shots Made Tele",
        "numHighShotsMadeTele" : "Num High Shots Made Tele",
        "numBallsKnockedOffMidlineAuto" : "Num Balls Off Midline Auto",
        "calculatedData.numBallsIntakedOffMidlineAuto" : "Num Mid Balls Intaked Auto",
        "calculatedData.RScoreSpeed" : "R Score Speed",
        "calculatedData.RScoreEvasion" : "R Score Evasion",
        "calculatedData.RScoreTorque" : "R Score Torque",
        "calculatedData.RScoreAgility": "R Score Agility",
        "calculatedData.RScoreDefense": "R Score Defense",
        "calculatedData.RScoreBallControl": "R Score Ball Control",
        "calculatedData.avgLowShotsAttemptedTele": "Avg. L Shots Tried Tele",
        "calculatedData.teleopShotAbility": "Teleop Shot Ability",
        "calculatedData.avgTimeForDefenseCrossAuto": "Avg. Time Cross Auto",
        "calculatedData.avgTimeForDefenseCrossTele":"Avg. Time Cross Tele",
        "calculatedData.predictedSuccessfulCrossingsForDefenseTele": "Pred Crossings Tele",
        "calculatedData.sdFailedDefenseCrossesAuto": "σ Failed Crosses Auto",
        "calculatedData.sdFailedDefenseCrossesTele":"σ Failed Crosses Tele",
        "pitNumberOfWheels":"Number of Wheels",
        "calculatedData.avgNumTimesCrossedDefensesAuto": "Avg. Crossings in Auto",
        "calculatedData.defensesCrossableAuto": "Has Crossed in Auto",
        "calculatedData.twoBallAutoTriedPercentage":"2 Ball Tried Auto",
        "calculatedData.twoBallAutoAccuracy":"2 Ball Accuracy Auto",
    ]
    
    class func roundValue(_ value: Float, toDecimalPlaces numDecimalPlaces: Int) -> String {
        let val = value as NSNumber
        let f = NumberFormatter()
        f.numberStyle = NumberFormatter.Style.decimal
        f.maximumFractionDigits = numDecimalPlaces
        
        if val == 0 {
            return "0"
        }
        
        return f.string(from: val)!
    }
    
    class func roundDoubleValue(_ value: Double, toDecimalPlaces numDecimalPlaces: Int) -> String {
        let val = value as NSNumber
        let f = NumberFormatter()
        f.numberStyle = NumberFormatter.Style.decimal
        f.maximumFractionDigits = numDecimalPlaces
        
        if val == 0 {
            return "0"
        }
        
        return f.string(from: val)!
    }
    
    class func getHumanReadableNameForKey(_ key: String) -> String? {
        return humanReadableNames[key]
    }
    class func findKeyForValue(_ value: String) ->String?
    {
        for (key, stringValue) in humanReadableNames
        {
            if (stringValue == value)
            {
                return key
            }
        }
        
        return nil
    }
    
    class func getKeyForHumanReadableName(_ name: String) -> String? {
        var computerReadableNames = [String: String]()
        for (key, value) in humanReadableNames {
            computerReadableNames[value] = key
        }
        return computerReadableNames[name]
    }
    class func isNull(_ object: AnyObject?) -> Bool {
        if object_getClass(object) == object_getClass(NSNull()) {
            return true
        }
        return false
    }
    
    /// This is presentable as a string on the screen. It won't have Optional() or anything like that in it.
    class func sp(thing : Any?) -> String {
        if thing != nil {
            if let s = thing as? String {
                return s
            } else if ((thing as? Int) != nil) || ((thing as? Float) != nil) || ((thing as? Double) != nil) {
                return "\(thing!)"
            } else if let n = thing as? NSNumber {
                return n.stringValue
            } else {
                print("Presentable String Unknown Type")
                return "\(thing)"
            }
        } else {
            return ""
        }
    }
}




