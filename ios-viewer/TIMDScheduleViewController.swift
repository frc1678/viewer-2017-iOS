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
    //get instance of Firebase Fetcher
    let firebaseFetcher = AppDelegate.getAppDelegate().firebaseFetcher
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //setting title
        self.title = "\(self.teamNumber)'s TIMDs"
        //get list of matches with this team in it
        matches = self.firebaseFetcher!.getMatchesForTeamWithNumber(self.teamNumber)
    }
    
    //when a row is sellected...
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //deselect the row
        tableView.deselectRow(at: indexPath, animated: true)
        //segue to the TIMD
        self.performSegue(withIdentifier: "TIMDDetails", sender: tableView.cellForRow(at: indexPath))
    }
    
    //gives info for a specific cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //gets cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        //gets match
        let match = matches[indexPath.row]
        if match.number != -1 {
            //Cell label: "Q#"
            cell.textLabel?.text = "Q\(String(describing: match.number))"
        }
        return cell
    }
    
    //sets values for a given cell
    func configureCell(_ cell: UITableViewCell!, at path: IndexPath!, forData data: Any!, in tableView: UITableView!) {
        let match = data as? Match
        if match?.number != nil {
            //set cell label to "Q##"
            cell.textLabel?.text = "Q\(String(describing: match!.number))"
        }
    }
    
    //when you click on a cell, this function is called. see tableView didSelectRowAt
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //if the segue is a TIMDTableViewController
        if let dest = segue.destination as? TIMDDetailsViewController {
            //get cell
            let selectedCell = sender as? UITableViewCell
            //Go to specific match, get rid of Qs, set TIMD
            dest.TIMD = firebaseFetcher?.getTIMDataForTeamInMatch((firebaseFetcher?.getTeam(self.teamNumber))!, inMatch: (firebaseFetcher?.getMatch(Int((selectedCell?.textLabel?.text?.replacingOccurrences(of: "Q", with: ""))!)!))!)
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return matches.count
    }
    
}
