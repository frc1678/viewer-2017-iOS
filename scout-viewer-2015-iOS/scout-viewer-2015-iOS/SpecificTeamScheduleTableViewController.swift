//
//  SpecificTeamScheduleTableViewController.swift
//  scout-viewer-2015-iOS
//
//  Created by Bryton Moeller on 7/4/16.
//  Copyright © 2016 Citrus Circuits. All rights reserved.
//

import UIKit

class SpecificTeamScheduleTableViewController : ScheduleTableViewController {
    
    var teamNumber : Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "\(self.teamNumber)'s Matches"
    }
    
    override func loadDataArray(shouldForce: Bool) -> [AnyObject]! {
        return self.firebaseFetcher.getMatchesForTeamWithNumber(self.teamNumber)
    }
}