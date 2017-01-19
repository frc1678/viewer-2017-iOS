//
//  ConditionalSecondPickTableViewController.swift
//  scout-viewer-2016-iOS
//
//  Created by Bryton Moeller on 2/23/16.
//  Copyright © 2016 Citrus Circuits. All rights reserved.
//

import UIKit

class OverallSecondPickAbilityViewController: ArrayTableViewController {
    
    var teamNumber  = -1
    var team : Team!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector:#selector(OverallSecondPickAbilityViewController.reloadTableView), name:NSNotification.Name(rawValue: "updateLeftTable"), object:nil)
    }
    
    func reloadTableView(_ note: Notification) {
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.performSegue(withIdentifier: "TeamDetails", sender: tableView.cellForRow(at: indexPath))
    }
    override func configureCell(_ cell: UITableViewCell!, at path: IndexPath!, forData data: Any!, in tableView: UITableView!) {
        let multiCell = cell as? MultiCellTableViewCell
        let team = data as? Team
        if team!.number != nil {
            multiCell!.teamLabel!.text = String(team!.number)
        }
        if team!.calculatedData?.overallSecondPickAbility != nil {
            multiCell!.scoreLabel!.text = String(Utils.roundValue(Float(team!.calculatedData!.overallSecondPickAbility), toDecimalPlaces: 2)
            )
        } else {
            multiCell!.scoreLabel!.text = ""
        }
        multiCell!.rankLabel!.text = "\(self.firebaseFetcher.rankOfTeam(team!, withCharacteristic: "calculatedData.overallSecondPickAbility"))"
    }
   
    
    override func loadDataArray(_ shouldForce: Bool) -> [Any]! {
        return self.firebaseFetcher.getOverallSecondPickList()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dest = segue.destination as? TeamDetailsTableViewController {
            let selectedCell = sender as? MultiCellTableViewCell
            dest.team = firebaseFetcher.getTeam(Int((selectedCell?.teamLabel!.text)!)!)
        }
    }
    
    override func cellIdentifier() -> String! {
        return "MultiCellTableViewCell"
    }
    
    override func filteredArray(forSearchText text: String!, inScope scope: Int) -> [Any]! {
        return self.firebaseFetcher.filteredTeamsForSearchString(text)
    }
   
}
