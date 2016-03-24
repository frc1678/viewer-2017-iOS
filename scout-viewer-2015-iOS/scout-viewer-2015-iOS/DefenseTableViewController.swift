//
//  DefenseTableViewController.swift
//  scout-viewer-2015-iOS
//
//  Created by Samuel Resendez on 2/10/16.
//  Copyright © 2016 Citrus Circuits. All rights reserved.
//

import UIKit

class DefenseTableViewController: ArrayTableViewController {
    
    var teamNumber = -1
    var relevantDefense = "" {
        didSet {
            if relevantDefense != "" {
                //print(getKeyFromTeamLabel(relevantDefense))
                self.title = Utils.humanReadableNames[getKeyFromTeamLabel(relevantDefense)]
                
            }
        }
    }
    var defenseKey = ""
    
    var defenseKeys = [
        "calculatedData.avgSuccessfulTimesCrossedDefensesAuto",
        "calculatedData.avgSuccessfulTimesCrossedDefensesTele",
        "calculatedData.avgFailedTimesCrossedDefensesAuto",
        "calculatedData.avgFailedTimesCrossedDefensesTele",
        
        "calculatedData.avgTimeForDefenseCrossAuto",
        "calculatedData.avgTimeForDefenseCrossTele",
        "calculatedData.predictedSuccessfulCrossingsForDefenseTele",
        "calculatedData.sdFailedDefenseCrossesAuto",
        "calculatedData.sdFailedDefenseCrossesTele",
        "calculatedData.sdSuccessfulDefenseCrossesAuto",
        "calculatedData.sdSuccessfulDefenseCrossesTele",
        
        "calculatedData.beachedPercentage",
        "calculatedData.slowedPercentage"
        
    ]
    func getKeyFromTeamLabel(relevantString:String) -> String {
        let stringArray = relevantString.characters.split{$0==" "}.map(String.init)
        //print(stringArray[0].lowercaseString)
        return stringArray[0].lowercaseString
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //print(relevantDefense)
        //print(getKeyFromTeamLabel(relevantDefense))
        self.title = Utils.humanReadableNames[getKeyFromTeamLabel(relevantDefense)]
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func configureCell(cell: UITableViewCell!, atIndexPath path: NSIndexPath!, forData data: AnyObject!, inTableView tableView: UITableView!) {
        let value = data as? Float
        let multiCell = cell as? MultiCellTableViewCell
        
        let title = Utils.humanReadableNames[defenseKeys[path.row]]
        
        multiCell?.teamLabel!.text = title
        if value! == -1.0 {
            multiCell?.scoreLabel?.text = "None"
        } else {
            multiCell?.scoreLabel!.text = String(value!)
        }
        let team = firebaseFetcher.fetchTeam(teamNumber)
        multiCell?.rankLabel!.text = "\(firebaseFetcher.rankOfTeam(team, withCharacteristic: "\(defenseKeys[path.row]).\(defenseKey)"))"
        
        
        
    }
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var key : String? = ""
        if let cell = tableView.cellForRowAtIndexPath(indexPath) as? MultiCellTableViewCell {
            let text = cell.teamLabel?.text
            key = Utils.getKeyForHumanReadableName(text!)
        }
        if (key != "") {
            if ["calculatedData.avgSuccessfulTimesCrossedDefensesAuto","calculatedData.avgSuccessfulTimesCrossedDefensesTele","calculatedData.avgFailedTimesCrossedDefensesAuto","calculatedData.avgFailedTimesCrossedDefensesTele","calculatedData.numTimesFailedCrossedDefensesTele","calculatedData.avgTimeForDefenseCrossAuto", "calculatedData.avgTimeForDefenseCrossTele", "calculatedData.beachedPercentage", "calculatedData.slowedPercentage"].contains(key!) {
                performSegueWithIdentifier("DefenseToGraph", sender: indexPath)
            }
        }
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let graphViewController = segue.destinationViewController as! GraphViewController
        
        
        let indexPath = sender as! NSIndexPath
        if let cell = tableView.cellForRowAtIndexPath(indexPath) as? MultiCellTableViewCell {
            let text = cell.teamLabel?.text
            
            var key = Utils.getKeyForHumanReadableName(text!)
            if key != nil {
                switch key! {
                case "calculatedData.avgSuccessfulTimesCrossedDefensesAuto": key = "calculatedData.numTimesSuccesfulCrossedDefensesAuto"
                case "calculatedData.avgSuccessfulTimesCrossedDefensesTele": key = "calculatedData.numTimesSuccesfulCrossedDefensesTele"
                case "calculatedData.avgFailedTimesCrossedDefensesAuto": key = "calculatedData.numTimesFailedCrossedDefensesAuto"
                case "calculatedData.avgFailedTimesCrossedDefensesTele": key = "calculatedData.numTimesFailedCrossedDefensesTele"
                    
                case "calculatedData.avgTimeForDefenseCrossAuto": key = "calculatedData.crossingTimeForDefenseAuto"
                case "calculatedData.avgTimeForDefenseCrossTele": key = "calculatedData.crossingTimeForDefenseTele"
                    //Beached and slowed stay the same
                default: break
                }
            }
            graphViewController.graphTitle = "\(Utils.getHumanReadableNameForKey(key!) ?? relevantDefense)"
            graphViewController.displayTitle = "\(graphViewController.graphTitle): "
            if key != nil && key != "" {
                
                //print("This is the key:")
                //print(keySets[indexPath.section][indexPath.row])
                let values: [Float]
                if key?.rangeOfString("beached") == nil && key?.rangeOfString("slowed") == nil {
                    (values, _) = firebaseFetcher.getMatchValuesForTeamForPath("\(key!).\(defenseKey)", forTeam: firebaseFetcher.fetchTeam(teamNumber))
                } else {
                    (values, _) = firebaseFetcher.getMatchValuesForTeamForPath("\(key!)", forTeam: firebaseFetcher.fetchTeam(teamNumber))
                }
                
                /*if values.reduce(0, combine: +) == 0 || values.count == 0 {
                    graphViewController.graphTitle = "Data Is All 0s"
                    graphViewController.values = [CGFloat]()
                    graphViewController.subValuesLeft = [CGFloat]()
                } else {*/
                    //print(values)
                    graphViewController.values = values as NSArray as! [CGFloat]
                    graphViewController.subDisplayLeftTitle = "Match: "
                    graphViewController.subValuesLeft = nsNumArrayToIntArray(firebaseFetcher.matchNumbersForTeamNumber(teamNumber))
                    //print("Here are the subValues \(graphViewController.values.count)::\(graphViewController.subValuesLeft.count)")
                    //print(graphViewController.subValuesLeft)
               // }
                /*if let d = data {
                graphViewController.subValuesRight =
                nsNumArrayToIntArray(firebaseFetcher.ranksOfTeamInMatchDatasWithCharacteristic(keySets[indexPath.section][indexPath.row], forTeam:firebaseFetcher.fetchTeam(d.number!.integerValue)))
                
                let i = ((graphViewController.subValuesLeft as NSArray).indexOfObject("\(teamNum)"))
                graphViewController.highlightIndex = i
                
                }*/
                graphViewController.subDisplayRightTitle = "Team: "
                graphViewController.subValuesRight = [teamNumber,teamNumber,teamNumber,teamNumber,teamNumber]
            }
            
        }
        
    }
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    override func cellIdentifier() -> String! {
        return "MultiCellTableViewCell"
    }
    override func loadDataArray(shouldForce: Bool) -> [AnyObject]? {
        let team = self.firebaseFetcher.fetchTeam(teamNumber)
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
            crossesData[i] = Double(Utils.roundDoubleValue(crossesData[i], toDecimalPlaces: 2).stringByReplacingOccurrencesOfString(",", withString: "")) ?? -1.0
        }
        return crossesData
    }
    
}
