//
//  Match.swift
//  scout-viewer-2015-iOS
//
//  Created by Samuel Resendez on 1/23/16.
//  Copyright © 2016 Citrus Circuits. All rights reserved.
//

import UIKit

//The Dream, Never Forget

class Match: NSObject {
    
    var matchNumber = -1
    
    var blueAllianceDidCapture = false
    var blueAllianceTeamNumbers = [Int]()
    var blueDefensePositions = [String]()
    var blueScore = -1
    var calculatedData = MatchCalculatedData()
    var number = -1
    var redAllianceDidCapture = false
    var redAllianceTeamNumbers = [Int]()
    var redDefensePositions = [String]()
    var redScore = -1
    var matchName:String {
        return "Q" + String(matchNumber)
    }

}
