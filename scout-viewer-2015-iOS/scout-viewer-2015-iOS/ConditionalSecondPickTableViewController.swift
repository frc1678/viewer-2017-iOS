//
//  ConditionalSecondPickTableViewController.swift
//  scout-viewer-2015-iOS
//
//  Created by Samuel Resendez on 2/6/16.
//  Copyright © 2016 Citrus Circuits. All rights reserved.
//

import UIKit

class ConditionalSecondPickTableViewController: ArrayTableViewController {
    
    var teamNumber = -1
    var team = Team()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = String(self.teamNumber) + " - Second Pick"

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
        var multiCell = cell as? MultiCellTableViewCell
        let team = data as? Team
        multiCell!.teamLabel!.text = String(team!.number)
        

    }
    override func loadDataArray(shouldForce: Bool) -> [AnyObject]! {
        print(self.firebaseFetcher.secondPickList(teamNumber))
        return self.firebaseFetcher.secondPickList(teamNumber)
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
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let dest = segue.destinationViewController as? TeamDetailsTableViewController {
            let cell = sender as? MultiCellTableViewCell
            let team = firebaseFetcher.fetchTeam(Int((cell?.teamLabel!.text)!)!)
            dest.data = team;
        }
        // Pass the selected object to the new view controller.
    }
    override func cellIdentifier() -> String! {
        return "MultiCellTableViewCell"
    }
    override func filteredArrayForSearchText(text: String!, inScope scope: Int) -> [AnyObject]! {
        return self.firebaseFetcher.filteredTeamsForSearchString(text)
    }

    
}
