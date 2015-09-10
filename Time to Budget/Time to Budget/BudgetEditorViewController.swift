//
//  BudgetEditorViewController.swift
//  Time to Budget
//
//  Created by Robert Kennedy on 1/23/15.
//  Copyright (c) 2015 Arrken Games, LLC. All rights reserved.
//

import Foundation
import UIKit
import Realm

class BudgetEditorViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var totalTime = Time(newHours: 168, newMinutes: 0)
    var addTaskDialog:Bool = false
    var notificationToken: RLMNotificationToken?
    
    //==================== Realm Properties ====================
    let realm = Database.getRealm()
    var currentBudget:Budget?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.currentBudget = (Budget.objectsWhere("isCurrent = TRUE").firstObject() as! Budget)
        
        // Set realm notification block
        notificationToken = RLMRealm.defaultRealm().addNotificationBlock { note, realm in
            
            if Budget.objectsWhere("isCurrent = TRUE").count > 0 {
                self.currentBudget = (Budget.objectsWhere("isCurrent = TRUE").firstObject() as! Budget)
            } else {
                Database.newBudget()
                self.currentBudget = (Budget.objectsWhere("isCurrent = TRUE").firstObject() as! Budget)
            }
            
            self.tableView.reloadData()
            self.updateTimeRemaining()
        }

        self.tableView.reloadData()
        self.updateTimeRemaining()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        
        
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
                let indexPath = self.tableView.indexPathForSelectedRow()!
                let thisTask = ((currentBudget!.categories.objectAtIndex(UInt(indexPath.section)) as! Category).tasks.objectAtIndex(UInt(indexPath.row))) as! Task
                taskEditorVC.currentTask = thisTask
                taskEditorVC.editTask = true
            }
        }
    }
    
    //==================== UITableViewDataSource Methods ====================
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return Int(currentBudget!.categories.count)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return Int((currentBudget!.categories.objectAtIndex(UInt(section)) as! Category).tasks.count)
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
        
        Factory.displayDeleteTaskAlert(viewController: self, indexPath: indexPath)
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

        Factory.displayEditCategoryAlert(viewController: self, categoryName: cell.sectionNameLabel.text!)
    }
    
    
    //==================== Helper Methods ====================
    func updateTimeRemaining() {
        var taskList:[Time] = []
        let newTime = Time.doubleToTime(168.0)
        
<<<<<<< Updated upstream
        for var i:UInt = 0; i < self.currentBudget?.categories.count; i++ {
            let currentCategory = currentBudget?.categories[i] as Category
            for var x:UInt = 0; x < currentCategory.tasks.count; x++ {
                let currentTask = currentCategory.tasks[x] as Task
                taskList.append(Time.doubleToTime(currentTask.timeBudgeted))
            }
        }
        
        for var i = 0; i < taskList.count; i++ {
            newTime.hours -= taskList[i].hours
            newTime.minutes -= taskList[i].minutes
=======
        for var i:UInt = 0; i < taskList.count; i++ {
            tempTime = Time.doubleToTime((taskList.objectAtIndex(i) as! Task).timeBudgeted)
            newTime.hours -= tempTime.hours
            newTime.minutes -= tempTime.minutes
>>>>>>> Stashed changes
        }
        
        newTime.cleanTime()
        
        self.totalTime = newTime
        self.navigationItem.title = self.totalTime.toString()
    }
    
}