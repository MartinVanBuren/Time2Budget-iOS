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
    
    // ======== Realm Properties =========
    var currentBudget: Budget?

    // ================ View Controller Methods ================
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Retrieve and register the nib files for tableView elements.
        let catViewNib = UINib(nibName: "CategoryView", bundle: nil)
        let detailNib = UINib(nibName: "DetailCell", bundle: nil)
        let subtitleNib = UINib(nibName: "SubtitleDetailCell", bundle: nil)
        self.tableView.registerNib(catViewNib, forHeaderFooterViewReuseIdentifier: "CategoryView")
        self.tableView.registerNib(detailNib, forCellReuseIdentifier: "DetailCell")
        self.tableView.registerNib(subtitleNib, forCellReuseIdentifier: "SubtitleDetailCell")
        
        // Apply the Time to Budget theme to this view.
        Style.viewController(self)
    }
    
    override func viewDidLayoutSubviews() {
        // Adjust table view insets
        self.automaticallyAdjustsScrollViewInsets = false
        tableView.contentInset = UIEdgeInsetsMake(self.topLayoutGuide.length, 0, 54, 0)
    }
    
    override func viewWillAppear(animated: Bool) {
        self.tableView.reloadData()
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let indexPath = self.tableView.indexPathForSelectedRow!
        
        if segue.identifier == "showHistoryRecords" {
            // Pass the selected task into the Budget History Records View.
            let historyRecordsVC = segue.destinationViewController as? BudgetHistoryRecordsViewController
            historyRecordsVC?.currentTask = currentBudget?.categories[indexPath.section].tasks[indexPath.row]
        }
    }

    // ===================== UITableViewDataSource Methods =====================
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
    
    // ===================== UITableViewDelegate Methods =====================
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("showHistoryRecords", sender: self)
    }

}
