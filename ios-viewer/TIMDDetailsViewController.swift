//
//  TIMDDetailsViewController.swift
//  ios-viewer
//
//  Created by Carter Luck on 1/16/17.
//  Copyright © 2017 brytonmoeller. All rights reserved.
//

import Foundation
import UIKit
import MWPhotoBrowser
import SDWebImage
import Haneke


class TIMDDetailsViewController: UITableViewController {
    
    //ideally set when segued into from TIMDScheduleView
    var TIMD: TeamInMatchData!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let teamNum = TIMD.teamNumber as? Int!, let matchNum = TIMD.matchNumber as? Int! {
            //set title: "# - Q#"
            self.title = "\(TIMD.teamNumber!) - Q\(TIMD.matchNumber!)"
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        //return the number of keys in the TIMDs
        return Utils.TIMDKeys.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return the number of rows in TIMDKeys section
        return Utils.TIMDKeys[section].count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //get cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "TIMDTableViewCell", for: indexPath) as! TIMDTableViewCell
        
        if TIMD.teamNumber != nil && TIMD.matchNumber != nil {
            let key = Utils.TIMDKeys[indexPath.section][indexPath.row]
            if Utils.humanReadableNames.keys.contains(key) {
                //set label to the HumanReadable version of the key
                cell.datapointLabel.text = Utils.humanReadableNames[key]
            }
            
            var value: Any?
            if key.contains("calculatedData") {
                //go to calculatedData, dictionaryRepresentation, key without calculatedData
                value = ((TIMD.value(forKeyPath: "calculatedData") as! CalculatedTeamInMatchData).dictionaryRepresentation() as NSDictionary).object(forKey: key.replacingOccurrences(of: "calculatedData.", with: ""))
            } else {
                value = (TIMD.dictionaryRepresentation() as NSDictionary).object(forKey: key)
                print(key)
            }
            if value != nil {
                //set the value label
                if let stringValue = value as? String {
                    cell.valueLabel.text = stringValue
                } else if let boolValue = value as? Bool {
                    cell.valueLabel.text = Utils.boolToString(b: boolValue)
                } else if let intValue = value as? Int {
                    cell.valueLabel.text = String(describing: intValue)
                } else if let floatValue = value as? Float {
                    cell.valueLabel.text = String(describing: floatValue)
                } else {
                    //problems
                }
            }
        }
        return cell
    }
}
