//
//  Match.swift
//  scout-viewer-2015-iOS
//
//  Created by Samuel Resendez on 1/23/16.
//  Copyright © 2016 Citrus Circuits. All rights reserved.
//

import UIKit

//The Dream, Never Forget

@ objc class Match: NSObject {
    
    var matchNumber = NSNumber?()
    
    var blueAllianceDidCapture = Bool?()
    var blueAllianceTeamNumbers = [Int]?()
    var blueDefensePositions = [String]?()
    var blueScore = NSNumber?()
    var calculatedData = MatchCalculatedData?()
    var number = NSNumber?()
    var redAllianceDidCapture = Bool?()
    var redAllianceTeamNumbers = [Int]?()
    var redDefensePositions = [String]?()
    var redScore = NSNumber?()
    var matchName:String {
        return "Q" + String(matchNumber)
    }

}
