//
//  DefenseTableViewController.swift
//  scout-viewer-2016-iOS
//
//  Created by Samuel Resendez on 2/10/16.
//  Copyright © 2016 Citrus Circuits. All rights reserved.
//

import UIKit

class DefenseTableViewController: ArrayTableViewController {
    /// The team number of the team whose defense crossing ability we are examining.
    var teamNumber = -1
    /// The defense we are looking at, in human readable form, abbriviated I think
    var relevantDefense = "" {
        didSet {
            if relevantDefense != "" {
                self.title = Utils.humanReadableNames[getKeyFromTeamLabel(relevantDefense)]
            }
        }
    }
    /// The abriviation of the defense we are looking at
    var defenseKey = ""
    
    /**
     Gets which defense it is.
     
     - parameter relevantString: String which is the title of the table view cell that brought us to this controller. The first word of this title is the defense.
     
     - returns: the defense key
     */
    func getKeyFromTeamLabel(_ relevantString:String) -> String {
        let stringArray = relevantString.characters.split{$0==" "}.map(String.init)
        return stringArray[0].lowercased()
    }
    
    override func viewDidLoad() {
        searchbarIsEnabled = false
        super.viewDidLoad()
        self.title = Utils.humanReadableNames[getKeyFromTeamLabel(relevantDefense)]
        
        let longPress = UILongPressGestureRecognizer(target:self, action:#selector(DefenseTableViewController.rankingDetailsSegue(_:)))
        self.view.addGestureRecognizer(longPress)
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func configureCell(_ cell: UITableViewCell!, at path: IndexPath!, forData data: Any!, in tableView: UITableView!) {
        let value = data as? Float
        let multiCell = cell as? MultiCellTableViewCell
        
        multiCell?.teamLabel!.text = Utils.humanReadableNames[Utils.defenseKeys[path.row]]
        if value == nil || value! == -1.0 { //There is a system problem
            multiCell?.scoreLabel?.text = "None"
        } else {
            multiCell?.scoreLabel!.text = String(value!)
        }
        let team = firebaseFetcher.getTeam(teamNumber)
        multiCell?.rankLabel!.text = "\(firebaseFetcher.rankOfTeam(team, withCharacteristic: "\(Utils.defenseKeys[path.row]).\(defenseKey)"))"
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var key : String? = ""
        if let cell = tableView.cellForRow(at: indexPath) as? MultiCellTableViewCell {
            key = Utils.getKeyForHumanReadableName((cell.teamLabel?.text!)!)
        }
        if key != "" && Utils.defenseGraphableKeys.contains(key!) {
            performSegue(withIdentifier: "DefenseToGraph", sender: indexPath)
        }
        
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "sortedRankSegue" {
            let rankViewController = segue.destination as! SortedRankTableViewController
            rankViewController.keyPath = sender as! String
            rankViewController.title = " "
        } else {
            let graphViewController = segue.destination as! GraphViewController
            
            
            let indexPath = sender as! IndexPath
            if let cell = tableView.cellForRow(at: indexPath) as? MultiCellTableViewCell {
                let text = cell.teamLabel?.text
                
                var key = Utils.getKeyForHumanReadableName(text!)
                if key != nil {
                    key = Utils.defenseStatKeysToGraphableKeys(key!)
                }
                graphViewController.graphTitle = text!
                graphViewController.displayTitle = "\(graphViewController.graphTitle): "
                if key != nil && key != "" && key != "NO KEY" {
                    
                    let values: [Float]
                    if key?.range(of: "beached") == nil && key?.range(of: "slowed") == nil {
                        (values, _) = firebaseFetcher.getMatchValuesForTeamForPath("\(key!).\(defenseKey)", forTeam: firebaseFetcher.getTeam(teamNumber))
                    } else {
                        (values, _) = firebaseFetcher.getMatchValuesForTeamForPathForDefense("\(key!)", forTeam: firebaseFetcher.getTeam(teamNumber), defenseKey: self.defenseKey)
                    }
                    
                    graphViewController.values = (values as NSArray).map { CGFloat($0 as! Float) }
                    graphViewController.subDisplayLeftTitle = "Match: "
                    graphViewController.subValuesLeft = nsNumArrayToIntArray(firebaseFetcher.matchNumbersForTeamNumber(teamNumber)) as [AnyObject]
                    graphViewController.subDisplayRightTitle = "Team: "
                    graphViewController.subValuesRight = [teamNumber as AnyObject,teamNumber as AnyObject,teamNumber as AnyObject,teamNumber as AnyObject,teamNumber as AnyObject] //Why are there 5?
                }
                
            }
        }
        
    }
    
    override func cellIdentifier() -> String! {
        return "MultiCellTableViewCell"
    }
    
    override func loadDataArray(_ shouldForce: Bool) -> [Any]? {
        let team = self.firebaseFetcher.getTeam(teamNumber)
        let key = getKeyFromTeamLabel(relevantDefense)
        var crossesData = [Double]()
        if let cd = team.calculatedData {
            let teleSuccessAvg = team.calculatedData?.avgSuccessfulTimesCrossedDefensesTele?[key] as? Double
            let autoFailAvg = team.calculatedData?.avgFailedTimesCrossedDefensesAuto?[key] as? Double
            let autoSuccessAvg = team.calculatedData?.avgSuccessfulTimesCrossedDefensesAuto?[key] as? Double
            let teleFailAvg = team.calculatedData?.avgFailedTimesCrossedDefensesTele?[key] as? Double
            
            crossesData.append(autoSuccessAvg ?? -1.0)
            crossesData.append(teleSuccessAvg ?? -1.0)
            crossesData.append(autoFailAvg ?? -1.0)
            crossesData.append(teleFailAvg ?? -1.0)
            
            crossesData.append(cd.avgTimeForDefenseCrossAuto?[key] as? Double ?? -1.0)
            crossesData.append(cd.avgTimeForDefenseCrossTele?[key] as? Double ?? -1.0)
            crossesData.append(cd.predictedSuccessfulCrossingsForDefenseTele?[key] as? Double ?? -1.0)
            crossesData.append(cd.sdFailedDefenseCrossesAuto?[key] as? Double ?? -1.0)
            crossesData.append(cd.sdFailedDefenseCrossesTele?[key] as? Double ?? -1.0)
            crossesData.append(cd.sdSuccessfulDefenseCrossesAuto?[key] as? Double ?? -1.0)
            crossesData.append(cd.sdSuccessfulDefenseCrossesTele?[key] as? Double ?? -1.0)
            
            if key == "pc" || key == "cdf" {
                crossesData.append(cd.beachedPercentage?[key] as? Double ?? -1.0)
                crossesData.append(cd.slowedPercentage?[key] as? Double ?? -1.0)
            } else {
                crossesData.append(-1.0)
                crossesData.append(-1.0)
            }
        }
        
        for i in 0..<crossesData.count {
            crossesData[i] = Double(Utils.roundDoubleValue(crossesData[i], toDecimalPlaces: 2).replacingOccurrences(of: ",", with: "")) ?? -1.0
        }
        
        return crossesData as [AnyObject]?
    }
    
    func rankingDetailsSegue(_ gesture: UIGestureRecognizer) {
        
        if(gesture.state == UIGestureRecognizerState.began) {
            let p = gesture.location(in: self.tableView)
            let indexPath = self.tableView.indexPathForRow(at: p)
            if let cell = self.tableView.cellForRow(at: indexPath!) as? MultiCellTableViewCell {
                performSegue(withIdentifier: "sortedRankSegue", sender: "\(Utils.getKeyForHumanReadableName(cell.teamLabel!.text!) ?? "ERROR").\(defenseKey)")
            }
        }
    }
}
