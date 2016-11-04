//
//  NotesTableViewController.swift
//  scout-viewer-2015-iOS
//
//  Created by Bryton Moeller on 4/2/16.
//  Copyright © 2016 Citrus Circuits. All rights reserved.
//

import Foundation

class NotesTableViewController : UITableViewController {
    var data = [[String: String]]()
    
    override func viewDidLoad() {
        tableView.estimatedRowHeight = 200.0
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "NotesCell") as! ResizableNotesTableViewCell
        
        cell.titleLabel?.text = (data[(indexPath as NSIndexPath).row].keys as! [String])[0]
        cell.notesLabel?.text = (data[(indexPath as NSIndexPath).row].values as! [String])[0]
        
        return cell
    }
}
