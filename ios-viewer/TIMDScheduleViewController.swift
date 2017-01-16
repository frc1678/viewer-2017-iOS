//
//  TIMDScheduleViewController.swift
//  ios-viewer
//
//  Created by Carter Luck on 1/16/17.
//  Copyright © 2017 brytonmoeller. All rights reserved.
//

import Foundation

class TIMDScheduleViewController: ScheduleTableViewController {
    var teamNumber : Int = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "\(self.teamNumber)'s Matches"
    }
    
    override func loadDataArray(_ shouldForce: Bool) -> [Any]! {
        return self.firebaseFetcher.getMatchesForTeamWithNumber(self.teamNumber)
    }
}
