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
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        self.performSegueWithIdentifier("TeamDetails", sender: tableView.cellForRowAtIndexPath(indexPath))
    }
    
    /*override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    
    }*/
    
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
            dest.data = firebaseFetcher.getTeam(Int((selectedCell?.teamLabel!.text)!)!)
        }
    
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
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    /*override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if let dest = segue.destinationViewController as? TeamDetailsTableViewController {
    let cell = sender as? MultiCellTableViewCell
    let team = firebaseFetcher.fetchTeam(Int((cell?.teamLabel!.text)!)!)
    dest.data = team;
    }
    // Pass the selected object to the new view controller.
    }*/
    func reloadTableView() {
        self.tableView.reloadData()
    }
    
    override func cellIdentifier() -> String! {
        return "MultiCellTableViewCell"
    }
    override func filteredArrayForSearchText(text: String!, inScope scope: Int) -> [AnyObject]! {
        return self.firebaseFetcher.filteredTeamsForSearchString(text)
    }
    
    
}
