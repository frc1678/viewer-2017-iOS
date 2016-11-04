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
        NotificationCenter.default.addObserver(self, selector:#selector(ConditionalSecondPickTableViewController.reloadTableView), name:NSNotification.Name(rawValue: "updateLeftTable"), object:nil)
    }
    func reloadTableView(_ note: Notification) {
        tableView.reloadData()
    }

    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "secondPickToTeam", sender: tableView.cellForRow(at: indexPath))
    }
    
    override func configureCell(_ cell: UITableViewCell!, at path: IndexPath!, forData data: Any!, in tableView: UITableView!) {
        let multiCell = cell as? MultiCellTableViewCell
        let team = data as? Team
        if team!.number != nil {
            multiCell!.teamLabel!.text = String(team!.number!.intValue)
        }
        if team!.calculatedData?.firstPickAbility != nil {
            multiCell!.scoreLabel!.text = String(team!.calculatedData!.firstPickAbility!.intValue)
        } else {
            multiCell!.scoreLabel!.text = ""
        }
        multiCell!.rankLabel!.text = "\(self.secondPickListRanks[team!.number! as Int]!)"
    }
    
    override func loadDataArray(_ shouldForce: Bool) -> [Any]! {
        let picks = self.firebaseFetcher.getConditionalSecondPickList(teamNumber)
        for pick in picks {
            self.secondPickListRanks[pick.number as! Int] = (picks.index(of: pick)! + 1)
        }
        return self.firebaseFetcher.getConditionalSecondPickList(teamNumber)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dest = segue.destination as? TeamDetailsTableViewController {
            let cell = sender as? MultiCellTableViewCell
            let team = firebaseFetcher.getTeam(Int((cell?.teamLabel!.text)!)!)
            dest.team = team;
        }
    }
    
    override func cellIdentifier() -> String! {
        return "MultiCellTableViewCell"
    }
    
    override func filteredArray(forSearchText searchString: String!, inScope scope: Int) -> [Any]! {
        return self.dataArray.filter { String(describing: ($0 as! Team).number).range(of: searchString) != nil }
    }
}
