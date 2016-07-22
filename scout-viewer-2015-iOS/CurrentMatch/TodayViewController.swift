//
//  TodayViewController.swift
//  CurrentMatchWidget
//
//  Created by Bryton Moeller on 4/17/16.
//  Copyright © 2016 Citrus Circuits. All rights reserved.
//

import UIKit
import NotificationCenter
import Firebase
//import Haneke

class TodayViewController: UIViewController, NCWidgetProviding {
    
    @IBOutlet weak var b3: UILabel!
    @IBOutlet weak var b2: UILabel!
    @IBOutlet weak var r1: UILabel!
    
    @IBOutlet weak var b1: UILabel!
    @IBOutlet weak var r3: UILabel!
    @IBOutlet weak var r2: UILabel!
    @IBOutlet weak var MatchNum: UILabel!
    var firebase = FIRDatabase.database().reference()
    //let cache = Shared.dataCache
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.preferredContentSize = CGSizeMake(320, 90);
        self.firebase.child("currentMatchNum").observeEventType(.Value, withBlock: { (snap) -> Void in
            self.refreshMatchNum()
        })
    }
    
    func refreshMatchNum() {
        self.firebase.observeSingleEventOfType(.Value, withBlock: { (snap) -> Void in
            if let currentMatchNum = snap.childSnapshotForPath("currentMatchNum").value as? Int {
                if let match = snap.childSnapshotForPath("Matches").childSnapshotForPath(String(currentMatchNum)).value as? NSDictionary {
                    let redTeamNumbers = match["redAllianceTeamNumbers"] as! [Int]
                    let blueTeamNumbers = match["blueAllianceTeamNumbers"] as! [Int]
                    self.updateCurrentMatch(currentMatchNum, redTeams: redTeamNumbers, blueTeams: blueTeamNumbers)
                } else {
                    self.updateCurrentMatch(00, redTeams: [0000,0000,0000], blueTeams: [0000,0000,0000])
                }
            } else {
                self.updateCurrentMatch(00, redTeams: [0000,0000,0000], blueTeams: [0000,0000,0000])
            }
        })
    }
    
    func widgetPerformUpdateWithCompletionHandler(completionHandler: ((NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        completionHandler(NCUpdateResult.NewData)
    }
    
    func updateCurrentMatch(matchNum: Int, redTeams: [Int], blueTeams: [Int]) {
        print("Update")
        self.MatchNum.text = "Q\(matchNum)"
        self.r1.text = String(redTeams[0])
        self.r2.text = String(redTeams[1])
        self.r3.text = String(redTeams[2])
        self.b1.text = String(blueTeams[0])
        self.b2.text = String(blueTeams[1])
        self.b3.text = String(blueTeams[2])
    }
    
}
