//
//  BudgetHistoryListViewController.swift
//  Time to Budget
//
//  Created by Robert Kennedy on 3/12/15.
//  Copyright (c) 2015 Arrken Games, LLC. All rights reserved.
//

import UIKit
import Realm

class BudgetHistoryViewController: UITableViewController {
    
    var currentBudget:Budget?
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
        
        if segue.identifier == "showHistoryRecords" {
            let historyRecordsVC = segue.destinationViewController as BudgetHistoryRecordsViewController
            historyRecordsVC.currentTask = ((currentBudget?.categories[UInt(indexPath.section)] as Category).tasks[UInt(indexPath.row)] as Task)
        }
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return Int(currentBudget!.categories.count)
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Int((currentBudget!.categories.objectAtIndex(UInt(section)) as Category).tasks.count)
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return Factory.prepareTaskCell(tableView: tableView, categoryList: currentBudget!.categories, indexPath: indexPath, isEditor: false)
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return Factory.prepareCategoryCell(tableView: tableView, categoryList: currentBudget!.categories, section: section, isEditor: false)
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("showHistoryRecords", sender: self)
    }

}
