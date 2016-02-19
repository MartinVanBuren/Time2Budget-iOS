//
//  BudgetEditorViewController.swift
//  Time to Budget
//
//  Created by Robert Kennedy on 1/23/15.
//  Copyright (c) 2015 Arrken Games, LLC. All rights reserved.
//

import UIKit
import RealmSwift
import Instructions

class BudgetEditorViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, CoachMarksControllerDataSource {
    
    //========== View Properties ==========
    var totalTime = Time(newHours: 168, newMinutes: 0)
    var addTaskDialog:Bool = false
    @IBOutlet weak var tableView: UITableView!
    let tutorialController = CoachMarksController()
    
    //========== Realm Properties ==========
    var realm:Realm!
    var currentBudget:Budget!
    var grabbedTask:Task?
    var notificationToken: NotificationToken!
    
    //==================== View Controller Methods ====================
    override func viewDidLoad() {
        super.viewDidLoad()
        // Tutorial setup and setting up points of interest
        tutorialController.datasource = self
        Style.tutorialController(self.tutorialController)
        
        // Retrieve database
        self.realm = Database.getRealm()
        
        // Retrieve and register the nib files for tableView elements.
        let catViewNib = UINib(nibName: "CategoryView", bundle: nil)
        let detailNib = UINib(nibName: "DetailCell", bundle: nil)
        let subtitleNib = UINib(nibName: "SubtitleDetailCell", bundle: nil)
        self.tableView.registerNib(catViewNib, forHeaderFooterViewReuseIdentifier: "CategoryView")
        self.tableView.registerNib(detailNib, forCellReuseIdentifier: "DetailCell")
        self.tableView.registerNib(subtitleNib, forCellReuseIdentifier: "SubtitleDetailCell")
        
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
    
    override func viewDidAppear(animated: Bool) {
        if Tutorial.shouldRun(budgetEditor: true) {
            self.tutorialController.startOn(self)
        }
    }
    
    override func viewDidLayoutSubviews() {
        // Setup tutorial points of interest.
        self.tableView.reloadData()
        Tutorial.budgetEditorPOI[0] = self.navigationController?.navigationBar
        Tutorial.budgetEditorPOI[1] = self.navigationController?.navigationBar
        Tutorial.budgetEditorPOI[2] = self.navigationController?.navigationBar
        Tutorial.budgetEditorPOI[3] = self.navigationController?.navigationBar
        Tutorial.budgetEditorPOI[4] = (self.navigationItem.leftBarButtonItem!.valueForKey("view") as! UIView)
        Tutorial.budgetEditorPOI[5] = (self.navigationItem.rightBarButtonItem!.valueForKey("view") as! UIView)
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showTaskEditorView" {
            // Pass the origin view into the Task Editor View
            let taskEditorVC:TaskEditorViewController = (segue.destinationViewController as! UINavigationController).topViewController as! TaskEditorViewController
            taskEditorVC.budgetEditorViewController = self
            
            if (!addTaskDialog) {
                // Pass the selected task into the Task Editor View for editing.
                let indexPath = self.tableView.indexPathForSelectedRow!
                let selectedTask = currentBudget.categories[indexPath.section].tasks[indexPath.row]
                taskEditorVC.currentTask = selectedTask
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
        let taskCell = Factory.prepareTaskCell(tableView: tableView, categoryList: currentBudget!.categories, indexPath: indexPath, editor: true)
        
        if(indexPath.section == 0 && indexPath.row == 0) {
            Tutorial.budgetEditorPOI[2] = taskCell
            Tutorial.budgetEditorPOI[3] = taskCell
        } else if (indexPath.section == 0 && indexPath.row == 1) {
            Tutorial.budgetEditorPOI[3] = taskCell
        }
        
        return taskCell
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = Factory.prepareCategoryView(tableView: tableView, categoryList: currentBudget.categories, section: section, editorViewController: self)
        
        if(section == 0) {
            Tutorial.budgetEditorPOI[1] = headerView
        }
        
        return headerView
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

    //==================== IBAction Methods ====================
    @IBAction func addTaskButtonPressed(sender: UIBarButtonItem) {
        addTaskDialog = true
        performSegueWithIdentifier("showTaskEditorView", sender: sender)
    }
    
    @IBAction func addCategoryButtonPressed(sender: UIBarButtonItem) {
        Factory.displayAddCategoryAlert(viewController: self)
    }
    
    //==================== CoachMarksDataSource Methods ====================
    func numberOfCoachMarksForCoachMarksController(coachMarksController: CoachMarksController) -> Int {
        return Tutorial.budgetEditorPOI.count
    }
    
    func coachMarksController(coachMarksController: CoachMarksController, coachMarksForIndex index: Int) -> CoachMark {
        return coachMarksController.coachMarkForView(Tutorial.budgetEditorPOI[index] as UIView!)
    }
    
    func coachMarksController(coachMarksController: CoachMarksController, coachMarkViewsForIndex index: Int, coachMark: CoachMark) -> (bodyView: CoachMarkBodyView, arrowView: CoachMarkArrowView?) {
        let coachViews = coachMarksController.defaultCoachViewsWithArrow(true, arrowOrientation: coachMark.arrowOrientation)
        
        coachViews.bodyView.hintLabel.text = Tutorial.getHintLabelForIndex(index, budgetEditor: true)
        coachViews.bodyView.nextLabel.text = Tutorial.getNextLabel()
        
        return (bodyView: coachViews.bodyView, arrowView: coachViews.arrowView)
        
    }
    
    //==================== Helper Methods ====================
    
    /**
    Handler for dragging and dropping Task cells in order that the user may rearrange their budget.
    
    This method handles long press gestures for Task cells but animating the cell and allowing it to 
    move up and down the table view, updating the database as the user drags.
    
    - Parameter None:
    - returns: Nothing
    */
    func longPressGestureRecognized(gestureRecognizer: UIGestureRecognizer) {
        // Retrieve information
        let longPress = gestureRecognizer
        let state = longPress.state
        let locationInView = longPress.locationInView(tableView)
        let indexPath = tableView.indexPathForRowAtPoint(locationInView)
        
        // Static variables for use in the gesture handler.
        struct My {
            static var cellSnapshot : UIView? = nil
        }
        struct Path {
            static var initialIndexPath : NSIndexPath? = nil
        }
        
        // Handler for the different states of the long press gesture.
        switch state {
        // Called when a cell is initially picked up.
        case UIGestureRecognizerState.Began:
            if indexPath != nil {
                Path.initialIndexPath = indexPath
                // Retrieve the cell, Task, and cell snapshot.
                let cell = tableView.cellForRowAtIndexPath(indexPath!) as UITableViewCell!
                self.grabbedTask = currentBudget.categories[indexPath!.section].tasks[indexPath!.row]
                My.cellSnapshot  = snapshotOfCell(cell)
                // Set snapshot cell location and make visible
                var center = cell.center
                My.cellSnapshot!.center = center
                My.cellSnapshot!.alpha = 0.0
                tableView.addSubview(My.cellSnapshot!)
                
                // Animate the cell 'lifting' from the table view.
                UIView.animateWithDuration(0.25, animations: { () -> Void in
                        center.y = locationInView.y
                        My.cellSnapshot!.center = center
                        My.cellSnapshot!.transform = CGAffineTransformMakeScale(1.05, 1.05)
                        My.cellSnapshot!.alpha = 0.98
                        cell.alpha = 0.0
                    }, completion: { (finished) -> Void in
                        if finished {
                            // Hide the cell that is underneith the snapshot.
                            cell.hidden = true
                        }
                })
            }
        // Called when the cell is dragged around the table view.
        case UIGestureRecognizerState.Changed:
            // Set snapshot cell location to long press location
            var center = My.cellSnapshot!.center
            center.y = locationInView.y
            My.cellSnapshot!.center = center
            
            if ((indexPath != nil) && (indexPath != Path.initialIndexPath)) {
                // Update the location of the 'grabbed' task in the database.
                if let unwrappedTask = self.grabbedTask {
                    let targetCategory = self.currentBudget.categories[indexPath!.section]
                    if targetCategory.name != unwrappedTask.parent.name {
                        Database.moveTask(task: self.grabbedTask!, targetCategory: targetCategory, index: indexPath!.row)
                    } else {
                        Database.moveTask(task: self.grabbedTask!, index: indexPath!.row)
                    }
                }
                // Animate the movement of the cell and the surrounding cells.
                tableView.moveRowAtIndexPath(Path.initialIndexPath!, toIndexPath: indexPath!)
                // Update the previous indexPath.
                Path.initialIndexPath = indexPath
            }
        // Called when the cell is let go of.
        default:
            // Unhide the cell that was underneith of the snapshot.
            self.grabbedTask = nil
            let cell = tableView.cellForRowAtIndexPath(Path.initialIndexPath!) as UITableViewCell!
            cell.hidden = false
            cell.alpha = 0.0
            
            // Animate the placement of the cell back into the table view.
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
            
            // Update all table view data to reflect the database changes.
            tableView.reloadData()
        }
    }
    
    /**
     Generates and returns a snapshot of the view passed into it.
     
     This method generates a snapshot of the view that is passed into it. This is used to
     simulate the dragging and dropping of table view cells.
     
     - Parameter inputView: The UIView of the input UITableViewCell.
     - returns: A snapshot of the input cell.
     */
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
    
    /**
     Updates the navigation bar title to relfect how much time is remaining in the weeks budget.
     
     This method calculates how much that can be spent on this week's budget is remaining for
     the user to allocate to Tasks. It then updates the navigation bar title to display
     the amount of time remaining.
     
     - Parameter None:
     - returns: Nothing
     */
    func updateTimeRemaining() {
        var taskTimeList:[Time] = []
        let newTime = Time(newTime: 168.0)
        
        // Loop through and sum up all of the time that has been allocated to Tasks.
        for var i = 0; i < self.currentBudget?.categories.count; i++ {
            let currentCategory = currentBudget?.categories[i]
            for var x = 0; x < currentCategory!.tasks.count; x++ {
                let currentTask = currentCategory!.tasks[x]
                taskTimeList.append(Time(newTime: currentTask.timeBudgeted))
            }
        }
        
        // Subtract all of the time that has been allocated.
        for var i = 0; i < taskTimeList.count; i++ {
            newTime.hours -= taskTimeList[i].hours
            newTime.minutes -= taskTimeList[i].minutes
        }
        
        // Clean and apply time to navigation bar title.
        newTime.cleanTime()
        self.totalTime = newTime
        self.navigationItem.title = self.totalTime.toString()
    }
    
}