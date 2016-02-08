//
//  Utils.swift
//  scout-viewer-2015-iOS
//
//  Created by Citrus Circuits on 2/19/15.
//  Copyright (c) 2015 Citrus Circuits. All rights reserved.
//

import Foundation

let humanReadableNames = [
    "calculatedData.actualSeed" : "Seed",
    "calculatedData.avgBallControl" : "Avg. Ball Controll",
    "calculatedData.avgBallsKnockedOffMidlineAuto" : "Avg. Balls Off Mid Line",
    "calculatedData.avgDefense" : "Avg. Defense",
    "calculatedData.avgEvasion" : "Avg. Evasion",
    "calculatedData.avgFailedTimesCrossedDefensesAuto" : "Avg. Cross Fails Auto",
    "calculatedData.avgFailedTimesCrossedDefensesTele" : "Avg. Cross Fails Tele",
    "calculatedData.avgGroundIntakes" : "Avg. Ground Intakes",
    "calculatedData.avgHighShotsAuto" : "Avg. High Shots in Auto",
    "calculatedData.avgHighShotsTele" : "Avg. High Shots in Tele",
    "calculatedData.avgLowShotsAuto" : "Avg. Low Shots in Auto",
    "calculatedData.avgLowShotsTele" : "Avg. Low Shots in Tele",
    "calculatedData.avgMidlineBallsIntakedAuto" : "Avg. Mid Balls in Auto",
    "calculatedData.avgShotsBlocked" : "Avg. Shots Blocked",
    "calculatedData.avgSpeed" : "Avg. Speed",
    "calculatedData.avgSuccessfulTimesCrossedDefensesAuto" : "Idklol",
    "calculatedData.avgSuccessfulTimesCrossedDefensesTele" : "Idklol",
    "calculatedData.avgTorque" : "Avg. Torque",
    "calculatedData.challengePercentage" : "Challenge Percentage",
    "calculatedData.disabledPercentage" : "Disabled Percentage",
    "calculatedData.disfunctionalPercentage" : "Disfunctional Percentage",
    "calculatedData.driverAbility" : "Driver Ability",
    "calculatedData.firstPickAbility" : "First Pick Ability",
    "calculatedData.highShotAccuracyAuto" : "High Shot Accuracy Auto",
    "calculatedData.highShotAccuracyTele" : "High Shot Accuracy Tele",
    "calculatedData.incapacitatedPercentage" : "Incapacitated Percentage",
    "calculatedData.lowShotAccuracyAuto" : "Low Shot Accuracy Auto",
    "calculatedData.lowShotAccuracyTele" : "Low Shot Accuracy Tele",
    "calculatedData.numAutoPoints" : "Number of Auto Points",
    "calculatedData.numRPs" : "Number of RPs",
    "calculatedData.predictedNumRPs" : "Predicted Number of RPs",
    "calculatedData.numScaleAndChallengePoints" : "Scale and Challenge Points",
    "calculatedData.predictedSeed" : "Predicted Seed",
    "calculatedData.reachPercentage" : "Reach Percentage",
    "calculatedData.scalePercentage" : "Scale Percentage",
    "calculatedData.sdBallsKnockedOffMidlineAuto" : "σ Balls off Midline Auto",
    "calculatedData.sdFailedDefenseCrossesAuto" : "σ Failed Defenses Auto",
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
    "calculatedData.siegeAbility" : "Siege Ability",
    "calculatedData.siegeConsistency" : "Siege Consistency",
    "calculatedData.siegePower" : "Siege Power",
    "matchDatas" : "Matches",
    "pitPotentialLowBarCapability" : "Low Bar Capability",
    "pitPotentialMidlineBallCapability" : "Mid Line Ball Capability",
    "pitDriveBaseWidth" : "Drive Base Width",
    "pitDriveBaseLength" : "Drive Base Length",
    "pitBumperHeight" : "Bumper Height",
    "pitPotentialShotBlockerCapability" : "Shot Blocking Capacity",
    "pitNotes" : "Pit Notes",
    "pitOrganization" : "Pit Organization",
    "calculatedData.avgCdfCrossed" : "Avg. Times CDF Crossed",
    "calculatedData.avgPcCrossed" : "Avg. Times PC Crossed",
    "calculatedData.avgMtCrossed" : "Avg. Times MT Crossed",
    "calculatedData.avgRpCrossed" : "Avg. Times RP Crossed",
    "calculatedData.avgDbCrossed" : "Avg. Times DB Crossed",
    "calculatedData.avgSpCrossed" : "Avg. Times SP Crossed",
    "calculatedData.avgRtCrossed" : "Avg. Times RT Crossed",
    "calculatedData.avgRwCrossed" : "Avg. Times RW Crossed",
    "calculatedData.avgLbCrossed" : "Avg. Times LB Crossed"
]

func roundValue(value: AnyObject, toDecimalPlaces numDecimalPlaces: Int) -> String {
    if let val = value as? NSNumber {
        let f = NSNumberFormatter()
        f.numberStyle = NSNumberFormatterStyle.DecimalStyle
        f.maximumFractionDigits = numDecimalPlaces
        
        if val == 0 {
            return "0"
        }
        
        return f.stringFromNumber(val)!
    }
    
    return "\(value)"
}

func percentageValueOf(number: AnyObject) -> String {
    if let n = number as? Float {
        return "\(roundValue(n * 100, toDecimalPlaces: 2))%"
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
    
    for i in 0...1 {
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
    
    class func getHumanReadableNameForKey(key: String) -> String? {
        return humanReadableNames[key]
    }
}