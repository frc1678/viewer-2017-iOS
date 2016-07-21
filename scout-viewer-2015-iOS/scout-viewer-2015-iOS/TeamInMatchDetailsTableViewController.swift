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
    var keySets = [Utils.autoKeys, Utils.teleKeys, Utils.superKeys, Utils.statusKeys, Utils.miscKeys]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = 100
        updateTitle()
    }
    
    func updateTitle() {
        switch (data?.matchNumber, data?.teamNumber) {
        case (.Some(let m), .Some(let n)):
            title = "\(m) - \(n)"
        case (.Some(let m), .None):
            title = "\(m) - Unknown Team"
        case (.None, .Some(let n)):
            title = "Unknown Match - \(n)"
        default:
            title = "Unknown Match - Unkown Team"
        }
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return data == nil ? 1 : keySets.count
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data == nil ? 1 : keySets[section].count
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return data == nil ? nil : ["Auto", "Teleop", "Super", "Status", "Miscellaneous"][section]
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if data == nil {
            let cell = tableView.dequeueReusableCellWithIdentifier("TeamInMatchDetailRLMArrayCell", forIndexPath: indexPath) 
            cell.textLabel?.text = "No data yet..."
            cell.accessoryType = UITableViewCellAccessoryType.None
            return cell
        }
        
        var cell: UITableViewCell
        let dataPoint: AnyObject = data!.valueForKeyPath(keySets[indexPath.section][indexPath.row])!
        if let notes = dataPoint as? String {
            cell = tableView.dequeueReusableCellWithIdentifier("TeamInMatchDetailStringCell", forIndexPath: indexPath) as! ResizableNotesTableViewCell
            let notesCell = cell as! ResizableNotesTableViewCell
            notesCell.titleLabel?.text = "Notes:"
            notesCell.notesLabel?.text = notes.characters.count == 0 ? "None" : notes
        } else if let _ = dataPoint as? NSArray {
            cell = tableView.dequeueReusableCellWithIdentifier("TeamInMatchDetailRLMArrayCell", forIndexPath: indexPath) 
            
            cell.detailTextLabel?.text = "some array"
            cell.textLabel?.text = Utils.humanReadableNames[keySets[indexPath.section][indexPath.row]]
        } else {
            cell = tableView.dequeueReusableCellWithIdentifier("TeamInMatchDetailValueCell", forIndexPath: indexPath)
            cell.detailTextLabel?.text = "\(dataPoint)"
            cell.textLabel?.text = Utils.humanReadableNames[keySets[indexPath.section][indexPath.row]]
            graphableCells.append(cell.textLabel!.text!)
        }
        
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let dest = segue.destinationViewController as? TeamDetailsTableViewController {
            if let number = data?.teamNumber {
                dest.team = firebaseFetcher.getTeam(number.integerValue)
            }
        } else if segue.identifier == "Graph" {
            let graphViewController = segue.destinationViewController as! GraphViewController
            
            if let _ = data?.teamNumber {
                let indexPath = sender as! NSIndexPath
                if let cell = tableView.cellForRowAtIndexPath(indexPath) {
                    graphViewController.graphTitle = "\(cell.textLabel!.text!)"
                    graphViewController.displayTitle = "\(graphViewController.graphTitle): "
                    let key = keySets[indexPath.section][indexPath.row]
                    if let values = firebaseFetcher.valuesInCompetitionOfPathForTeams(key) as? [CGFloat] as [CGFloat]? {
                        graphViewController.values = (values)
                        graphViewController.subDisplayLeftTitle = "Match: "
                        graphViewController.subValuesLeft = firebaseFetcher.valuesInTeamMatchesOfPath("match.match", forTeam: firebaseFetcher.getTeam(data!.teamNumber!.integerValue)) as [AnyObject]
                        if let d = data {
                            graphViewController.subValuesRight = nsNumArrayToIntArray(firebaseFetcher.ranksOfTeamInMatchDatasWithCharacteristic(keySets[indexPath.section][indexPath.row], forTeam:firebaseFetcher.getTeam(d.teamNumber!.integerValue)))
                            
                            if let i = ((graphViewController.subValuesLeft as! [String]).indexOf(String(d.matchNumber))) {
                                graphViewController.highlightIndex = i
                            }
                        }
                        graphViewController.subDisplayRightTitle = "Rank: "
                    }
                    
                }
            }
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let cell = tableView.cellForRowAtIndexPath(indexPath) {
            if graphableCells.contains(cell.textLabel!.text!) {
                performSegueWithIdentifier("Graph", sender: indexPath)
            }
        }
    }
}







