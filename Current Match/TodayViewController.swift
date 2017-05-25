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
    
    static var isAlreadyLaunchedOnce = false
    
    @IBOutlet weak var MatchNum: UILabel!
    var firebase : FIRDatabaseReference!
    
    //configure firebase
    override func viewDidLoad() {
        super.viewDidLoad()
        //check if firebase has been configured
        if !TodayViewController.isAlreadyLaunchedOnce {
            //print how many firebase instances are open
            print(FIRApp.allApps()?.keys.count)
            FIRApp.configure()
            TodayViewController.isAlreadyLaunchedOnce = true
            //FIRDatabase.database().persistenceEnabled = true
            print(FIRApp.allApps()?.keys.count)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        firebase = FIRDatabase.database().reference()
        //set the preferred size
        self.preferredContentSize = CGSize(width: 320, height: 90);
        //get the current match number, call refreshMatchNum
        self.firebase.child("currentMatchNum").observeSingleEvent(of: .value, with: { (snap) -> Void in
            self.refreshMatchNum()
        })
    }
    
    func refreshMatchNum() {
        self.firebase.observe(.value, with: { (snap) -> Void in
            //get currentMatchNum
            if let currentMatchNum = snap.childSnapshot(forPath: "currentMatchNum").value as? Int {
                //match is the match with the number currentMatchNum as a NSDictionary
                if let match = snap.childSnapshot(forPath: "Matches").childSnapshot(forPath: String(currentMatchNum)).value as? NSDictionary {
                    let redTeamNumbers = match["redAllianceTeamNumbers"] as? [Int]
                    let blueTeamNumbers = match["blueAllianceTeamNumbers"] as? [Int]
                    self.updateCurrentMatch(currentMatchNum, redTeams: redTeamNumbers, blueTeams: blueTeamNumbers)
                } else {
                    self.updateCurrentMatch(00, redTeams: [0000,0000,0000], blueTeams: [0000,0000,0000])
                }
            } else if let currentMatchNum = snap.childSnapshot(forPath: "currentMatchNumber").value as? Int {
                //inconsistancies in the firebase
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
    
    func updateCurrentMatch(_ matchNum: Int, redTeams: [Int]?, blueTeams: [Int]?) {
        print("Update")
        //setting labels
        self.MatchNum.text = "Q\(matchNum)"
        self.r1.text = String(redTeams?[0] ?? 0)
        self.r2.text = String(redTeams?[1] ?? 0)
        self.r3.text = String(redTeams?[2] ?? 0)
        self.b1.text = String(blueTeams?[0] ?? 0)
        self.b2.text = String(blueTeams?[1] ?? 0)
        self.b3.text = String(blueTeams?[2] ?? 0)
    }
    
}
