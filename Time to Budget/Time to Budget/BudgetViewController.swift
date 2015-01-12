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
    var frcBudgetItems:NSFetchedResultsController = NSFetchedResultsController()
    var frcCategories:NSFetchedResultsController = NSFetchedResultsController()
    
    //==================== Pre-Generated Methods ====================
    override func viewDidLoad() {
        super.viewDidLoad()
        // Core Data Fetching
        frcBudgetItems = CoreDataController.getFetchedResultsController(fetchRequest: CoreDataController.fetchBudgetItemRequest(), managedObjectContext: managedObjectContext)
        frcBudgetItems.delegate = self
        frcBudgetItems.performFetch(nil)
        
        frcCategories = CoreDataController.getFetchedResultsController(fetchRequest: CoreDataController.fetchCategoryItemRequest(), managedObjectContext: managedObjectContext)
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
            //let thisBudgetItem = fetchedResultsController.objectAtIndexPath(indexPath!) as BudgetItem
            //recordsVC.recordsBudgetItem = thisBudgetItem
        }
        else if segue.identifier == "showBudgetEditor" {
            let budgetEditorVC:BudgetEditorViewController = segue.destinationViewController as BudgetEditorViewController
            budgetEditorVC.returning = false
            //let indexPath = self.tableView.indexPathForSelectedRow()
            //let thisBudgetItem = fetchedResultsController.objectAtIndexPath(indexPath!) as BudgetItem
            //budgetItemEditorVC.currentBudgetItem = thisBudgetItem
        }
    }
    
    //==================== IBAction Methods ====================
    @IBAction func editButtonPressed(sender: UIBarButtonItem) {
        performSegueWithIdentifier("showBudgetItemEditor", sender: self)
    }
    
    @IBAction func debugButtonPressed(sender: UIBarButtonItem) {
        testAddBudgetItemInCoreData()
    }
    
    
    //==================== UITableViewDataSource Methods ====================
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return frcBudgetItems.sections!.count
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return frcBudgetItems.sections![section].numberOfObjects
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        return Factory.prepareBudgetItemCell(tableView: tableView, fetchedResultsController: frcBudgetItems, indexPath: indexPath)
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        return Factory.prepareSectionHeaderCell(tableView: tableView, fetchedResultsController: frcBudgetItems, section: section)
        
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
    func testAddBudgetItemInCoreData() {
        //CoreDataController.addBudgetItem()
    }
    
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

