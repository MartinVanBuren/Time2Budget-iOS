//
//  BudgetHistoryListViewController.swift
//  Time to Budget
//
//  Created by Robert Kennedy on 3/12/15.
//  Copyright (c) 2015 Arrken Games, LLC. All rights reserved.
//

import UIKit
import RealmSwift

class BudgetHistoryViewController: UITableViewController {
    
    var currentBudget:Budget?
    //var notificationToken: RLMNotificationToken?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        var nib = UINib(nibName: "CategoryView", bundle: nil)
        self.tableView.registerNib(nib, forHeaderFooterViewReuseIdentifier: "CategoryView")
        
        nib = UINib(nibName: "DetailCell", bundle: nil)
        self.tableView.registerNib(nib, forCellReuseIdentifier: "DetailCell")

        nib = UINib(nibName: "SubtitleDetailCell", bundle: nil)
        self.tableView.registerNib(nib, forCellReuseIdentifier: "SubtitleDetailCell")
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
    
    override func viewWillAppear(animated: Bool) {
        self.tableView.reloadData()
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let indexPath = self.tableView.indexPathForSelectedRow!
        
        if segue.identifier == "showHistoryRecords" {
            let historyRecordsVC = segue.destinationViewController as! BudgetHistoryRecordsViewController
            historyRecordsVC.currentTask = currentBudget?.categories[indexPath.section].tasks[indexPath.row]
        }
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return Int(currentBudget!.categories.count)
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentBudget!.categories[section].tasks.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return Factory.prepareTaskCell(tableView: tableView, categoryList: currentBudget!.categories, indexPath: indexPath, editor: false)
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return Factory.prepareCategoryView(tableView: tableView, categoryList: currentBudget!.categories, section: section)
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("showHistoryRecords", sender: self)
    }

}
