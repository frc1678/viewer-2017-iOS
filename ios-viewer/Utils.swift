//
//  Utils.swift
//  scout-viewer-2016-iOS
//
//  Created by Citrus Circuits on 2/19/15.
//  Copyright (c) 2016 Citrus Circuits. All rights reserved.
//

import Foundation


/** Rounds a value. */
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

/** Converts a float value into a percentage. */
func percentageValueOf(_ number: AnyObject?) -> String {
    if let n = number as? Float {
        return "\(roundValue(NSNumber(value: n * 100), toDecimalPlaces: 1))%"
    }
    
    return ""
}

//Self explanitory
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

/** Turns an NSNumArray into an Int Array */
func nsNumArrayToIntArray(_ nsNumberArray: [NSNumber]) -> [Int] {
    var values: [Int] = []
    for num in nsNumberArray {
        if let int = Int("\(num)") {
            values.append(int)
        }
    }
    
    return values
}

/** A class filled with undoubtably underwhelmingly useful utilities. */
@objc class Utils: NSObject {
    static let teamDetailsKeys = TeamDetailsKeys()
    struct TeamDetailsKeys {
        
        let yesNoKeys : [String] = []
        
        let abilityKeys = [
            "calculatedData.firstPickAbility",
            "calculatedData.overallSecondPickAbility",
            "calculatedData.autoAbility",
            "calculatedData.citrusDPR",
            "calculatedData.avgGroundIntakes",
            "calculatedData.avgTorque",
            "calculatedData.avgEvasion",
            "calculatedData.avgSpeed",
            "calculatedData.avgBallControl",
            "calculatedData.avgDefense",
            "calculatedData.actualNumRPs",
            "calculatedData.predictedNumRPs"
        ]
        
        // Add carrying stability into stacking security
        
        /* let superKeys = [
        "calculatedData.avgEvasion",
        "calculatedData.avgDefense"
        ]
        */
        
        /** Values that should not be graphed */
        let notGraphingValues = [
            "First Pick Ability",
            "Second Pick Ability",
            "R Score Driving Ability",
            // "Avg. Key Shooting Time",
            "Liftoff Ability",
            
        ]
        
        let TIMDLongTextCells : [String] = [
        "superNotes"
        ]
        
        let unrankedCells = [
            "selectedImageURL",
            "otherUrls"
        ]
        
        /** Values to be displayed as percentages. */
        let percentageValues = [
            "calculatedData.disabledPercentage",
            "calculatedData.disfunctionalPercentage",
            "calculatedData.incapacitatedPercentage",
            "calculatedData.liftoffPercentage"
        ]
        
        let otherNoCalcDataValues = [
            "calculatedData.avgLowShotsTele",
            "calculatedData.avgHighShotsTele"
        ]
        
        let addCommasBetweenCapitals : [String] = []
        
