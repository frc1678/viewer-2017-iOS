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
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
   
    
   /* override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let attrs = [NSFontAttributeName : UIFont.systemFontOfSize(16)]
        let cell = self.tableView(self.tableView, cellForRowAtIndexPath: indexPath) as! ResizableNotesTableViewCell
        return (cell.notesLabel?.text ?? "" as NSString).sizeWithAttributes(attrs).height + (cell.titleLabel?.text ?? "" as NSString).sizeWithAttributes(attrs).height + 44
    }
    */
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("NotesCell") as! ResizableNotesTableViewCell
        
        cell.titleLabel?.text = Array(data[indexPath.row].keys)[0]
        cell.notesLabel?.text = Array(data[indexPath.row].values)[0]
        
        return cell
    }
}