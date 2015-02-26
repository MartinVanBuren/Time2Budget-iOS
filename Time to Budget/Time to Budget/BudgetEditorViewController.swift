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
    var returning:Bool? = false
    var addTaskDialog:Bool = false
    var notificationToken: RLMNotificationToken?
    
    //==================== Realm Properties ====================
    let realm = Database.getRealm()
    var categoryList = Category.allObjects()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set realm notification block
        notificationToken = RLMRealm.defaultRealm().addNotificationBlock { note, realm in
            self.tableView.reloadData()
            self.updateTimeRemaining()
        }
        
        if let unwrappedReturning = returning? {
            if !unwrappedReturning {
                self.tableView.reloadData()
                self.updateTimeRemaining()
            }
        }
        
    }
    
    override func viewWillAppear(animated: Bool) {
        fixContentInset(calledFromSegue: false)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //==================== Segue Preperation ====================
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showTaskEditorView" {
            let taskEditorVC:TaskEditorViewController = segue.destinationViewController as TaskEditorViewController
            taskEditorVC.budgetEditorViewController = self
            
            if (!addTaskDialog) {
                let indexPath = self.tableView.indexPathForSelectedRow()!
                let thisTask = ((categoryList.objectAtIndex(UInt(indexPath.section)) as Category).tasks.objectAtIndex(UInt(indexPath.row))) as Task
                let thisCategory = (categoryList.objectAtIndex(UInt(indexPath.section)) as Category)
                taskEditorVC.currentTask = thisTask
                taskEditorVC.currentCategory = thisCategory
            }
            
            fixContentInset(calledFromSegue: true)
        }
        
        if segue.identifier == "showTrackingView" {
            let trackingVC:AddRecordViewController = segue.destinationViewController as AddRecordViewController
        }
    }
    
    //==================== UITableViewDataSource Methods ====================
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return Int(categoryList.count)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return Int((categoryList.objectAtIndex(UInt(section)) as Category).tasks.count)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        return Factory.prepareTaskCell(tableView: tableView, categoryList: categoryList, indexPath: indexPath, isEditor: true)
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        return Factory.prepareCategoryCell(tableView: tableView, categoryList: categoryList, section: section, isEditor: true)
        
    }
    
    //==================== UITableViewDelegate Methods ====================
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        performSegueWithIdentifier("showTaskEditorView", sender: self)
        
    }
    
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 44
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        Factory.displayDeleteTaskAlert(viewController: self, indexPath: indexPath)
    }

    //==================== IB Actions ====================
    @IBAction func addTaskButtonPressed(sender: UIButton) {
        addTaskDialog = true
        performSegueWithIdentifier("showTaskEditorView", sender: sender)
    }
    
    @IBAction func addCategoryButtonPressed(sender: UIButton) {
        
        Factory.displayAddCategoryAlert(self)
    }
    
    @IBAction func deleteCategoryButtonPressed(sender: UIButton) {
        
        let cell = sender.superview?.superview as CategoryCell

        Factory.displayDeleteCategoryAlert(viewController: self, categoryName: cell.sectionNameLabel.text!)
    }
    
    
    //==================== Helper Methods ====================
    func updateTimeRemaining() {
        let taskList = Task.allObjects()
        var tempTime = Time()
        let newTime = Time.doubleToTime(168.0)
        
        for var i:UInt = 0; i < taskList.count; i++ {
            tempTime = Time.doubleToTime((taskList.objectAtIndex(i) as Task).timeRemaining)
            newTime.hours -= tempTime.hours
            newTime.minutes -= tempTime.minutes
        }
        
        newTime.cleanTime()
        
        self.totalTime = newTime
        self.navigationItem.title = self.totalTime.toString()
    }
    
    func fixContentInset(#calledFromSegue: Bool) {
        if calledFromSegue {
            if (returning != nil) {
                self.returning = true
            }
        } else {
            if (returning != nil) {
                if !returning! {
                    self.tableView.contentInset.top = 64
                }
                else if returning! {
                    self.tableView.contentInset.top -= 64
                    self.returning = nil
                }
            }
            else {
                
            }
        }
    }
}