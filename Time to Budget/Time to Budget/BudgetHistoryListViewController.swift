//
//  BudgetHistoryViewController.swift
//  Time to Budget
//
//  Created by Robert Kennedy on 3/12/15.
//  Copyright (c) 2015 Arrken Games, LLC. All rights reserved.
//

import UIKit
import RealmSwift

class BudgetHistoryListViewController: UITableViewController {
    
    var realm:Realm!
    var budgetList:Results<Budget>!
    var notificationToken: NotificationToken?

    override func viewDidLoad() {
        //==================== Realm Properties ====================
        self.realm = try! Realm()
        self.budgetList = realm.objects(Budget).filter("isCurrent = FALSE").sorted("endDate", ascending: false)
        
        super.viewDidLoad()
        
        let nav = self.navigationController?.navigationBar
        Style.navbarSetColor(nav: nav!)
        
        // Set realm notification block
        notificationToken = realm.addNotificationBlock { note, realm in
            self.tableView.reloadData()
            //self.budgetList = Budget.objectsWhere("isCurrent = FALSE").sortedResultsUsingProperty("endDate", ascending: false)
        }
    }
    
    override func viewDidLayoutSubviews() {
        if let rect = self.navigationController?.navigationBar.frame {
            let y = rect.size.height + rect.origin.y
            self.tableView.contentInset = UIEdgeInsetsMake(y, 0, 0, 0)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showHistoryBudget" {
            let historyBudgetVC = segue.destinationViewController as! BudgetHistoryViewController
            let indexPath = self.tableView.indexPathForSelectedRow!
            historyBudgetVC.currentBudget = self.budgetList[indexPath.row]
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
        return Factory.prepareBasicCell(tableView: self.tableView, titleText: self.budgetList[indexPath.row].name)
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("showHistoryBudget", sender: self)
    }

    


}