        let boolValues = [
            "calculatedData.disabledPercentage",
            "calculatedData.incapacitatedPercentage",
           "pitDidDemonstrateCheesecakePotential"
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
        // MARK: KeySets, TeamDetails keys.
        func keySetNames(_ minimalist : Bool) -> [String] {
            if minimalist {
                return  [
                    "",
                    //"High Level",
                    "Autonomous",
                    "Teleoperated",
                    "Siege",
                    "Status",
                    //superKeys,
                    //pitKeys,
                ]
            }
            return [
                "",
                //"High Level",
                "Status",
                "Autonomous",
                "Teleoperated",
                "End Game",
                "Super Scout",
                "Pit Scout",
            ]
            
        }
        
        //Keys for team details
        func keySets(_ minimalist : Bool) -> [[String]] {
            if minimalist {
                return [
                    defaultKeys,
                    //highLevel,
                    autoKeysMini,
                    teleKeysMini,
                    siegeKeysMini,
                    statusKeysMini,
                    //superKeys,
                    //pitKeys,
                ]
            }
            return [
                defaultKeys,
                //highLevel,
                statusKeys,
                autoKeys,
                teleKeys,
                endGame,
                superKeys,
                pitKeys,
            ]
            
        }
        
        let defaultKeys = [
            "TeamInMatchDatas",
            "matchDatas"
        ]
        
        let highLevel : [String] = [ //not needed
            /*"calculatedData.firstPickAbility",
            "calculatedData.overallSecondPickAbility",
            "calculatedData.avgKeyShotTime",
            "calculatedData.avgHopperShotTime"*/
        ]
        
        let autoKeysMini = [
            //TODO: Add Avg. Num Shots in 2 ball Auto
            "calculatedData.avgHighShotsAuto",
            //"calculatedData.avgLowShotsAuto"
        ]
        
        let autoKeys = [
            //Some stuff is not needed
            
            "calculatedData.avgHighShotsAuto",
            //"calculatedData.avgLowShotsAuto",
            //"calculatedData.avgHoppersOpenedAuto",
            "calculatedData.avgGearsPlacedAuto",
            "calculatedData.avgGearsPlacedByLiftAuto.allianceWall",
            "calculatedData.avgGearsPlacedByLiftAuto.hpStation",
            "calculatedData.avgGearsPlacedByLiftAuto.boiler",

            //"calculatedData.sdGearsPlacedAuto",
            //"calculatedData.sdLowShotsAuto",
            //"calculatedData.sdHighShotsAuto"
        ]
        
        let teleKeysMini : [String] = [
            //"calculatedData.avgHighShotsTele",
            //"calculatedData.sdHighShotsTele",
            //"calculatedData.avgLowShotsTele",
            //"calculatedData.sdLowShotsTele",
            //"calculatedData.avgLowShotsAttemptedTele",
            //"calculatedData.avgHighShotsAttemptedTele",
        ]
        
        let teleKeys = [
            //"calculatedData.avgHighShotsTele",
            //"calculatedData.sdHighShotsTele",
            //"calculatedData.avgLowShotsTele",
            //"calculatedData.sdLowShotsTele",
            //"calculatedData.avgHoppersOpenedTele",
            "calculatedData.avgGearGroundIntakesTele",
            //"calculatedData.avgLoaderIntakesTele",
            "calculatedData.avgGearsFumbledTele",
            "calculatedData.avgGearsEjectedTele",
            //"calculatedData.sdGearsPlacedTele",
            "calculatedData.avgGearsPlacedTele",
        ]
        
        let teamDetailsToTIMD = [
            //status
            "incapacitatedPercentage" : "didBecomeIncapacitated",
            "disabledPercentage" : "didStartDisabled",
            "disfunctionalPercentage" : "calculatedData.wasDisfunctional",
            //scoring stuff
            "liftoffPercentage" : "didLiftoff",
            "avgHighShotsTele" : "calculatedData.numHighShotsTele",
            "avgLowShotsAuto" : "calculatedData.numLowShotsAuto",
            "avgHighShotsAuto" : "calculatedData.numHighShotsAuto",
            "avgLowShotsTele" : "calculatedData.numLowShotsTele",
            "teleopShotAbility" : "calculatedData.teleopShotAbility",
            "avgGearsPlacedByLiftAuto.allianceWall" : "gearsPlacedByLiftAuto.allianceWall",
            "avgGearsPlacedByLiftAuto.hpStation" : "gearsPlacedByLiftAuto.hpStation",
            "avgGearsPlacedByLiftAuto.boiler" : "gearsPlacedByLiftAuto.boiler",
            "lowShotAccuracyTele" : "calculatedData.lowShotAccuracyTele",
            "highShotAccuracyTele" : "calculatedData.highShotAccuracyTele",
            "lowShotAccuracyAuto" : "calculatedData.lowShotAccuracyAuto",
            "highShotAccuracyAuto" : "calculatedData.highShotAccuracyAuto",
            "avgGearsPlacedAuto" : "calculatedData.numGearsPlacedAuto",
            "avgGearsPlacedTele" : "calculatedData.numGearsPlacedTele",
            //super data
            "avgSpeed" : "rankSpeed",
            "avgAgility" : "rankAgility",
            "avgTorque" : "rankTorque",
            "avgBallControl" : "rankBallControl",
            "avgDrivingAbility" : "calculatedData.drivingAbility",
            "avgDefense" : "rankDefense",
            "avgGearControl" : "rankGearControl",
            //RScore super data
            "RScoreDrivingAbility" : "calculatedData.drivingAbility",
            "RScoreBallControl" : "rankBallControl",
            "RScoreAgility" : "rankAgility",
            "RScoreDefense" : "rankDefense",
            "RScoreSpeed" : "rankSpeed",
            "RScoreTorque" : "rankTorque",
            //Misc
            "avgGearGroundIntakesTele" : "numGearGroundIntakesTele",
            "actualNumRPs" : "calculatedData.numRPs",
            "numAutoPoints" : "calculatedData.numAutoPoints",
            "baselineReachedPercentage" : "didReachBaselineAuto",
            "avgHoppersOpenedTele" : "numHoppersOpenedTele",
            "avgHoppersOpenedAuto" : "numHoppersOpenedAuto",
            "avgGearsFumbledTele" : "numGearsFumbledTele",
            "avgGearsEjectedTele" : "numGearsEjectedTele",
            "avgKeyShotTime" : "calculatedData.avgKeyShotTime",
            "avgHopperShotTime" : "calculatedData.avgHopperShotTime",

        ]
        
        let endGame = [
            "calculatedData.liftoffPercentage",
            //"calculatedData.liftoffAbility"
        ]
        
        let siegeKeysMini : [String] = [
            //"calculatedData.liftoffAbility",
            //"calculatedData.sdLiftoffAbility"
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
        
        let pitKeys = [
            "pitDriveTrain",
            "pitDidDemonstrateCheesecakePotential",
            "pitAvailableWeight",
            //"pitOrganization",
            "pitProgrammingLanguage"
        ]
        
        let calculatedTeamInMatchDataHumanReadableKeys = [
            "First Pick Ability",
            "R Score Torque",
            "R Score Evasion",
            "R Score Speed",
            "Avg. High Shots in Tele",
            "Number of RPs",
            "Number of Auto Points",
            "R Score Defense",
            "R Score Ball Control",
            "R Score Driving Ability",
            "Citrus DPR",
            "Second Pick Ability",
            "Overall Second Pick Ability",
            "Score Contribution"
        ]
    }
    
    
    static let superKeys = [
        //superNotes- They're in TIMDs, so see TeamDetails for more info
        "superNotes",
        "calculatedData.RScoreDefense",
        "calculatedData.RScoreAgility",
        "calculatedData.RScoreSpeed",
        //"calculatedData.avgBallControl",
        //"calculatedData.avgGearControl",
        "calculatedData.RScoreDrivingAbility"
    ]
    static let statusKeys = ["uploadedData.incapacitated", "uploadedData.disabled"]
    static let miscKeys = ["uploadedData.miscellaneousNotes"]
    
    
    
    // MARK: TIMD keys
    static let TIMDAutoKeys : [String] = [
        "calculatedData.numLowShotsAuto",
        "numHoppersOpenedAuto",
        "calculatedData.numGearsPlacedAuto",
        "calculatedData.numHighShotsAuto",
    ]
    
    static let TIMDTeleKeys : [String] = [
        "calculatedData.numLowShotsTele",
        "numGearLoaderIntakesTele",
        "calculatedData.numHighShotsTele",
        "numGearGroundIntakesTele",
        "numHoppersOpenedTele",
        "calculatedData.numGearsPlacedTele",
        "didLiftoff"
    ]
    
    static let TIMDStatusKeys = [
        "didStartDisabled",
        "didBecomeIncapacitated"
    ]
    
    static let TIMDSuperKeys = [
        "rankBallControl",
        "rankDefense",
        "rankAgility",
        "rankSpeed",
        "rankGearControl",
        "drivingAbility",
        //"superNotes"
    ]
    
    static let TIMDKeys = [
        TIMDAutoKeys,
        TIMDTeleKeys,
        TIMDStatusKeys,
        TIMDSuperKeys
    ]
    
    static let graphTitleSwitch = [

        "didBecomeIncapacitated" : "incapacitatedPercentage",
        "didStartDisabled" : "disabledPercentage",
        "numShotsBlockedTele" : "avgShotsBlocked",
        "didReachBaselineAuto" : "baselineReachedPercentage",
        "didLiftoff" : "liftoffPercentage",
        "calculatedData.liftoffAbility" : "liftoffAbility",
        "numLowShotsTele" : "avgLowShotsTele",
        "calculatedData.numHighShotsTele" : "avgHighShotsTele",
        "calculatedData.RScoreSpeed" : "calculatedData.avgSpeed",
        "calculatedData.RScoreEvasion" : "calculatedData.avgEvasion",
        "calculatedData.RScoreTorque" : "calculatedData.avgTorque",
        "rankBallControl" : "calculatedData.avgBallControl",
    ]
    
    static let teamCalcKeys = [
        "actualSeed",
        "avgBallControl",
        "avgDefense",
        "avgEvasion",
        "avgGroundIntakes",
        "avgHighShotsAuto",
        "avgHighShotsTele",
        "avgLowShotsAuto",
        "avgLowShotsTele",
        "avgSpeed",
        "avgTorque",
        "disabledPercentage",
        "disfunctionalPercentage",
        "firstPickAbility",
        "incapacitatedPercentage",
        "actualNumRPs",
        "predictedNumRPs",
        "predictedSeed",
        "scalePercentage",
        "sdGroundIntakes",
        "sdHighShotsAuto",
        "sdHighShotsTele",
        "sdLowShotsAuto",
        "sdLowShotsTele",
        "overallSecondPickAbility",
        "secondPickAbility",
        "avgGearsFumbledTele",
        "avgGearsEjectedTele",
        "avgGearGroundInakesTele",
        "avgLoaderIntakesTele",
        "avgHoppersOpenedTele",
        "avgHoppersOpenedAuto"
    ]
    
    static let calculatedTeamInMatchDataKeys = [
        "calculatedData.firstPickAbility",
        "calculatedData.numRPs",
        "calculatedData.secondPickAbility",
        "calculatedData.overallSecondPickAbility",
        "calculatedData.scoreContribution",
        "calculatedData.hoppersOpenedAuto",
        "calculatedData.hoppersOpenedTele",
        "calculatedData.liftoffAbility",
        "calculatedData.numLowShotsAuto",
        "calculatedData.numHighShotsTele",
        "calculatedData.numLowShotsTele",
        "calculatedData.numHighShotsAuto"
    ]
    
    /** A dictionary with datapoints as keys and Human Readable Names as indices */
    static let humanReadableNames = [
        "superNotes": "Super Scout Notes",
        "calculatedData.avgGearsPlacedByLiftAuto.allianceWall": "Avg. Center Gears",
        "calculatedData.avgGearsPlacedByLiftAuto.hpStation": "Avg. HP Side Gears",
        "calculatedData.avgGearsPlacedByLiftAuto.boiler": "Avg. Boiler Side Gears",
        "calculatedData.actualSeed" : "Seed",
        "calculatedData.avgEvasion" : "Avg. Evasion",
        "calculatedData.avgGroundIntakes" : "Avg. Ground Intakes",
        "calculatedData.avgHighShotsAuto" : "Avg. High Shots Auto",
        "calculatedData.avgHighShotsTele" : "Avg. High Shots Tele",
        "calculatedData.avgLowShotsAuto" : "Avg. Low Shots Auto",
        "calculatedData.avgLowShotsTele" : "Avg. Low Shots Tele",
        "calculatedData.avgShotsBlocked" : "Avg. Shots Blocked",
        "calculatedData.avgTorque" : "Avg. Torque",
        "calculatedData.disabledPercentage" : "Disabled Percentage",
        "calculatedData.disfunctionalPercentage" : "Dysfunctional Percentage",
        "calculatedData.driverAbility" : "Driver Ability",
        "calculatedData.firstPickAbility" : "First Pick Ability",
        "calculatedData.incapacitatedPercentage" : "Incapacitated Percentage",
        "calculatedData.numRPs" : "Number of RPs",
        "calculatedData.actualNumRPs": "# of RPs",
        "calculatedData.predictedNumRPs" : "Predicted # of RPs",
        "calculatedData.predictedSeed" : "Predicted Seed",
        "calculatedData.scalePercentage" : "Scale Percentage",
        "calculatedData.avgHighShotsAttemptedTele": "Avg. H Shots Tried",
        //"calculatedData.sdBallsKnockedOffMidlineAuto" : "σ Balls off Midline Auto",
        //"calculatedData.sdFailedDefenseCrossesAuto" : "σ Failed Defenses Auto",
        "calculatedData.baselineReachedPercentage" : "Baseline Percentage",
        "calculatedData.sdGroundIntakes" : "σ Ground Intakes",
        "calculatedData.sdHighShotsAuto" : "σ High Shots",
        "calculatedData.sdHighShotsTele" : "σ High Shots",
        "calculatedData.sdLowShotsAuto" : "σ Low Shots",
        "calculatedData.sdLowShotsTele" : "σ Low Shots",
        "calculatedData.sdShotsBlocked" : "σ Shots Blocked",
        "calculatedData.overallSecondPickAbility" : "Second Pick Ability",
        "matchDatas" : "Matches",
        "TeamInMatchDatas" : "TIMDs",
        "pitLowBarCapability": "Low Bar Ability",
        "calculatedData.autoAbility" : "Auto Ability",
        "calculatedData.citrusDPR" : "Citrus DPR",
        "calculatedData.RScoreDrivingAbility": "R Score Driving Ability",
        "calculatedData.drivingAbility": "Driving Ability",
        "pitPotentialLowBarCapability" : "Low Bar Potential",
        "pitHeightOfBallLeavingShooter": "Shot Release Height",
        "pitDriveBaseWidth" : "Drive Base Width",
        "pitDriveBaseLength" : "Drive Base Length",
        "pitBumperHeight" : "Bumper Height",
        "pitPotentialShotBlockerCapability" : "Shot Blocking Potential",
        "pitNotes" : "Pit Notes",
        "pitCheesecakeAbility" : "Cheesecake Ease",
        "pitProgrammingLanguage": "Prog. Lang.",
        "pitAvailableWeight" : "Avail. Weight",
        "pitOrganization" : "Pit Organization",
        "pitDidUseStandardTankDrive" : "Has Normal Tank Drivetrain",
        "pitDidDemonstrateCheesecakePotential": "Can Accommodate Cheesecake",
        "rankBallControl" : "Ball Control Rank",
        "rankDefense" : "Defense Rank",
        "rankAgility" : "Agility Rank",
        "rankSpeed" : "Speed Rank",
        "rankTorque" : "Torque Rank",
        "didScaleTele" : "Did Scale",
        "didBecomeIncapacitated" : "Was Incap.",
        "didStartDisabled" : "Was Disabled",
        "numShotsBlockedTele" : "Num Shots Blocked",
        "calculatedData.numLowShotsTele" : "Num Low Shots Made Tele",
        "calculatedData.numHighShotsTele" : "Num High Shots Made Tele",
        "calculatedData.RScoreSpeed" : "R Score Speed",
        "calculatedData.RScoreEvasion" : "R Score Evasion",
        "calculatedData.RScoreTorque" : "R Score Torque",
        "calculatedData.RScoreAgility": "R Score Agility",
        "calculatedData.RScoreDefense": "R Score Defense",
        "calculatedData.RScoreBallControl": "R Score Ball Control",
        "calculatedData.RScoreGearControl": "R Score Gear Control",
        "calculatedData.avgAgility": "Avg. Agility",
        "calculatedData.avgDefense": "Avg. Defense",
        "calculatedData.avgSpeed": "Avg. Speed",
        "calculatedData.avgBallControl": "Avg. Ball Control",
        "calculatedData.avgGearControl": "Avg. Gear Control",
        "calculatedData.avgDrivingAbility": "Avg. Driving Ability",
        "calculatedData.avgLowShotsAttemptedTele": "Avg. L Shots Tried",
        "pitNumberOfWheels": "Number of Wheels",
        "calculatedData.liftoffPercentage": "Liftoff Percentage",
        "calculatedData.liftoffAbility": "Liftoff Ability",
        "calculatedData.avgKeyShotTime": "Avg. Key Shooting Time",
        "lowShotTimesForBoilerTele" : "Low Shots Made Tele",
        "numGearLoaderIntakesTele" : "Gears Intaked From Loader Tele",
        "highShotTimesForBoilerTele" : "High Shots Made Tele",
        "numGearGroundIntakesTele" : "Gears Intaked From Ground Tele",
        "hoppersOpenedTele" : "Num Hoppers Opened Tele",
        "gearsPlacedByLiftTele" : "Gears Placed Tele",
        "didLiftoff" : "Did Liftoff",
        "highShotTimesForBoilerAuto" : "High Shots Made Auto",
        "hoppersOpenedAuto" : "Num Hoppers Opened Auto",
        "gearsPlacedByLiftAuto" : "Gears Placed Tele",
        "didReachBaselineAuto" : "Reached Baseline in Auto",
        "lowShotTimesForBoilerAuto" : "Low Shots Made Auto",
        "didPotentiallyConflictingAuto" : "Did a Potentially Conflicting Auto",
        "calculatedData.avgHoppersOpenedTele" : "Avg. Hoppers Opened Tele",
        "calculatedData.avgHoppersOpenedAuto" : "Avg. Hoppers Opened Auto",
        "calculatedData.avgGearGroundIntakesTele" : "Avg. Gears Ground Intaked Tele",
        "calculatedData.avgGearGroundIntakesAuto" : "Avg. Gears Ground Intaked Auto",
        "calculatedData.avgGearsFumbledTele" : "Avg. Gears Fumbled Tele",
        "calculatedData.avgGearsFumbledAuto" : "Avg. Gears Fumbled Auto",
        "calculatedData.avgGearsEjectedTele" : "Avg. Gears Ejected Tele",
        "calculatedData.avgGearsEjectedAuto" : "Avg. Gears Ejected Auto",
        "calculatedData.avgLoaderIntakesTele" : "Avg. Loader Intakes Tele",
        "calculatedData.avgLoaderIntakesAuto" : "Avg. Loader Intakes Auto",
        "calculatedData.sdGearsPlacedByLiftTele" : "σ Gears Placed Tele",
        "calculatedData.sdGearsPlacedByLiftAuto" : "σ Gears Placed Auto",
        "calculatedData.avgGearsPlacedByLiftAuto" : "Avg. Gears Placed Auto",
        "numHoppersOpenedAuto" : "Num Hoppers Opened Auto",
        "numHoppersOpenedTele" : "Num Hoppers Opened Tele",
        "gearsPlacedByLiftAuto.lift1" : "Gears Placed Auto (Lift 1)",
        "gearsPlacedByLiftAuto.lift2" : "Gears Placed Auto (Lift 2)",
        "gearsPlacedByLiftAuto.lift3" : "Gears Placed Auto (Lift 3)",
        "gearsPlacedByLiftTele.lift1" : "Gears Placed Tele (Lift 1)",
        "gearsPlacedByLiftTele.lift2" : "Gears Placed Tele (Lift 2)",
        "gearsPlacedByLiftTele.lift3" : "Gears Placed Tele (Lift 3)",
        "lowShotTimesForBoilerTele.numShots" : "Low Shots Made Tele",
        "lowShotTimesForBoilerAuto.numShots" : "Low Shots Made Auto",
        "highShotTimesForBoilerTele.numShots" : "High Shots Made Tele",
        "highShotTimesForBoilerAuto.numShots" : "High Shots Made Auto",
        "calculatedData.numLowShotsAuto" : "Low Shots Made Auto",
        "calculatedData.numGearsPlacedAuto" : "Num Gears Scored Auto",
        "calculatedData.numHighShotsAuto" : "High Shots Made Auto",
        "calculatedData.numGearsPlacedTele" : "Num Gears Scored Tele",
        "rankGearControl" : "Gear Control Rank",
        "calculatedData.avgGearsPlacedAuto" : "Avg. Total Gears Placed Auto",
        "calculatedData.sdGearsPlacedAuto" : "σ Gears Placed Auto",
        "calculatedData.avgGearsPlacedTele" : "Avg. Gears Placed Tele",
        "calculatedData.sdGearsPlacedTele" : "σ Gears Placed Tele",
        "calculatedData.avgHopperShotTime" : "Avg. Hopper Shooting Time",
        "pitDriveTrain" : "Drive Train"
    ]
    
    /** Rounds a given float value to a given number of decimal places. */
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
    
    /** Rounds a given double value to a given number of decimal places. */
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
    
    /** Returns a human readable name for a given key. */
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
    
    /** Returns a key for a given Human Readable Name. */
    class func getKeyForHumanReadableName(_ name: String) -> String? {
        var computerReadableNames = [String: String]()
        for (key, value) in humanReadableNames {
            computerReadableNames[value] = key
        }
        return computerReadableNames[name]
    }
    
    /** Detects if a given value is null. */
    class func isNull(_ object: AnyObject?) -> Bool {
        if object_getClass(object) == object_getClass(NSNull()) {
            return true
        }
        return false
    }
    
    /** Converts a value to one that is presentable as a string on the screen. It won't have Optional() or anything like that in it. */
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
    
    /**Conversion of bool value to string "Yes" or "No".*/
    class func boolToString(b: Bool?) -> String? {
        let stringBool : String? = b?.description ?? nil
        let boolToStringValues = [
            "true" : "Yes",
            "false" : "No"
        ]
        if stringBool != nil {
            let stringReadable = boolToStringValues[stringBool!]
            return (stringReadable)
        }
        return(nil)
    }
    
    /**
     Unwraps a value.
    */
    class func unwrap(any:Any) -> Any {
        
        let mi = Mirror(reflecting: any)
        if mi.displayStyle != .optional {
            return any
        }
        
        if mi.children.count == 0 { return NSNull() }
        let (_, some) = mi.children.first!
        return some
        
    }
    
    class func humanReadableNameFromKey(key: String) -> String {
        let noCalculatedDataKey = key.replacingOccurrences(of: "calculatedData.", with: "").replacingOccurrences(of: "pit", with: "pitScout")
        var indiciesToAddSpaces = [Int]()
        for i in 0..<noCalculatedDataKey.characters.count {
            if i != 0 {
                let currentChar = Array(noCalculatedDataKey.characters)[i]
                let previousChar = Array(noCalculatedDataKey.characters)[i-1]
                if !self.isLowercase(string: String(currentChar)) && self.isLowercase(string: String(previousChar)) {
                    indiciesToAddSpaces.append(i)
                }
            }
        }
        var finalName = noCalculatedDataKey
        indiciesToAddSpaces.sort()
        for i in 0..<indiciesToAddSpaces.count {
            let ind = indiciesToAddSpaces[i] + i //Adding i to ajust for the fact that we are adding characters as we go here
            finalName = finalName.insert(string: " ", ind: ind)
        }
        finalName = String(Array(finalName.characters)[0]).uppercased() + String(finalName.characters.dropFirst())
        return finalName
    }
    
    static func isLowercase(string: String) -> Bool {
        let set = CharacterSet.lowercaseLetters
        
        if let scala = UnicodeScalar(string) {
            return set.contains(scala)
        } else {
            return false
        }
    }
}

extension String {
    func insert(string:String,ind:Int) -> String {
        return  String(self.characters.prefix(ind)) + string + String(self.characters.suffix(self.characters.count-ind))
    }
}


