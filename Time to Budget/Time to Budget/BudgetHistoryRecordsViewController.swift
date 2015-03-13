//
//  BudgetHistoryRecordsViewController.swift
//  Time to Budget
//
//  Created by Robert Kennedy on 3/12/15.
//  Copyright (c) 2015 Arrken Games, LLC. All rights reserved.
//

import UIKit
import Realm

class BudgetHistoryRecordsViewController: UITableViewController {
    
    var currentTask:Task?
    var notificationToken: RLMNotificationToken?

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        self.tableView.reloadData()
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let indexPath = self.tableView.indexPathForSelectedRow()!
        
        if segue.identifier == "showHistoryRecord" {
            let historyRecordVC = segue.destinationViewController as BudgetHistoryRecordViewController
            historyRecordVC.currentRecord = (currentTask!.records[UInt(indexPath.row)] as Record)
            historyRecordVC.currentTask = self.currentTask!
        }
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Int(currentTask!.records.count)
    }

    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return Factory.prepareRecordCell(tableView: self.tableView, recordList: currentTask!.records, indexPath: indexPath)
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("showHistoryRecord", sender: self)
    }
}
