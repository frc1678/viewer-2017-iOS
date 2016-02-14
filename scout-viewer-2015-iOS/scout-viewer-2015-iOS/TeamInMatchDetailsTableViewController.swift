//
//  TeamInMatchDetailsTableViewController.swift
//  scout-viewer-2015-iOS
//
//  Created by Citrus Circuits on 2/18/15.
//  Copyright (c) 2015 Citrus Circuits. All rights reserved.
//

import UIKit

class TeamInMatchDetailsTableViewController: UITableViewController {
    var firebaseFetcher = FirebaseDataFetcher()
    
    var data: TeamInMatchData? = nil {
        didSet {
            tableView?.reloadData()
            updateTitle()
        }
    }
    
//    let humanReadableNames = ["uploadedData.robotMovedIntoAutoZone": "Moved into Auto Zone",
//    "uploadedData.stackedToteSet": "Stacked Tote Set",
//    "uploadedData.numTotesMovedIntoAutoZone": "Totes into Auto",
//    "uploadedData.numContainersMovedIntoAutoZone": "Recons into Auto",
//    "uploadedData.numTotesStacked": "Totes Stacked",
//    "uploadedData.numReconLevels": "Recon Levels",
//    "uploadedData.numReconsStacked": "Recons Stacked",
//    "uploadedData.numNoodlesContributed": "Noodles Contributed",
//    "uploadedData.numTotesPickedUpFromGround": "Totes from Ground",
//    "uploadedData.numLitterDropped": "Litter Dropped",
//    "uploadedData.numStacksDamaged": "Stacks Damaged",
//    "uploadedData.coopActions": "Coop Actions",
//    "uploadedData.maxFieldToteHeight": "Highest Tote Stacked",
//    "uploadedData.maxReconHeight": "Highest Recon Stacked",
//    "uploadedData.reconAcquisitions": "Step Recon Acquisitions",
//    "uploadedData.numLitterThrownToOtherSide": "Thrown Litter",
//    "uploadedData.agility": "Agility",
//    "uploadedData.stackPlacing": "Stack Placing Security",
//    "uploadedData.humanPlayerLoading": "HP Loading Ability",
//    "uploadedData.incapacitated": "Incapacitated",
//    "uploadedData.disabled": "Disabled",
//    "uploadedData.miscellaneousNotes": "Notes",
//    "calculatedData.numReconsPickedUp": "Recons Intaked",
//    "uploadedData.numHorizontalReconsPickedUp": "H. Recons Intaked",
//    "uploadedData.numVerticalReconsPickedUp": "V. Recons Intaked",
//    "uploadedData.numTeleopReconsFromStep": "Step Recons Teleop" ]
    
    let autoKeys = ["uploadedData.stackedToteSet", "uploadedData.numContainersMovedIntoAutoZone"]
    let teleKeys = ["uploadedData.numTotesStacked", "uploadedData.numReconLevels", "uploadedData.numNoodlesContributed", "uploadedData.numReconsStacked", "uploadedData.numTeleopReconsFromStep", "uploadedData.numHorizontalReconsPickedUp", "uploadedData.numVerticalReconsPickedUp", "calculatedData.numReconsPickedUp", "uploadedData.numTotesPickedUpFromGround", "uploadedData.numLitterDropped", "uploadedData.numStacksDamaged", "uploadedData.coopActions", "uploadedData.maxFieldToteHeight", "uploadedData.maxReconHeight", "uploadedData.reconAcquisitions" ]
    let superKeys = ["uploadedData.agility", "uploadedData.stackPlacing" ]
    let statusKeys = ["uploadedData.incapacitated", "uploadedData.disabled"]
    let miscKeys = ["uploadedData.miscellaneousNotes"]
    
    var graphableCells: [String] = []
    
    var keySets: [[String]] {
        return [autoKeys, teleKeys, superKeys, statusKeys, miscKeys]
    }
    
    
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
            let cell = tableView.dequeueReusableCellWithIdentifier("TeamInMatchDetailRLMArrayCell", forIndexPath: indexPath) as! UITableViewCell
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
        } else if let array = dataPoint as? NSArray {
            cell = tableView.dequeueReusableCellWithIdentifier("TeamInMatchDetailRLMArrayCell", forIndexPath: indexPath) as! UITableViewCell

            cell.detailTextLabel?.text = "some array"
            cell.textLabel?.text = humanReadableNames[keySets[indexPath.section][indexPath.row]]
        } else {
            cell = tableView.dequeueReusableCellWithIdentifier("TeamInMatchDetailValueCell", forIndexPath: indexPath) as! UITableViewCell

            cell.detailTextLabel?.text = "\(dataPoint)"
            cell.textLabel?.text = humanReadableNames[keySets[indexPath.section][indexPath.row]]
            
            graphableCells.append(cell.textLabel!.text!)
        }
        
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let dest = segue.destinationViewController as? TeamDetailsTableViewController {
            if let number = data?.teamNumber {
                dest.data = firebaseFetcher.fetchTeam(number)
            }
        } else if segue.identifier == "Graph" {
            let graphViewController = segue.destinationViewController as! GraphViewController
            
            if let teamNum = data?.teamNumber {
                let indexPath = sender as! NSIndexPath
                if let cell = tableView.cellForRowAtIndexPath(indexPath) {
                    graphViewController.graphTitle = "\(cell.textLabel!.text!)"
                    graphViewController.displayTitle = "\(graphViewController.graphTitle): "
                    let key = keySets[indexPath.section][indexPath.row]
                    if let values = firebaseFetcher.valuesInCompetitionOfPathForTeams(key) as? [CGFloat] as [CGFloat]? {
                        graphViewController.values = (values as? [CGFloat])!
                        graphViewController.subDisplayLeftTitle = "Match: "
                        graphViewController.subValuesLeft = firebaseFetcher.valuesInTeamMatchesOfPath("match.match", forTeam: firebaseFetcher.fetchTeam(data!.teamNumber)) as [AnyObject]
                        if let d = data {
                            graphViewController.subValuesRight = nsNumArrayToIntArray(firebaseFetcher.ranksOfTeamInMatchDatasWithCharacteristic(keySets[indexPath.section][indexPath.row], forTeam:firebaseFetcher.fetchTeam(d.teamNumber)))
                            
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







