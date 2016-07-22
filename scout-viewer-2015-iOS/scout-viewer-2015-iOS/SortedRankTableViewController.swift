//
//  sortedRankTableViewController.swift
//  scout-viewer-2015-iOS
//
//  Created by Samuel Resendez on 3/30/16.
//  Copyright © 2016 Citrus Circuits. All rights reserved.
//

import UIKit

class SortedRankTableViewController: ArrayTableViewController {
    
    //Should be provided by Segue
    var keyPath = ""
    var altTitle = ""
    var translatedKeyPath = ""
    var shouldReverseRank = false
    override func cellIdentifier() -> String! {
        return "MultiCellTableViewCell"
    }
    
    override func viewDidLoad() {
        translatedKeyPath = Utils.findKeyForValue(keyPath) ?? keyPath //If the keypath has a human readable translation, use it
        super.viewDidLoad()
        if self.title == nil || self.title!.characters.count == 0 {
            self.title = keyPath
        }
        //So you can litrally flip the list over to reverse the sort
        let rotation = UIRotationGestureRecognizer(target: self, action: #selector(SortedRankTableViewController.rotationDetected(_:)))
        
        self.view.addGestureRecognizer(rotation)
        
        // Do any additional setup after loading the view.
    }
    override func configureCell(cell: UITableViewCell!, atIndexPath path: NSIndexPath!, forData data: AnyObject!, inTableView tableView: UITableView!) {
        let team = data as! Team
        let multiCell = cell as! MultiCellTableViewCell
        multiCell.rankLabel!.text = String(path.row + 1)
        multiCell.teamLabel!.text = String(team.number!)
        if translatedKeyPath.rangeOfString("calculatedData") != nil {
            let propPath = translatedKeyPath.stringByReplacingOccurrencesOfString("calculatedData.", withString: "")
            if let value = team.calculatedData!.valueForKeyPath(propPath) {
                multiCell.scoreLabel!.text = roundValue(value, toDecimalPlaces: 2)
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
        return self.shouldReverseRank ? self.firebaseFetcher.getSortedListbyString(translatedKeyPath).reverse() : self.firebaseFetcher.getSortedListbyString(translatedKeyPath)
    }
    
    override func filteredArrayForSearchText(text: String!, inScope scope: Int) -> [AnyObject]! {
        return self.dataArray.filter { String(($0 as! Team).number).containsString(text) }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("sortRankToTeam", sender: tableView.cellForRowAtIndexPath(indexPath))
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let dest = segue.destinationViewController as? TeamDetailsTableViewController {
            let multiCell = sender as? MultiCellTableViewCell
            dest.team = firebaseFetcher.getTeam(Int(multiCell!.teamLabel!.text!)!)
        }
    }
    
    func rotationDetected(recognizer: UIRotationGestureRecognizer) {
        let rot = recognizer.rotation
        let layer = self.tableView.layer
        var transform = CGAffineTransformMakeScale(1.0, 1.0)
        transform = CGAffineTransformRotate(transform, rot)
        
        switch recognizer.state {
            
        case .Began :
            layer.opaque = false
            UIView.animateWithDuration(0.2, delay: 0, options: UIViewAnimationOptions.AllowUserInteraction, animations: {
                layer.setAffineTransform(transform)
                layer.opacity = 0.8
                }, completion: nil)
            
        case .Changed : layer.setAffineTransform(transform)
            
        case .Ended :
            let shouldRotate = cos(rot) < 0
            if shouldRotate {
                UIView.animateWithDuration(0.1, delay: 0, options: UIViewAnimationOptions.AllowUserInteraction, animations: {
                    layer.opacity = 0.0
                    }, completion: { c in
                        layer.setAffineTransform(CGAffineTransformIdentity)
                        UIView.animateWithDuration(0.1, animations: {
                            layer.opacity = 1.0
                            }, completion: { d in
                                
                                if shouldRotate {
                                    self.shouldReverseRank = !self.shouldReverseRank
                                    self.dataArray = self.dataArray.reverse()
                                    //self.filteredArray = self.filteredArray.reverse()
                                    self.loadDataArray(true)
                                    self.tableView.reloadData()
                                    self.tableView.setNeedsDisplay()
                                }
                        })
                })
            }
            
        default:
            UIView.animateWithDuration(0.2) {
                layer.opacity = 1.0
                layer.setAffineTransform(CGAffineTransformIdentity)
            }
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
