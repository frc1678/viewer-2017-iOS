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
    var conditionalSecondPickArray = [Team]()
    

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

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows

        return self.conditionalSecondPickArray.count;
    }
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("secondPickToTeam", sender: tableView.cellForRowAtIndexPath(indexPath))
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let nib = NSBundle.mainBundle().loadNibNamed("MultiCellTableViewCell", owner: self, options: nil)
        let cell = nib.first
        let team = self.conditionalSecondPickArray[indexPath.row]
        cell!.teamLabel!!.text = String(team.number)
        cell!.rankLabel!!.text = String(indexPath.row)
        print(team.calculatedData.secondPickAbility)
        print(team.number)
        cell!.scoreLabel!!.text = team.calculatedData.secondPickAbility.objectForKey(team.number) as? String

        return cell as! UITableViewCell
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

    
    func checkRes(notification:NSNotification) {
        if notification.name == "updateLeftTable" {
            self.team = self.firebaseFetcher.fetchTeam(self.teamNumber)
            self.title = String(self.team.number) + " - Second Pick"
            self.conditionalSecondPickArray = self.firebaseFetcher.secondPickList(teamNumber)
            print(self.conditionalSecondPickArray)
            self.tableView.reloadData()
        }
    }
}
