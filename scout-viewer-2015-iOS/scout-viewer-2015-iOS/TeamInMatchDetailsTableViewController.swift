//
//  TeamInMatchDetailsTableViewController.swift
//  scout-viewer-2015-iOS
//
//  Created by Citrus Circuits on 2/18/15.
//  Copyright (c) 2015 Citrus Circuits. All rights reserved.
//

import UIKit

class TeamInMatchDetailsTableViewController: UITableViewController {
    var firebaseFetcher = AppDelegate.getAppDelegate().firebaseFetcher
    
    var data: TeamInMatchData? = nil {
        didSet {
            tableView?.reloadData()
            updateTitle()
        }
    }
    
    var graphableCells: [String] = []
    var keySets : [[String]] = [Utils.autoKeys, Utils.teleKeys, Utils.superKeys, Utils.statusKeys, Utils.miscKeys]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = 100
        updateTitle()
    }
    
    func updateTitle() {
        switch (data?.matchNumber, data?.teamNumber) {
        case (.some(let m), .some(let n)):
            title = "\(m) - \(n)"
        case (.some(let m), .none):
            title = "\(m) - Unknown Team"
        case (.none, .some(let n)):
            title = "Unknown Match - \(n)"
        default:
            title = "Unknown Match - Unkown Team"
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return data == nil ? 1 : keySets.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data == nil ? 1 : keySets[section].count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return data == nil ? nil : ["Auto", "Teleop", "Super", "Status", "Miscellaneous"][section]
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if data == nil {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TeamInMatchDetailRLMArrayCell", for: indexPath) 
            cell.textLabel?.text = "No data yet..."
            cell.accessoryType = UITableViewCellAccessoryType.none
            return cell
        }
        
        var cell: UITableViewCell
        let dataPoint: String = data!.value(forKeyPath: (keySets as [[String]])[(indexPath as NSIndexPath).section][(indexPath as NSIndexPath).row])! as! String
        if let notes = dataPoint as? String {
            cell = tableView.dequeueReusableCell(withIdentifier: "TeamInMatchDetailStringCell", for: indexPath) as! ResizableNotesTableViewCell
            let notesCell = cell as! ResizableNotesTableViewCell
            notesCell.titleLabel?.text = "Notes:"
            notesCell.notesLabel?.text = notes.characters.count == 0 ? "None" : notes
        } else if let _ = dataPoint as? NSArray {
            cell = tableView.dequeueReusableCell(withIdentifier: "TeamInMatchDetailRLMArrayCell", for: indexPath) 
            
            cell.detailTextLabel?.text = "some array"
            cell.textLabel?.text = Utils.humanReadableNames[keySets[(indexPath as NSIndexPath).section][(indexPath as NSIndexPath).row]]
        } else {
            cell = tableView.dequeueReusableCell(withIdentifier: "TeamInMatchDetailValueCell", for: indexPath)
            cell.detailTextLabel?.text = "\(dataPoint)"
            cell.textLabel?.text = Utils.humanReadableNames[keySets[(indexPath as NSIndexPath).section][(indexPath as NSIndexPath).row]]
            graphableCells.append(cell.textLabel!.text!)
        }
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dest = segue.destination as? TeamDetailsTableViewController {
            if let number = data?.teamNumber {
                dest.team = firebaseFetcher?.getTeam(number.intValue)
            }
        } else if segue.identifier == "Graph" {
            let graphViewController = segue.destination as! GraphViewController
            
            if let _ = data?.teamNumber {
                let indexPath = sender as! IndexPath
                if let cell = tableView.cellForRow(at: indexPath) {
                    graphViewController.graphTitle = "\(cell.textLabel!.text!)"
                    graphViewController.displayTitle = "\(graphViewController.graphTitle): "
                    let key = keySets[(indexPath as NSIndexPath).section][(indexPath as NSIndexPath).row]
                    if let values = firebaseFetcher?.valuesInCompetitionOfPathForTeams(key) as? [CGFloat] as [CGFloat]? {
                        graphViewController.values = (values)
                        graphViewController.subDisplayLeftTitle = "Match: "
                        graphViewController.subValuesLeft = firebaseFetcher!.valuesInTeamMatchesOfPath("match.match", forTeam: (firebaseFetcher?.getTeam(data!.teamNumber!.intValue))!) as [AnyObject]
                        if let d = data {
                            graphViewController.subValuesRight = nsNumArrayToIntArray(firebaseFetcher!.ranksOfTeamInMatchDatasWithCharacteristic((keySets as [[String]])[(indexPath as NSIndexPath).section][(indexPath as NSIndexPath).row] as NSString, forTeam:firebaseFetcher!.getTeam(d.teamNumber!.intValue)) as [NSNumber]) as [AnyObject]
                            
                            if let i = ((graphViewController.subValuesLeft as! [String]).index(of: String(describing: d.matchNumber))) {
                                graphViewController.highlightIndex = i
                            }
                        }
                        graphViewController.subDisplayRightTitle = "Rank: "
                    }
                    
                }
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            if graphableCells.contains(cell.textLabel!.text!) {
                performSegue(withIdentifier: "Graph", sender: indexPath)
            }
        }
    }
}







