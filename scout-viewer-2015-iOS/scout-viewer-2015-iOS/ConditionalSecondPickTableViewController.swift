//
//  ConditionalSecondPickTableViewController.swift
//  scout-viewer-2015-iOS
//
//  Created by Samuel Resendez on 2/6/16.
//  Copyright © 2016 Citrus Circuits. All rights reserved.
//

import UIKit

/// If our first pick is [xxxx] then the second pick ability of team [yyyy] is [...]. It is a predicted score by an alliance made up of 1678, xxxx, and yyyy.
class ConditionalSecondPickTableViewController: ArrayTableViewController {
    
    var teamNumber = -1
    var team = Team()
    var secondPickListRanks = [Int: Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = String(self.teamNumber) + " - Second Pick"
        NSNotificationCenter.defaultCenter().addObserver(self, selector:#selector(ConditionalSecondPickTableViewController.reloadTableView), name:"updateLeftTable", object:nil)
    }
    func reloadTableView(note: NSNotification) {
        tableView.reloadData()
    }

    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("secondPickToTeam", sender: tableView.cellForRowAtIndexPath(indexPath))
    }
    
    override func configureCell(cell: UITableViewCell!, atIndexPath path: NSIndexPath!, forData data: AnyObject!, inTableView tableView: UITableView!) {
        let multiCell = cell as? MultiCellTableViewCell
        let team = data as? Team
        if team!.number != nil {
            multiCell!.teamLabel!.text = String(team!.number!.integerValue)
        }
        if team!.calculatedData?.firstPickAbility != nil {
            multiCell!.scoreLabel!.text = String(team!.calculatedData!.firstPickAbility!.integerValue)
        } else {
            multiCell!.scoreLabel!.text = ""
        }
        multiCell!.rankLabel!.text = "\(self.secondPickListRanks[team!.number! as Int]!)"
    }
    
    override func loadDataArray(shouldForce: Bool) -> [AnyObject]! {
        let picks = self.firebaseFetcher.getConditionalSecondPickList(teamNumber)
        for pick in picks {
            self.secondPickListRanks[pick.number as! Int] = (picks.indexOf(pick)! + 1)
        }
        return self.firebaseFetcher.getConditionalSecondPickList(teamNumber)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let dest = segue.destinationViewController as? TeamDetailsTableViewController {
            let cell = sender as? MultiCellTableViewCell
            let team = firebaseFetcher.getTeam(Int((cell?.teamLabel!.text)!)!)
            dest.team = team;
        }
    }
    
    override func cellIdentifier() -> String! {
        return "MultiCellTableViewCell"
    }
    
    override func filteredArrayForSearchText(searchString: String!, inScope scope: Int) -> [AnyObject]! {
        return self.dataArray.filter { String(($0 as! Team).number).rangeOfString(searchString) != nil }
    }
}
