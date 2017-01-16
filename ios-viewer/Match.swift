//
//  Match.swift
//  scout-viewer-2016-iOS
//
//  Created by Samuel Resendez on 1/23/16.
//  Copyright © 2016 Citrus Circuits. All rights reserved.
//

import UIKit


class Match: NSObject, Reflectable {
    
    var matchNumber : NSNumber?
    
    var blueAllianceDidCapture : AnyObject?
    var blueAllianceTeamNumbers : [NSNumber]?
    var blueDefensePositions : [NSString]?
    var blueScore : NSNumber?
    var calculatedData : MatchCalculatedData?
    var number : NSNumber?
    var redAllianceDidCapture : AnyObject?
    var redAllianceTeamNumbers : [NSNumber]?
    var redDefensePositions : [NSString]?
    var redScore : NSNumber?
    var matchName : NSString? {
        return NSString(string: "Q\(self.matchNumber!)")
    }

}
