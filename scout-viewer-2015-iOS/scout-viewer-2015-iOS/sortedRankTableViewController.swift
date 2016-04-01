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

    var translatedKeyPath = ""
    override func cellIdentifier() -> String! {
        return "MultiCellTableViewCell"
    }
    
    override func viewDidLoad() {
        translatedKeyPath = Utils.findKeyForValue(keyPath)!
        super.viewDidLoad()
        print(keyPath)
        self.title = keyPath

        // Do any additional setup after loading the view.
    }
    override func configureCell(cell: UITableViewCell!, atIndexPath path: NSIndexPath!, forData data: AnyObject!, inTableView tableView: UITableView!) {
        let team = data as! Team
        let multiCell = cell as! MultiCellTableViewCell
        multiCell.rankLabel!.text = String(path.row + 1)
        multiCell.teamLabel!.text = team.name
        if translatedKeyPath.rangeOfString("calculatedData") != nil {
            let propIndex = translatedKeyPath.startIndex.advancedBy(15)
            let propPath = translatedKeyPath.substringFromIndex(propIndex)
            if team.calculatedData!.valueForKey(propPath) != nil {
                
                multiCell.scoreLabel!.text = roundValue(team.calculatedData!.valueForKey(propPath), toDecimalPlaces: 2)
            }
        } else {
            multiCell.scoreLabel!.text = roundValue(team.valueForKey(translatedKeyPath), toDecimalPlaces: 2)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func loadDataArray(shouldForce: Bool) -> [AnyObject]! {
        return self.firebaseFetcher.getSortedListbyString(translatedKeyPath)
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
