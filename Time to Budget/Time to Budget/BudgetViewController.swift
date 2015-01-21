//
//  ViewController.swift
//  Time to Budget
//
//  Created by Robert Kennedy on 12/7/14.
//  Copyright (c) 2014 Arrken Games, LLC. All rights reserved.
//

import UIKit
import CoreData

class BudgetViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate {
    
    //==================== Properties ====================
    var editMode:Bool = false
    var displayPrompt:Bool = false
    
    //==================== IBOutlets ====================
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var editButton: UIBarButtonItem!

    //==================== CoreData Properties ====================
    let managedObjectContext = CoreDataController.getManagedObjectContext()
    var frcTasks:NSFetchedResultsController = NSFetchedResultsController()
    var frcCategories:NSFetchedResultsController = NSFetchedResultsController()
    
    //==================== Pre-Generated Methods ====================
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //tableView.tableHeaderView = UIView(frame: CGRectZero)
        //tableView.tableFooterView = UIView(frame: CGRectZero)
        
        // Core Data Fetching
        frcTasks = CoreDataController.getFetchedResultsController(fetchRequest: CoreDataController.getFetchRequest("Tasks"), managedObjectContext: managedObjectContext)
        frcTasks.delegate = self
        frcTasks.performFetch(nil)
        
        frcCategories = CoreDataController.getFetchedResultsController(fetchRequest: CoreDataController.getFetchRequest("Categories"), managedObjectContext: managedObjectContext)
        frcCategories.delegate = self
        frcCategories.performFetch(nil)
        
        // Run Display Prompt Code
        self.displayPromptControl()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //==================== Segue Preperation ====================
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showRecordsView" {
            clearPrompt()
            let recordsVC:RecordsViewController = segue.destinationViewController as RecordsViewController
            
            //let indexPath = self.tableView.indexPathForSelectedRow()
            //let thisTask = fetchedResultsController.objectAtIndexPath(indexPath!) as Task
            //recordsVC.recordsTask = thisTask
        }
        else if segue.identifier == "showBudgetEditorView" {
            let budgetEditorVC:BudgetEditorViewController = segue.destinationViewController as BudgetEditorViewController
            budgetEditorVC.returning = false
            //let indexPath = self.tableView.indexPathForSelectedRow()
            //let thisTask = fetchedResultsController.objectAtIndexPath(indexPath!) as Task
            //TaskEditorVC.currentTask = thisTask
        }
    }
    
    //==================== IBAction Methods ====================
    @IBAction func editButtonPressed(sender: UIBarButtonItem) {
        performSegueWithIdentifier("showBudgetEditorView", sender: self)
    }
    
    //==================== UITableViewDataSource Methods ====================
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return frcTasks.sections!.count
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return frcTasks.sections![section].numberOfObjects
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        return Factory.prepareTaskCell(tableView: tableView, fetchedResultsController: frcTasks, indexPath: indexPath)
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        return Factory.prepareCategoryCell(tableView: tableView, fetchedResultsController: frcTasks, section: section)
        
    }
    
    //==================== UITableViewDelegate Methods ====================
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        performSegueWithIdentifier("showRecordsView", sender: self)
    
    }
    
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 44
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    //==================== NSFetchedResultsControllerDelegate Methods ====================
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        self.tableView.reloadData()
    }
    
    //==================== Helper Methods ====================
    func displayPromptControl() {
        var navSingleTap = UITapGestureRecognizer(target: self, action: "navSingleTap")
        navSingleTap.numberOfTapsRequired = 1
        (self.navigationController?.navigationBar.subviews[1] as UIView).userInteractionEnabled = true
        (self.navigationController?.navigationBar.subviews[1] as UIView).addGestureRecognizer(navSingleTap)
    }
    
    func navSingleTap() {
        if displayPrompt == false {
            displayPrompt = true
            self.navigationItem.prompt = "Week of: "
        } else {
            clearPrompt()
        }
    }
    
    func clearPrompt() {
        displayPrompt = false
        self.navigationItem.prompt = nil
    }
    
}

