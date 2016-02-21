//
//  TeamInMatchData.swift
//  scout-viewer-2015-iOS
//
//  Created by Samuel Resendez on 1/24/16.
//  Copyright © 2016 Citrus Circuits. All rights reserved.
//

import UIKit

@objc class TeamInMatchData: NSObject, Reflectable{
    
    var identifier = String?()
    
    var ballsIntakedAuto = [NSNumber]()
    var didChallengeTele = NSNumber?()
    var didGetDisabled = NSNumber?()
    var didGetIncapacitated = NSNumber?()
    var didReachAuto = NSNumber?()
    var didScaleTele = NSNumber?()
    var matchNumber = NSNumber?()
    var numBallsKnockedOffMidlineAuto = NSNumber?()
    var numGroundIntakesTele = NSNumber?()
    var numHighShotsMadeAuto = NSNumber?()
    var numHighShotsMadeTele = NSNumber?()
    var numHighShotsMissedAuto = NSNumber?()
    var numHighShotsMissedTele = NSNumber?()
    var numLowShotsMadeAuto = NSNumber?()
    var numLowShotsMadeTele = NSNumber?()
    var numLowShotsMissedAuto = NSNumber?()
    var numLowShotsMissedTele = NSNumber?()
    var numShotsBlockedTele = NSNumber?()
    var rankBallControl = NSNumber?()
    var rankDefense = NSNumber?()
    var rankDefenseCrossingEffectiveness = [NSNumber]?()
    var rankEvasion = NSNumber?()
    var rankSpeed = NSNumber?()
    var rankTorque = NSNumber?()
    var teamNumber = NSNumber?()
    var timesDefensesCrossedAuto = [NSNumber]?()
    var timesCrossedDefensesTele = [NSNumber]?()
    var calculatedData = TeamInMatchCalculatedData?()

}
