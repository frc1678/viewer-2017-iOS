//
//  ConditionalSecondPickTableViewController.swift
//  scout-viewer-2015-iOS
//
//  Created by Bryton Moeller on 2/23/16.
//  Copyright © 2016 Citrus Circuits. All rights reserved.
//

import UIKit

class OverallSecondPickAbilityViewController: ArrayTableViewController {
    
    var teamNumber = -1
    var team = Team()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector:#selector(OverallSecondPickAbilityViewController.reloadTableView), name:"updateLeftTable", object:nil)
    }
    
    func reloadTableView(note: NSNotification) {
        tableView.reloadData()
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        self.performSegueWithIdentifier("TeamDetails", sender: tableView.cellForRowAtIndexPath(indexPath))
    }
    
    override func configureCell(cell: UITableViewCell!, atIndexPath path: NSIndexPath!, forData data: AnyObject!, inTableView tableView: UITableView!) {
        let multiCell = cell as? MultiCellTableViewCell
        let team = data as? Team
        if team!.number != nil {
            multiCell!.teamLabel!.text = String(team!.number!.integerValue)
        }
        if team!.calculatedData?.overallSecondPickAbility != nil {
            multiCell!.scoreLabel!.text = String(Utils.roundValue(team!.calculatedData!.overallSecondPickAbility!.floatValue, toDecimalPlaces: 2)
            )
        } else {
            multiCell!.scoreLabel!.text = ""
        }
        multiCell!.rankLabel!.text = "\(self.firebaseFetcher.rankOfTeam(team!, withCharacteristic: "calculatedData.overallSecondPickAbility"))"
        
    }
    
    override func loadDataArray(shouldForce: Bool) -> [AnyObject]! {
        return self.firebaseFetcher.getOverallSecondPickList()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let dest = segue.destinationViewController as? TeamDetailsTableViewController {
            let selectedCell = sender as? MultiCellTableViewCell
            dest.team = firebaseFetcher.getTeam(Int((selectedCell?.teamLabel!.text)!)!)
        }
    }
    
    override func cellIdentifier() -> String! {
        return "MultiCellTableViewCell"
    }
    override func filteredArrayForSearchText(text: String!, inScope scope: Int) -> [AnyObject]! {
        return self.firebaseFetcher.filteredTeamsForSearchString(text)
    }
}
