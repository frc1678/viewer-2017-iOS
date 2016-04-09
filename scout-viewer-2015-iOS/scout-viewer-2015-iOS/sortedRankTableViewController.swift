//
//  sortedRankTableViewController.swift
//  scout-viewer-2015-iOS
//
//  Created by Samuel Resendez on 3/30/16.
//  Copyright © 2016 Citrus Circuits. All rights reserved.
//

import UIKit

class sortedRankTableViewController: ArrayTableViewController {
    
    //Should be provided by Segue
    var keyPath = ""
    var altTitle = ""
    var translatedKeyPath = ""
    override func cellIdentifier() -> String! {
        return "MultiCellTableViewCell"
    }
    
    override func viewDidLoad() {
        translatedKeyPath = Utils.findKeyForValue(keyPath) ?? keyPath
        super.viewDidLoad()
        print(keyPath)
        if let title = self.title {
            print(title)
        } else {
            self.title = keyPath
        }
        if self.title!.characters.count == 0 {
            self.title = keyPath
        }

        // Do any additional setup after loading the view.
    }
    override func configureCell(cell: UITableViewCell!, atIndexPath path: NSIndexPath!, forData data: AnyObject!, inTableView tableView: UITableView!) {
        let team = data as! Team
        let multiCell = cell as! MultiCellTableViewCell
        multiCell.rankLabel!.text = String(path.row + 1)
        multiCell.teamLabel!.text = String(team.number!)
        if translatedKeyPath.rangeOfString("calculatedData") != nil {
            let propIndex = translatedKeyPath.startIndex.advancedBy(15)
            let propPath = translatedKeyPath.substringFromIndex(propIndex)
            if team.calculatedData!.valueForKeyPath(propPath) != nil {
                
                multiCell.scoreLabel!.text = roundValue(team.calculatedData!.valueForKeyPath(propPath), toDecimalPlaces: 2)
            }
        } else {
            multiCell.scoreLabel!.text = roundValue(team.valueForKeyPath(translatedKeyPath), toDecimalPlaces: 2)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func loadDataArray(shouldForce: Bool) -> [AnyObject]! {
        return self.firebaseFetcher.getSortedListbyString(translatedKeyPath)
    }
    override func filteredArrayForSearchText(text: String!, inScope scope: Int) -> [AnyObject]! {
        var filteredTeamArray = [Team]()
        for team in self.dataArray {
            let typeSafeTeam = team as! Team
            if String(typeSafeTeam.number).containsString(text) != false {
                filteredTeamArray.append(typeSafeTeam)
            }
        }
        return filteredTeamArray
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("sortRankToTeam", sender: tableView.cellForRowAtIndexPath(indexPath))
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let dest = segue.destinationViewController as? TeamDetailsTableViewController {
            let multiCell = sender as? MultiCellTableViewCell
            dest.data = firebaseFetcher.fetchTeam(Int(multiCell!.teamLabel!.text!)!)
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

}
