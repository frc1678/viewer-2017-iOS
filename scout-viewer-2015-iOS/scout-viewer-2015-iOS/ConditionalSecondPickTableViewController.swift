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
        NSNotificationCenter.defaultCenter().addObserver(self, selector:"reloadTableView", name:"updateLeftTable", object:nil)
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

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


    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */
    func reloadTableView() {
        self.tableView.reloadData()
    }
   
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let dest = segue.destinationViewController as? TeamDetailsTableViewController {
            let cell = sender as? MultiCellTableViewCell
            let team = firebaseFetcher.getTeam(Int((cell?.teamLabel!.text)!)!)
            dest.data = team;
        }
        // Pass the selected object to the new view controller.
    }
    override func cellIdentifier() -> String! {
        return "MultiCellTableViewCell"
    }
    
    
    override func filteredArrayForSearchText(searchString: String!, inScope scope: Int) -> [AnyObject]! {
        let filteredData = self.dataArray.filter { String(($0 as! Team).number).rangeOfString(searchString) != nil }
        return filteredData
    }

    
}
