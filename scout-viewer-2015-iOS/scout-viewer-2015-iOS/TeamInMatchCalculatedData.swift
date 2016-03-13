//
//  TeamInMatchCalculatedData.swift
//  scout-viewer-2015-iOS
//
//  Created by Samuel Resendez on 2/13/16.
//  Copyright © 2016 Citrus Circuits. All rights reserved.
//

import UIKit




@objc class TeamInMatchCalculatedData: NSObject, Reflectable {
    var firstPickAbility : NSNumber?
    var numTimesSuccesfulCrossedDefensesAuto : NSDictionary?
    var numTimesSuccesfulCrossedDefensesTele : NSDictionary?
    var numTimesFailedCrossedDefensesAuto : NSDictionary?
    var numTimesFailedCrossedDefensesTele : NSDictionary?
    var crossingTimeForDefenseAuto : NSDictionary?
    var crossingTimeForDefenseTele : NSDictionary?
    var highShotsAttemptedTele : NSNumber?
    var highShotsAttemptedAuto : NSNumber?
    var lowShotsAttemptedTele : NSNumber?
    var autoAbility : NSNumber?
    var RScoreTorque : NSNumber?
    var RScoreEvasion : NSNumber?
    var RScoreSpeed : NSNumber?
    var siegeConsistency : NSNumber?
    var scalePercentage : NSNumber?
    var highShotAccuracyAuto : NSNumber?
    var lowShotAccuracyAuto : NSNumber?
    var highShotAccuracyTele : NSNumber?
    var teleopShotAbility : NSNumber?
    var lowShotAccuracyTele : NSNumber?
    var siegeAbility : NSNumber?
    var numRPs : NSNumber?
    var numAutoPoints : NSNumber?
    var numScaleAndChallengePoints : NSNumber?
    var RScoreDefense : NSNumber?
    var RScoreBallControl : NSNumber?
    var RScoreDrivingAbility : NSNumber?
    var drivingAbility : NSNumber?
    var citrusDPR : NSNumber?
    var overallSecondPickAbility : NSNumber?
    var scoreContribution : NSNumber?
    var avgGroundIntakes : NSNumber?
    var numBallsIntakedOffMidlineAuto : NSNumber?
    var avgTorque : NSNumber?
    var avgEvasion : NSNumber?
    var avgBallControl : NSNumber?
    var avgDefense : NSNumber?
    var predictedNumRPs : NSNumber?
}



