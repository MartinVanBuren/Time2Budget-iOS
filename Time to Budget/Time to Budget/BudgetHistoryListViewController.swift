//
//  BudgetHistoryViewController.swift
//  Time to Budget
//
//  Created by Robert Kennedy on 3/12/15.
//  Copyright (c) 2015 Arrken Games, LLC. All rights reserved.
//

import UIKit
import Realm

class BudgetHistoryListViewController: UITableViewController {
    
    //==================== Realm Properties ====================
    let realm = Database.getRealm()
    var budgetList = Budget.objectsWhere("isCurrent = FALSE").sortedResultsUsingProperty("endDate", ascending: false)
    var notificationToken: RLMNotificationToken?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set realm notification block
        notificationToken = RLMRealm.defaultRealm().addNotificationBlock { note, realm in
            self.tableView.reloadData()
            //self.budgetList = Budget.objectsWhere("isCurrent = FALSE").sortedResultsUsingProperty("endDate", ascending: false)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showHistoryBudget" {
            let historyBudgetVC = segue.destinationViewController as BudgetHistoryViewController
            let indexPath = self.tableView.indexPathForSelectedRow()!
            historyBudgetVC.currentBudget = (self.budgetList[UInt(indexPath.row)] as Budget)
        }
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Int(self.budgetList.count)
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return Factory.prepareBasicCell(tableView: self.tableView, titleText: (self.budgetList[UInt(indexPath.row)] as Budget).name)
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("showHistoryBudget", sender: self)
    }

    


}
