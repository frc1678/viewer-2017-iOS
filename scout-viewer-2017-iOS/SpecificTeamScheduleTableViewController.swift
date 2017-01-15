//
//  SpecificTeamScheduleTableViewController.swift
//  scout-viewer-2016-iOS
//
//  Created by Bryton Moeller on 7/4/16.
//  Copyright © 2016 Citrus Circuits. All rights reserved.
//

import UIKit

class SpecificTeamScheduleTableViewController : ScheduleTableViewController {
    
    var teamNumber : Int = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "\(self.teamNumber)'s Matches"
    }
    
    override func loadDataArray(_ shouldForce: Bool) -> [Any]! {
        return self.firebaseFetcher.getMatchesForTeamWithNumber(self.teamNumber)
    }
}
