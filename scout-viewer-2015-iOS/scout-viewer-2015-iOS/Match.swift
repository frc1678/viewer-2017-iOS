//
//  Match.swift
//  scout-viewer-2015-iOS
//
//  Created by Samuel Resendez on 1/23/16.
//  Copyright © 2016 Citrus Circuits. All rights reserved.
//

import UIKit

//The Dream, Never Forget
protocol Reflectable {
    func propertys() -> [String] // spelling?
}

extension Reflectable
{
    func propertys() -> [String] {
        var s = [String]()
        for c in Mirror(reflecting: self).children
        {
            if let name = c.label {
                s.append(name)
            }
        }
        return s
    }
    func propertyForKey(path:String) -> AnyObject? {
        for c in Mirror(reflecting: self).children
        {
            if c.label == path {
                //print(c.label)
               // print(c.value)
                return c.value as? AnyObject
            }
        }
        return nil
    }
}
@objc class Match: NSObject, Reflectable {
    
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
    var matchName : NSString {
        return "Q" + String(matchNumber)
    }

}
