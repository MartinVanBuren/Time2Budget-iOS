//
//  TaskEditorCategorySelectorViewController.swift
//  Time to Budget
//
//  Created by Robert Kennedy on 3/1/15.
//  Copyright (c) 2015 Arrken Games, LLC. All rights reserved.
//

import UIKit
import RealmSwift

class TaskEditorCategorySelectorViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    //========== View Properties ==========
    var taskEditorVC:TaskEditorViewController!
    var delegate: writeCategoryBackDelegate?
    var returning:Bool? = false
    @IBOutlet weak var tableView: UITableView!
    
    //========== Realm Properties ==========
    var realm:Realm!
    var currentBudget:Budget!
    var notificationToken:NotificationToken!
    
    //==================== View Controller Methods ====================
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Register nibs for Cells/Headers
        let catCellNib = UINib(nibName: "CategoryCell", bundle: nil)
        self.tableView.registerNib(catCellNib, forCellReuseIdentifier: "CategoryCell")
        
        // Apply Time to Budget theme to this view and table view.
        Style.viewController(self, tableView: self.tableView)
        
        // Retrieve database and current budget.
        self.realm = Database.getRealm()
        self.currentBudget = realm.objects(Budget).filter("isCurrent = TRUE").first!
        
        // Create realm notification token to update this table view on databse changes.
        notificationToken = realm.addNotificationBlock { notification, realm in
            self.currentBudget = Database.budgetSafetyNet()
            self.tableView.reloadData()
        }
        
        self.tableView.reloadData()
    }
    
    override func viewDidLayoutSubviews() {
        // Adjust table view content insets
        self.automaticallyAdjustsScrollViewInsets = false
        tableView.contentInset = UIEdgeInsetsMake(self.topLayoutGuide.length, 0, 54, 0)
        tableView.reloadData()
    }
    
    //==================== UITableViewDataSource Methods ====================
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Int(currentBudget.categories.count)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return Factory.prepareCategoryCell(tableView: self.tableView, categoryList: currentBudget.categories, section: indexPath.row)
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UITableViewCell()
    }
    
    //==================== UITableViewDelegate Methods ====================
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // Pass the category selected back to the Task Editor view and then return to previous view.
        self.delegate?.writeCategoryBack(currentBudget.categories[indexPath.row])
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    //==================== IBAction Methods ====================
    @IBAction func addCategoryButtonPressed(sender: UIBarButtonItem) {
        Factory.displayAddCategoryAlert(viewController: self)
    }
}
