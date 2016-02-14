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
    var relevantDefense = ""
    
    var defenseKeys = [
        "calculatedData.avgFailedTimesCrossedDefensesAuto",
        "calculatedData.avgFailedTimesCrossedDefensesTele",
        "calculatedData.avgSuccessfulTimesCrossedDefensesAuto",
        "calculatedData.avgSuccessfulTimesCrossedDefensesTele",
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
        self.title = humanReadableNames[getKeyFromTeamLabel(relevantDefense)]

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func configureCell(cell: UITableViewCell!, atIndexPath path: NSIndexPath!, forData data: AnyObject!, inTableView tableView: UITableView!) {
        let value = data as? Int
        var multiCell = cell as? MultiCellTableViewCell
        
        let title = humanReadableNames[defenseKeys[path.row]]
        
        multiCell?.teamLabel!.text = title
        multiCell?.scoreLabel!.text = String(value!)
        multiCell?.rankLabel!.text = ""
        
        

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
    override func loadDataArray(shouldForce: Bool) -> [AnyObject]! {
        let team = self.firebaseFetcher.fetchTeam(teamNumber)
        let key = getKeyFromTeamLabel(relevantDefense)
        
        let teleSuccessValue = team.calculatedData.avgSuccessfulTimesCrossedDefensesTele[key]
        let autoSuccessValue = team.calculatedData.avgFailedTimesCrossedDefensesAuto[key]
        let something = team.calculatedData.avgSuccessfulTimesCrossedDefensesAuto[key]
        let somethingElse = team.calculatedData.avgSuccessfulTimesCrossedDefensesTele[key]
            
        let intArray = [teleSuccessValue!,autoSuccessValue!,something!,somethingElse!]
        
        return intArray
    }

}
