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
    
    
    //==================== CoreData Properties ====================
    let managedObjectContext = CoreDataController.getManagedObjectContext()
    var frcBudgetItems:NSFetchedResultsController = NSFetchedResultsController()
    var frcCategories:NSFetchedResultsController = NSFetchedResultsController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Core Data - Fetching Budget Item
        frcBudgetItems = CoreDataController.getFetchedResultsController(fetchRequest: CoreDataController.fetchBudgetItemRequest(), managedObjectContext: managedObjectContext)
        frcBudgetItems.delegate = self
        frcBudgetItems.performFetch(nil)
        // Core Data - Fetching Category Item
        frcCategories = CoreDataController.getFetchedResultsController(fetchRequest: CoreDataController.fetchCategoryItemRequest(), managedObjectContext: managedObjectContext)
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
        if segue.identifier == "showBudgetItemEditorView" {
            let budgetItemEditorVC:BudgetItemEditorViewController = segue.destinationViewController as BudgetItemEditorViewController
            
            
            let indexPath = self.tableView.indexPathForSelectedRow()
            let thisBudgetItem = frcBudgetItems.objectAtIndexPath(indexPath!) as BudgetItem
            budgetItemEditorVC.currentBudgetItem = thisBudgetItem
            
            fixContentInset(calledFromSegue: true)
        }
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
        
        performSegueWithIdentifier("showBudgetItemEditorView", sender: self)
        
    }
    
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 44
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    //==================== NSFetchedResultsControllerDelegate Methods ====================
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        self.tableView.reloadData()
        
        self.navigationItem.title = totalTime.toString()
    }
    
    //==================== IB Actions ====================
    
    @IBAction func addCategoryButtonPressed(sender: UIBarButtonItem) {
        CoreDataController.addCategoryItem()
    }
    
    //==================== Helper Methods ====================
    
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
