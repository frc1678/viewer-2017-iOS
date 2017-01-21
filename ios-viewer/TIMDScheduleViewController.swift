//
//  TIMDScheduleViewController.swift
//  ios-viewer
//
//  Created by Carter Luck on 1/16/17.
//  Copyright © 2017 brytonmoeller. All rights reserved.
//

import Foundation

class TIMDScheduleViewController: UITableViewController {
    var teamNumber : Int = -1
    var team : Team!
    var matches : [Match] = []
    let firebaseFetcher = AppDelegate.getAppDelegate().firebaseFetcher
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "\(self.teamNumber)'s TIMDs"
        matches = self.firebaseFetcher!.getMatchesForTeamWithNumber(self.teamNumber)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.performSegue(withIdentifier: "TIMDDetails", sender: tableView.cellForRow(at: indexPath))
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let match = matches[indexPath.row]
        if match.number != -1 {
            cell.textLabel?.text = "Q\(String(describing: match.number))"
        }
        return cell
    }
    
    func configureCell(_ cell: UITableViewCell!, at path: IndexPath!, forData data: Any!, in tableView: UITableView!) {
        let match = data as? Match
        if match?.number != nil {
            cell.textLabel?.text = "Q\(String(describing: match!.number))"
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dest = segue.destination as? TIMDDetailsViewController {
            let selectedCell = sender as? UITableViewCell
            dest.TIMD = firebaseFetcher?.getTimDataForTeamInMatch((firebaseFetcher?.getTeam(self.teamNumber))!, inMatch: (firebaseFetcher?.getMatch(Int((selectedCell?.textLabel?.text?.replacingOccurrences(of: "Q", with: ""))!)!))!)
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return matches.count
    }
    
}
