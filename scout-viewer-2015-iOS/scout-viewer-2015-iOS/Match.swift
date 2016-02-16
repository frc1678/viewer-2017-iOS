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
    func propertys()->[String]
}

extension Reflectable
{
    func propertys()->[String]{
        var s = [String]()
        for c in Mirror(reflecting: self).children
        {
            if let name = c.label{
                s.append(name)
            }
        }
        return s
    }
}




class Match: NSObject, Reflectable {
    
    var number = -1
    
    var blueAllianceDidCapture = false
    var blueAllianceTeamNumbers = [Int]()
    var blueDefensePositions = [String]()
    var blueScore = -1
    var calculatedData = MatchCalculatedData()
    var redAllianceDidCapture = false
    var redAllianceTeamNumbers = [Int]()
    var redDefensePositions = [String]()
    var redScore = -1
    var matchName:String {
        return "Q" + String(number)
    }

}
