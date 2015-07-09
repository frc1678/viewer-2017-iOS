//
//  Utils.swift
//  scout-viewer-2015-iOS
//
//  Created by Citrus Circuits on 2/19/15.
//  Copyright (c) 2015 Citrus Circuits. All rights reserved.
//

import Foundation

let humanReadableNames = [
    "calculatedData.firstPickAbility" : "First Pick Ability",
    "calculatedData.secondPickAbility" : "Second Pick Ability",
    "calculatedData.stackingAbility" : "Stacking Ability",
    "calculatedData.noodleReliability" : "Noodle Reliability",
    "calculatedData.avgNumMaxHeightStacks" : "Avg. Max Height Stacks",
    "calculatedData.reconAbility" : "Recon Ability",
    "calculatedData.reconReliability" : "Recon Reliability",
    "calculatedData.isRobotMoveIntoAutoZonePercentage" : "Moved Into Auto",
    "calculatedData.isStackedToteSetPercentage" : "Stacked Tote Set",
    "calculatedData.avgStepReconsAcquiredInAuto" : "Avg. Step Recons",
    "calculatedData.stepReconSuccessRateInAuto" : "Step Recon Success",
    "calculatedData.avgNumTotesMoveIntoAutoZone" : "Avg. Totes Into Auto",
    "calculatedData.avgNumTotesStacked" : "Avg. Totes Stacked",
    "calculatedData.avgNumReconLevels" : "Avg. Recon Levels",
    "calculatedData.avgNumNoodlesContributed" : "Avg. Noodles Cont.",
    "calculatedData.avgNumReconsStacked" : "Avg. Recons Stacked",
    "calculatedData.avgNumReconsPickedUp" : "Avg. Recons Intaked",
    "calculatedData.avgNumTotesPickedUpFromGround" : "Avg. Ground Totes",
    "calculatedData.avgNumLitterDropped" : "Avg. Noodles Dropped",
    "calculatedData.avgNumStacksDamaged" : "Avg. Stacks Damaged",
    "calculatedData.avgMaxFieldToteHeight" : "Avg. Max Tote Height",
    "calculatedData.avgMaxReconHeight" : "Avg. Max Recon Height",
    "calculatedData.avgNumLitterThrownToOtherSide" : "Avg. Litter Thrown",
    "calculatedData.avgAgility" : "Agility",
    "calculatedData.driverAbility" : "Driver Ability",
    "calculatedData.avgStackPlacing" : "Stack Placing",
    "calculatedData.avgHumanPlayerLoading" : "HP Loading",
    "calculatedData.incapacitatedPercentage" : "Incapacitated",
    "calculatedData.disabledPercentage" : "Disabled",
    "calculatedData.reliability" : "Reliability",
    "calculatedData.avgReconStepAcquisitionTime" : "Avg. Step Recon Time",
    "calculatedData.reconAcquisitionTypes" : "Step Recon Types",
    "calculatedData.mostCommonReconAcquisitionType" : "Most Common Step Recon",
    "calculatedData.avgMostCommonReconAcquisitionTypeTime" : "Avg. Common Step Recon Time",
    "calculatedData.avgCounterChokeholdTime" : "Avg. Counter Chokehold Time",
    "calculatedData.avgThreeChokeholdTime" : "Avg. Three Chokehold Time",
    "calculatedData.avgFourChokeholdTime" : "Avg. Four Chokehold Time",
    "calculatedData.avgCoopPoints" : "Avg. Coop Points",
    "uploadedData.numWheels" : "Number of Wheels",
    "uploadedData.numMotors" : "Number of Motors",
    "uploadedData.pitOrganization" : "Pit Organization",
    "uploadedData.drivetrain" : "Drivetrain",
    "uploadedData.typesWheels" : "Types Wheels",
    "uploadedData.programmingLanguage" : "Programming Language",
    "uploadedData.weight" : "Weight",
    "uploadedData.withholdingAllowanceUsed" : "Allowance Used",
    "uploadedData.canMountMechanism" : "Can Mount",
    "uploadedData.pitNotes" : "Pit Notes",
    "calculatedData.thirdPickAbility" : "Third Pick Ability",
    "calculatedData.thirdPickAbilityLandfill" : "Landfill Pick Ability",
    "calculatedData.avgNumVerticalReconsPickedUp" : "Avg. V. Recons Intaked",
    "calculatedData.avgNumHorizontalReconsPickedUp" : "Avg. H. Recons Intaked",
    "matchDatas" : "Matches",
    "calculatedData.avgNumTeleopReconsFromStep" : "Teleop Step Recons",
    "calculatedData.avgNumCappedSixStacks" : "Avg. Capped 6 Stacks",
    "uploadedData.mechRemove" : "Must Remove Mech",
    "calculatedData.avgNumTotesFromHP" : "Avg. HP Totes",
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
    for char in string {
        if "\(char)".uppercaseString == "\(char)" {
            toReturn.extend(", \(char)")
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
        if let int = "\(num)".toInt() {
            values.append(int)
        }
    }
    
    return values
}

@objc class Utils {
    class func `new`() -> Utils {
        return Utils()
    }
    
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