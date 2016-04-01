//
//  Utils.swift
//  scout-viewer-2015-iOS
//
//  Created by Citrus Circuits on 2/19/15.
//  Copyright (c) 2015 Citrus Circuits. All rights reserved.
//

import Foundation



func roundValue(value: AnyObject?, toDecimalPlaces numDecimalPlaces: Int) -> String {
    if let val = value as? NSNumber {
        let f = NSNumberFormatter()
        f.numberStyle = NSNumberFormatterStyle.DecimalStyle
        f.maximumFractionDigits = numDecimalPlaces
        
        if val == 0 {
            return "0"
        }
        
        return f.stringFromNumber(val as NSNumber!)!
    }
    
    return ""
}

func percentageValueOf(number: AnyObject?) -> String {
    if let n = number as? Float {
        return "\(roundValue(n * 100, toDecimalPlaces: 1))%"
    }
    
    return ""
}

func isZero(object: AnyObject) -> Bool {
    if let obj = object as? Float where obj == 0 {
        return true
    }
    
    return false
}

func insertCommasAndSpacesBetweenCapitalsInString(string: String) -> String {
    var toReturn = ""
    for char in string.characters {
        if "\(char)".uppercaseString == "\(char)" {
            toReturn += ", \(char)"
        } else {
            toReturn.append(char)
        }
    }
    
    for _ in 0...1 {
        toReturn.removeAtIndex(string.startIndex)
    }
    
    return toReturn
}

func nsNumArrayToIntArray(nsNumberArray: [NSNumber]) -> [Int] {
    var values: [Int] = []
    for num in nsNumberArray {
        if let int = Int("\(num)") {
            values.append(int)
        }
    }
    
    return values
}

@objc class Utils: NSObject {
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
        "siegeConsistency": "Siege Consistency",
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
        "calculatedData.secondPickAbility" : "Second Pick Ability",
        "calculatedData.overallSecondPickAbility" : "Second Pick Ability",
        "calculatedData.siegeAbility" : "Siege Ability",
        "calculatedData.siegeConsistency" : "Siege Consistency",
        "calculatedData.siegePower" : "Siege Power",
        "matchDatas" : "Matches",
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
        "RScoreBallControl": "R Score Ball Control",
        "RScoreSpeed" : "R Score Speed",
        "RScoreTorque": "R Score Torque",
        "RScoreAgility": "R Score Agility",
        "RScoreDefense": "R Score Defense",
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
        
    ]
    
    class func roundValue(value: Float, toDecimalPlaces numDecimalPlaces: Int) -> String {
        let val = value as NSNumber
        let f = NSNumberFormatter()
        f.numberStyle = NSNumberFormatterStyle.DecimalStyle
        f.maximumFractionDigits = numDecimalPlaces
        
        if val == 0 {
            return "0"
        }
        
        return f.stringFromNumber(val)!
    }
    
    class func roundDoubleValue(value: Double, toDecimalPlaces numDecimalPlaces: Int) -> String {
        let val = value as NSNumber
        let f = NSNumberFormatter()
        f.numberStyle = NSNumberFormatterStyle.DecimalStyle
        f.maximumFractionDigits = numDecimalPlaces
        
        if val == 0 {
            return "0"
        }
        
        return f.stringFromNumber(val)!
    }
    
    class func getHumanReadableNameForKey(key: String) -> String? {
        return humanReadableNames[key]
    }
   class func findKeyForValue(value: String) ->String?
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
    
    class func getKeyForHumanReadableName(name: String) -> String? {
        var computerReadableNames = [String: String]()
        for (key, value) in humanReadableNames {
            computerReadableNames[value] = key
        }
        return computerReadableNames[name]
    }
    class func isNull(object: AnyObject?) -> Bool {
        if object_getClass(object) == object_getClass(NSNull()) {
            return true
        }
        return false
    }
    
}



