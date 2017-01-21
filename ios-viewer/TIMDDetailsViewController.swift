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
    var TIMD: TeamInMatchData!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if TIMD.teamNumber != nil && TIMD.matchNumber != nil {

        self.title = "\(TIMD.teamNumber!) - Q\(TIMD.matchNumber!)"
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return Utils.TIMDKeys.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Utils.TIMDKeys[section].count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TIMDTableViewCell", for: indexPath) as! TIMDTableViewCell
        
        if TIMD.teamNumber != nil && TIMD.matchNumber != nil {
            let key = Utils.TIMDKeys[indexPath.section][indexPath.row]
            if Utils.humanReadableNames.keys.contains(key) {
                cell.datapointLabel.text = Utils.humanReadableNames[key]
            }
            
            if key.contains("calculatedData") {
                cell.valueLabel.text = TIMD.value(forKeyPath: key) as! String?
            } else {
                cell.valueLabel.text = (TIMD.dictionaryRepresentation() as NSDictionary).object(forKey: key)
            }
            /* if let value = TIMD.value(forKeyPath: key) {
                if let stringValue = value as? String {
                    cell.valueLabel.text = stringValue
                } else if let boolValue = value as? Bool {
                    cell.valueLabel.text = Utils.boolToString(b: boolValue)
                } else if let intValue = value as? Int {
                    cell.valueLabel.text = String(describing: intValue)
                } else if let floatValue = value as? Float {
                    cell.valueLabel.text = String(describing: floatValue)
                } else {
                    //
                }
            } */
        }
        return cell
    }
}
