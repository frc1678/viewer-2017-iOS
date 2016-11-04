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
    override func configureCell(_ cell: UITableViewCell!, at path: IndexPath!, forData data: Any!, in tableView: UITableView!) {
        let team = data as! Team
        let multiCell = cell as! MultiCellTableViewCell
        multiCell.rankLabel!.text = String(path.row + 1)
        multiCell.teamLabel!.text = String(describing: team.number!)
        if translatedKeyPath.range(of: "calculatedData") != nil {
            let propPath = translatedKeyPath.replacingOccurrences(of: "calculatedData.", with: "")
            if let value = team.calculatedData!.value(forKeyPath: propPath) {
                multiCell.scoreLabel!.text = roundValue(value as AnyObject?, toDecimalPlaces: 2)
            }
        } else {
            multiCell.scoreLabel!.text = roundValue(team.value(forKeyPath: translatedKeyPath) as AnyObject?, toDecimalPlaces: 2)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func loadDataArray(_ shouldForce: Bool) -> [Any]! {
        return self.shouldReverseRank ? self.firebaseFetcher.getSortedListbyString(translatedKeyPath).reversed() : self.firebaseFetcher.getSortedListbyString(translatedKeyPath)
    }
    
    override func filteredArray(forSearchText text: String!, inScope scope: Int) -> [Any]! {
        return self.dataArray.filter { String(describing: ($0 as! Team).number).contains(text) }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "sortRankToTeam", sender: tableView.cellForRow(at: indexPath))
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dest = segue.destination as? TeamDetailsTableViewController {
            let multiCell = sender as? MultiCellTableViewCell
            dest.team = firebaseFetcher.getTeam(Int(multiCell!.teamLabel!.text!)!)
        }
    }
    
    func rotationDetected(_ recognizer: UIRotationGestureRecognizer) {
        let rot = recognizer.rotation
        let layer = self.tableView.layer
        var transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        transform = transform.rotated(by: rot)
        
        switch recognizer.state {
            
        case .began :
            layer.isOpaque = false
            UIView.animate(withDuration: 0.2, delay: 0, options: UIViewAnimationOptions.allowUserInteraction, animations: {
                layer.setAffineTransform(transform)
                layer.opacity = 0.8
                }, completion: nil)
            
        case .changed : layer.setAffineTransform(transform)
            
        case .ended :
            let shouldRotate = cos(rot) < 0
            if shouldRotate {
                UIView.animate(withDuration: 0.1, delay: 0, options: UIViewAnimationOptions.allowUserInteraction, animations: {
                    layer.opacity = 0.0
                    }, completion: { c in
                        layer.setAffineTransform(CGAffineTransform.identity)
                        UIView.animate(withDuration: 0.1, animations: {
                            layer.opacity = 1.0
                            }, completion: { d in
                                
                                if shouldRotate {
                                    self.shouldReverseRank = !self.shouldReverseRank
                                    self.dataArray = self.dataArray.reversed()
                                    //self.filteredArray = self.filteredArray.reverse()
                                    self.loadDataArray(true)
                                    self.tableView.reloadData()
                                    self.tableView.setNeedsDisplay()
                                }
                        })
                })
            }
            
        default:
            UIView.animate(withDuration: 0.2, animations: {
                layer.opacity = 1.0
                layer.setAffineTransform(CGAffineTransform.identity)
            }) 
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
