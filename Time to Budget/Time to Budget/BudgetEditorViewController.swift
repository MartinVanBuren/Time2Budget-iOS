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
    
    var totalTime = Time(newHours: 168, newMinutes: 0)
    var addTaskDialog:Bool = false
    var notificationToken: NotificationToken!
    @IBOutlet weak var tableView: UITableView!
    
    //==================== Realm Properties ====================
    var realm:Realm!
    var currentBudget:Budget!
    var grabbedTask:Task?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Get database access
        self.realm = Database.getRealm()
        
        // Retrieve and register the nib files for tableView elements.
        var nib = UINib(nibName: "CategoryView", bundle: nil)
        self.tableView.registerNib(nib, forHeaderFooterViewReuseIdentifier: "CategoryView")
        
        nib = UINib(nibName: "DetailCell", bundle: nil)
        self.tableView.registerNib(nib, forCellReuseIdentifier: "DetailCell")
        
        nib = UINib(nibName: "SubtitleDetailCell", bundle: nil)
        self.tableView.registerNib(nib, forCellReuseIdentifier: "SubtitleDetailCell")
        
        // Generate and subscribe a long press gesture recognizer for dragging and dropping tableView elements.
        let longpress = UILongPressGestureRecognizer(target: self, action: "longPressGestureRecognized:")
        tableView.addGestureRecognizer(longpress)
        
        // Apply app style to the controller and tableView
        let nav = self.navigationController?.navigationBar
        Style.navbar(nav!)
        Style.viewController(self, tableView: self.tableView)
        
        // Retrieve the current budget from the database
        self.currentBudget = Database.budgetSafetyNet()
        
        // Register realm notification block to update the tableView on database changes
        notificationToken = realm.addNotificationBlock { note, realm in
            self.currentBudget = Database.budgetSafetyNet()
            self.updateTimeRemaining()
        }

        // Reload tableView data and update the current budgetable time remaining label
        self.tableView.reloadData()
        self.updateTimeRemaining()
    }
    
    override func viewWillAppear(animated: Bool) {
        // Retrieve up-to-date budget and apply to tableView
        self.currentBudget = Database.budgetSafetyNet()
        self.tableView.reloadData()
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
        return Factory.prepareTaskCell(tableView: tableView, categoryList: currentBudget!.categories, indexPath: indexPath, editor: true)
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return Factory.prepareCategoryView(tableView: tableView, categoryList: currentBudget.categories, section: section, editorViewController: self)
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

    //==================== Actions ====================
    @IBAction func addTaskButtonPressed(sender: UIBarButtonItem) {
        addTaskDialog = true
        performSegueWithIdentifier("showTaskEditorView", sender: sender)
    }
    
    @IBAction func addCategoryButtonPressed(sender: UIBarButtonItem) {
        Factory.displayAddCategoryAlert(viewController: self)
    }
    
    func longPressGestureRecognized(gestureRecognizer: UIGestureRecognizer) {
        let longPress = gestureRecognizer
        let state = longPress.state
        let locationInView = longPress.locationInView(tableView)
        let indexPath = tableView.indexPathForRowAtPoint(locationInView)
        
        struct My {
            static var cellSnapshot : UIView? = nil
        }
        struct Path {
            static var initialIndexPath : NSIndexPath? = nil
        }
        
        switch state {
        case UIGestureRecognizerState.Began:
            if indexPath != nil {
                Path.initialIndexPath = indexPath
                let cell = tableView.cellForRowAtIndexPath(indexPath!) as UITableViewCell!
                self.grabbedTask = currentBudget.categories[indexPath!.section].tasks[indexPath!.row]
                My.cellSnapshot  = snapshotOfCell(cell)
                var center = cell.center
                My.cellSnapshot!.center = center
                My.cellSnapshot!.alpha = 0.0
                
                tableView.addSubview(My.cellSnapshot!)
                
                UIView.animateWithDuration(0.25, animations: { () -> Void in
                    center.y = locationInView.y
                    My.cellSnapshot!.center = center
                    My.cellSnapshot!.transform = CGAffineTransformMakeScale(1.05, 1.05)
                    My.cellSnapshot!.alpha = 0.98
                    cell.alpha = 0.0
                    
                    }, completion: { (finished) -> Void in
                        if finished {
                            cell.hidden = true
                        }
                })
            }
        case UIGestureRecognizerState.Changed:
            var center = My.cellSnapshot!.center
            center.y = locationInView.y
            My.cellSnapshot!.center = center
            if ((indexPath != nil) && (indexPath != Path.initialIndexPath)) {
                if let unwrappedTask = self.grabbedTask {
                    let targetCategory = self.currentBudget.categories[indexPath!.section]
                    if targetCategory.name != unwrappedTask.parent.name {
                        Database.moveTask(task: self.grabbedTask!, targetCategory: targetCategory, index: indexPath!.row)
                    } else {
                        Database.moveTask(task: self.grabbedTask!, index: indexPath!.row)
                    }
                }
                tableView.moveRowAtIndexPath(Path.initialIndexPath!, toIndexPath: indexPath!)
                Path.initialIndexPath = indexPath
            }
        default:
            self.grabbedTask = nil
            let cell = tableView.cellForRowAtIndexPath(Path.initialIndexPath!) as UITableViewCell!
            cell.hidden = false
            cell.alpha = 0.0
            UIView.animateWithDuration(0.25, animations: { () -> Void in
                My.cellSnapshot!.center = cell.center
                My.cellSnapshot!.transform = CGAffineTransformIdentity
                My.cellSnapshot!.alpha = 0.0
                cell.alpha = 1.0
                }, completion: { (finished) -> Void in
                    if finished {
                        Path.initialIndexPath = nil
                        My.cellSnapshot!.removeFromSuperview()
                        My.cellSnapshot = nil
                    }
            })
            tableView.reloadData()
        }
    }
    
    func snapshotOfCell(inputView: UIView) -> UIView {
        UIGraphicsBeginImageContextWithOptions(inputView.bounds.size, false, 0.0)
        inputView.layer.renderInContext(UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext() as UIImage
        UIGraphicsEndImageContext()
        let cellSnapshot : UIView = UIImageView(image: image)
        cellSnapshot.layer.masksToBounds = false
        cellSnapshot.layer.cornerRadius = 0.0
        cellSnapshot.layer.shadowOffset = CGSizeMake(-5.0, 0.0)
        cellSnapshot.layer.shadowRadius = 5.0
        cellSnapshot.layer.shadowOpacity = 0.4
        return cellSnapshot
    }
    
    //==================== Helper Methods ====================
    func updateTimeRemaining() {
        var taskList:[Time] = []
        let newTime = Time(newTime: 168.0)
        
        
        for var i = 0; i < self.currentBudget?.categories.count; i++ {
            let currentCategory = currentBudget?.categories[i]
            for var x = 0; x < currentCategory!.tasks.count; x++ {
                let currentTask = currentCategory!.tasks[x]
                taskList.append(Time(newTime: currentTask.timeBudgeted))
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