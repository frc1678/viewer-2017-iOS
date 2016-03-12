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
                print(getKeyFromTeamLabel(relevantDefense))
                self.title = Utils.humanReadableNames[getKeyFromTeamLabel(relevantDefense)]
                
            }
        }
    }
    
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
        
    ]
    func getKeyFromTeamLabel(relevantString:String) -> String {
        let stringArray = relevantString.characters.split{$0==" "}.map(String.init)
        print(stringArray[0].lowercaseString)
        return stringArray[0].lowercaseString
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(relevantDefense)
        print(getKeyFromTeamLabel(relevantDefense))
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
        multiCell?.scoreLabel!.text = String(value!)
        multiCell?.rankLabel!.text = ""
        
        
        
    }
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
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
            
            crossesData.append(autoSuccessAvg ?? 0.0)
            crossesData.append(teleSuccessAvg ?? 0.0)
            crossesData.append(autoFailAvg ?? 0.0)
            crossesData.append(teleFailAvg ?? 0.0)

            crossesData.append(cd.avgTimeForDefenseCrossAuto?[key] as? Double ?? 0.0)
            crossesData.append(cd.avgTimeForDefenseCrossTele?[key] as? Double ?? 0.0)
            crossesData.append(cd.predictedSuccessfulCrossingsForDefenseTele?[key] as? Double ?? 0.0)
            crossesData.append(cd.sdFailedDefenseCrossesAuto?[key] as? Double ?? 0.0)
            crossesData.append(cd.sdFailedDefenseCrossesTele?[key] as? Double ?? 0.0)
            crossesData.append(cd.sdSuccessfulDefenseCrossesAuto?[key] as? Double ?? 0.0)
            crossesData.append(cd.sdSuccessfulDefenseCrossesTele?[key] as? Double ?? 0.0)
        }
        for i in 0..<crossesData.count {
            crossesData[i] = Double(Utils.roundDoubleValue(crossesData[i], toDecimalPlaces: 2))!
        }
        return crossesData
    }
    
}
