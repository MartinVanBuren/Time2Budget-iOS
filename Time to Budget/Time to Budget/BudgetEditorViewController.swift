//
//  BudgetEditorViewController.swift
//  Time to Budget
//
//  Created by Robert Kennedy on 1/23/15.
//  Copyright (c) 2015 Arrken Games, LLC. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

class BudgetEditorViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var totalTime = Time(newHours: 168, newMinutes: 0)
    var addTaskDialog:Bool = false
    var notificationToken: NotificationToken?
    
    //==================== Realm Properties ====================
    let realm = try! Realm()
    var currentBudget:Budget!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.currentBudget = realm.objects(Budget).filter("isCurrent = TRUE").first!
        
        // Set realm notification block
        notificationToken = realm.addNotificationBlock { note, realm in
            
            if realm.objects(Budget).filter("isCurrent = TRUE").count > 0 {
                self.currentBudget = realm.objects(Budget).filter("isCurrent = TRUE").first!
            } else {
                try! Database.newBudget()
                self.currentBudget = realm.objects(Budget).filter("isCurrent = TRUE").first!
            }
            
            self.currentBudget = realm.objects(Budget).filter("isCurrent = TRUE").first!
            
            self.tableView.reloadData()
            self.updateTimeRemaining()
        }

        self.tableView.reloadData()
        self.updateTimeRemaining()
        
    }
    
    override func viewDidLayoutSubviews() {
        if let rect = self.navigationController?.navigationBar.frame {
            let y = rect.size.height + rect.origin.y
            self.tableView.contentInset = UIEdgeInsetsMake(y, 0, 0, 0)
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        
        let nav = self.navigationController?.navigationBar
        Style.navbarSetColor(nav: nav!)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //==================== Segue Preperation ====================
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showTaskEditorView" {
            let taskEditorVC:TaskEditorViewController = (segue.destinationViewController as! UINavigationController).topViewController as! TaskEditorViewController
            taskEditorVC.budgetEditorViewController = self
            
            if (!addTaskDialog) {
                let indexPath = self.tableView.indexPathForSelectedRow!
                let thisTask = currentBudget.categories[indexPath.section].tasks[indexPath.row]
                taskEditorVC.currentTask = thisTask
                taskEditorVC.editTask = true
                tableView.deselectRowAtIndexPath(indexPath, animated: true)
            }
        }
        
    }
    
    //==================== UITableViewDataSource Methods ====================
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return Int(currentBudget!.categories.count)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return currentBudget.categories[section].tasks.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        return Factory.prepareTaskCell(tableView: tableView, categoryList: currentBudget!.categories, indexPath: indexPath, isEditor: true)
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        return Factory.prepareCategoryCell(tableView: tableView, categoryList: currentBudget!.categories, section: section, isEditor: true)
        
    }
    
    //==================== UITableViewDelegate Methods ====================
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        addTaskDialog = false
        performSegueWithIdentifier("showTaskEditorView", sender: self)
    }
    
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 44
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        try! Factory.displayDeleteTaskAlert(viewController: self, indexPath: indexPath)
    }

    //==================== IB Actions ====================
    @IBAction func addTaskButtonPressed(sender: UIBarButtonItem) {
        addTaskDialog = true
        performSegueWithIdentifier("showTaskEditorView", sender: sender)
    }
    
    @IBAction func addCategoryButtonPressed(sender: UIBarButtonItem) {
        Factory.displayAddCategoryAlert(viewController: self)
    }
    
    @IBAction func editCategoryButtonPressed(sender: UIButton) {
        
        let cell = sender.superview?.superview as! CategoryCell

        try! Factory.displayEditCategoryAlert(viewController: self, categoryName: cell.sectionNameLabel.text!)
    }
    
    
    //==================== Helper Methods ====================
    func updateTimeRemaining() {
        var taskList:[Time] = []
        let newTime = Time.doubleToTime(168.0)
        
        for var i = 0; i < self.currentBudget?.categories.count; i++ {
            let currentCategory = currentBudget?.categories[i]
            for var x = 0; x < currentCategory!.tasks.count; x++ {
                let currentTask = currentCategory!.tasks[x]
                taskList.append(Time.doubleToTime(currentTask.timeBudgeted))
            }
        }
        
        for var i = 0; i < taskList.count; i++ {
            newTime.hours -= taskList[i].hours
            newTime.minutes -= taskList[i].minutes
        }
        
        newTime.cleanTime()
        
        self.totalTime = newTime
        self.navigationItem.title = self.totalTime.toString()
    }
    
}