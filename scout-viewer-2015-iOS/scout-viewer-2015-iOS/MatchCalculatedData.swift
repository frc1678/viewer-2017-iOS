//
//  MatchCalculatedData.swift
//  scout-viewer-2015-iOS
//
//  Created by Samuel Resendez on 1/23/16.
//  Copyright © 2016 Citrus Circuits. All rights reserved.
//

import UIKit

@objc class MatchCalculatedData: NSObject {
    
    var blueRPs: NSNumber?
    var numDefenseCrossesByBlue = NSNumber?()
    var numDefenseCrossesByRed = NSNumber?()
    var predictedBlueScore = NSNumber?()
    var predictedRedScore = NSNumber?()
    var redRPs = NSNumber?()
    var optimalBlueDefenses = [String]?()
    var optimalRedDefenses = [String]?()
    var blueWinChance = NSNumber?()
    var redWinChance = NSNumber?()

}
