//
//  TodayViewController.swift
//  Current Match
//
//  Created by Carter Luck on 1/22/17.
//  Copyright © 2017 brytonmoeller. All rights reserved.
//

import UIKit
import NotificationCenter
import Firebase

class TodayViewController: UIViewController, NCWidgetProviding {
        
    @IBOutlet weak var r1: UILabel!
    @IBOutlet weak var r2: UILabel!
    @IBOutlet weak var r3: UILabel!
    
    @IBOutlet weak var b1: UILabel!
    @IBOutlet weak var b2: UILabel!
    @IBOutlet weak var b3: UILabel!
    
    @IBOutlet weak var MatchNum: UILabel!
    var firebase : FIRDatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if (FIRApp.allApps()?.keys.count)! < 2 {
            print(FIRApp.allApps()?.keys.count)
            FIRApp.configure()
            FIRDatabase.database().persistenceEnabled = true
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        firebase = FIRDatabase.database().reference()
        self.preferredContentSize = CGSize(width: 320, height: 90);
        self.firebase.child("currentMatchNum").observe(.value, with: { (snap) -> Void in
            self.refreshMatchNum()
        })
    }
    
    func refreshMatchNum() {
        self.firebase.observeSingleEvent(of: .value, with: { (snap) -> Void in
            if let currentMatchNum = snap.childSnapshot(forPath: "currentMatchNum").value as? Int {
                if let match = snap.childSnapshot(forPath: "Matches").childSnapshot(forPath: String(currentMatchNum)).value as? NSDictionary {
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
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        completionHandler(NCUpdateResult.newData)
    }
    
    func updateCurrentMatch(_ matchNum: Int, redTeams: [Int], blueTeams: [Int]) {
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
