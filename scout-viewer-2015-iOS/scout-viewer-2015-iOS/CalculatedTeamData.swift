//
//  CalculatedTeamData.swift
//  scout-viewer-2015-iOS
//
//  Created by Samuel Resendez on 1/23/16.
//  Copyright © 2016 Citrus Circuits. All rights reserved.
//

import UIKit

class CalculatedTeamData: NSObject {
    
    
    
    //may not be in final implementation actualSeed = -1
    var actualSeed = -1
    var avgBallControl = -1
    var avgBallsKnockedOffMidlineAuto = -1
    var avgDefense = -1
    var avgEvasion = -1
    var avgFailedTimesCrossedDefensesAuto = NSDictionary()
    var avgFailedTimesCrossedDefensesTele = NSDictionary()
    var avgGroundIntakes = -1
    var avgHighShotsAuto = -1
    var avgHighShotsTele = -1
    var avgLowShotsAuto = -1
    var avgLowShotsTele = -1
    var avgMidlineBallsIntakedAuto = -1
    var avgShotsBlocked = -1
    var avgSpeed = -1
    var avgSuccessfulTimesCrossedDefensesAuto = NSDictionary()
    var avgSuccessfulTimesCrossedDefensesTele = NSDictionary()
    var avgTorque = -1
    var challengePercentage = -1
    var disabledPercentage = -1
    var disfunctionalPercentage = -1
    var driverAbility = -1
    var firstPickAbility = -2
    var highShotAccuracyAuto = -1
    var highShotAccuracyTele = -1
    var incapacitatedPercentage = -1
    var lowShotAccuracyAuto = -1
    var lowShotAccuracyTele = -1
    var numAutoPoints = -1
    var numRPs = -1
    var predictedNumRPs = -1
    var numScaleAndChallengePoints = -1
    var predictedSeed = -1
    var reachPercentage = -1
    var scalePercentage = -1
    var sdBallsKnockedOffMidlineAuto = -1
    var sdFailedDefenseCrossesAuto = NSDictionary()
    var sdFailedDefenseCrossesTele = NSDictionary()
    var sdGroundIntakes = -1
    var sdHighShotsAuto = -1
    var sdHighShotsTele = -1
    var sdLowShotsAuto = -1
    var sdLowShotsTele = -1
    var sdMidlineBallsIntakedAuto = -1
    var sdShotsBlocked = -1
    var sdSuccessfulDefenseCrossesAuto = NSDictionary()
    var sdSuccessfulDefenseCrossesTele = NSDictionary()
    var secondPickAbility = NSDictionary()
    var siegeAbility = -1
    var siegeConsistency = -1
    var siegePower = -1
    
    var avgCdfCrossed = -1
    var avgPcCrossed = -1
    var avgMtCrossed = -1
    var avgRpCrossed = -1
    var avgDbCrossed = -1
    var avgSpCrossed = -1
    var avgRtCrossed = -1
    var avgRwCrossed = -1
    var avgLbCrossed = -1
}
