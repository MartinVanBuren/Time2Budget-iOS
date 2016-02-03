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

    var realm:Realm!
    var currentBudget:Budget!
    var taskEditorVC:TaskEditorViewController!
    var delegate: writeCategoryBackDelegate?
    var notificationToken:NotificationToken!
    var returning:Bool? = false
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: "CategoryCell", bundle: nil)
        self.tableView.registerNib(nib, forCellReuseIdentifier: "CategoryCell")
        
        Style.viewController(self, tableView: self.tableView)
        
        self.realm = Database.getRealm()
        self.currentBudget = realm.objects(Budget).filter("isCurrent = TRUE").first!
        
        notificationToken = realm.addNotificationBlock { notification, realm in
            
            self.currentBudget = Database.budgetSafetyNet()
            
            self.tableView.reloadData()
        }
        
        self.tableView.reloadData()
    }
    
    override func viewDidLayoutSubviews() {
        self.automaticallyAdjustsScrollViewInsets = false
        tableView.contentInset = UIEdgeInsetsMake(self.topLayoutGuide.length, 0, 54, 0)
        tableView.reloadData()
    }
    
    //==================== UITableViewDataSource Methods ====================
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return Int(currentBudget.categories.count)
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let categoryCell = Factory.prepareCategoryCell(tableView: self.tableView, categoryList: currentBudget.categories, section: indexPath.row)
        
        return categoryCell
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        return UITableViewCell()
        
    }
    
    //==================== UITableViewDelegate Methods ====================
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.delegate?.writeCategoryBack(currentBudget.categories[indexPath.row])
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 0
    }

    @IBAction func addCategoryButtonPressed(sender: UIBarButtonItem) {
        Factory.displayAddCategoryAlert(viewController: self)
    }
    
}
