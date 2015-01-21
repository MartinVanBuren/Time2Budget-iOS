//
//  BudgetEditorViewController.swift
//  Time to Budget
//
//  Created by Robert Kennedy on 12/8/14.
//  Copyright (c) 2014 Arrken Games, LLC. All rights reserved.
//

import UIKit
import CoreData

class BudgetEditorViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var totalTime = Time(newHours: 168, newMinutes: 0)
    var returning:Bool? = false
    let viewTransitionDelegate = TransitionDelegate()
    var addTaskDialog:Bool = false
    
    //==================== CoreData Properties ====================
    let managedObjectContext = CoreDataController.getManagedObjectContext()
    var frcTasks:NSFetchedResultsController = NSFetchedResultsController()
    var frcCategories:NSFetchedResultsController = NSFetchedResultsController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Core Data - Fetching Budget Item
        frcTasks = CoreDataController.getFetchedResultsController(fetchRequest: CoreDataController.getFetchRequest("Tasks"), managedObjectContext: managedObjectContext)
        frcTasks.delegate = self
        frcTasks.performFetch(nil)
        // Core Data - Fetching Category Item
        frcCategories = CoreDataController.getFetchedResultsController(fetchRequest: CoreDataController.getFetchRequest("Categories"), managedObjectContext: managedObjectContext)
        frcCategories.delegate = self
        frcCategories.performFetch(nil)
        
        
        self.navigationItem.title = totalTime.toString()
    }
    
    override func viewWillAppear(animated: Bool) {
        fixContentInset(calledFromSegue: false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(animated: Bool) {
        let appDelegate = (UIApplication.sharedApplication().delegate as AppDelegate)
        
    }
    
    //==================== Segue Preperation ====================
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showTaskEditorView" {
            let taskEditorVC:TaskEditorViewController = segue.destinationViewController as TaskEditorViewController
            
            if !addTaskDialog {
                let indexPath = self.tableView.indexPathForSelectedRow()
                let thisTask = frcTasks.objectAtIndexPath(indexPath!) as Task
                taskEditorVC.currentTask = thisTask
            } else {
                taskEditorVC.addTaskDialog = true
            }
            
            fixContentInset(calledFromSegue: true)
        }
    }
    
    //==================== UITableViewDataSource Methods ====================
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return frcTasks.sections!.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return frcTasks.sections![section].numberOfObjects
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var tempTime = Time.floatToTime((frcTasks.objectAtIndexPath(indexPath) as Task).timeRemaining)
        self.totalTime.hours -= tempTime.hours
        self.totalTime.minutes -= tempTime.minutes
        updateTimeRemaining()
        return Factory.prepareTaskCell(tableView: tableView, fetchedResultsController: frcTasks, indexPath: indexPath)
        
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        return Factory.prepareCategoryCell(tableView: tableView, fetchedResultsController: frcTasks, section: section)
        
    }
    
    //==================== UITableViewDelegate Methods ====================
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        performSegueWithIdentifier("showTaskEditorView", sender: self)
        
    }
    
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 44
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        var moveRecords:Bool = false
        var alert = UIAlertController(title: "Save Task Records?", message: "Task records will be moved to a task named \"Taskless Records\"", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
            CoreDataController.deleteTask(frcTasks: self.frcTasks, indexPath: indexPath, retainRecords: true)
        }))
        alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
            CoreDataController.deleteTask(frcTasks: self.frcTasks, indexPath: indexPath, retainRecords: false)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
        
        
    }
    
    //==================== NSFetchedResultsControllerDelegate Methods ====================
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        self.tableView.reloadData()
        
        updateTimeRemaining()
    }
    
    //==================== IB Actions ====================
    @IBAction func addTaskButtonPressed(sender: UIButton) {
        addTaskDialog = true
        performSegueWithIdentifier("showTaskEditorView", sender: sender)
        addTaskDialog = false
    }
    
    @IBAction func addCategoryButtonPressed(sender: UIButton) {
        var inputTextField = UITextField()
        inputTextField.placeholder = "Enter Category Name"
        
        var alert = UIAlertController(title: "New Category", message: "", preferredStyle: UIAlertControllerStyle.Alert)
        //var alert = UIAlertView(title: "New Category", message: "", delegate: self, cancelButtonTitle: "Cancel", otherButtonTitles: "Add")
        alert.addAction(UIAlertAction(title: "Add", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
            CoreDataController.addCategory(categoryName: inputTextField.text)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
        alert.addTextFieldWithConfigurationHandler {(textField) -> Void in inputTextField = textField}
        
        
        self.presentViewController(alert, animated: true, completion: {})
    }
    
    //==================== Helper Methods ====================
    func updateTimeRemaining() {
        self.totalTime.cleanTime()
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
