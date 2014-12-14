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
    let managedObjectContext = (UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext!
    var fetchedResultsController:NSFetchedResultsController = NSFetchedResultsController()
    
    //==================== Pre-Generated Methods ====================
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        fetchedResultsController = getFetchedResultsController()
        fetchedResultsController.delegate = self
        fetchedResultsController.performFetch(nil)
        
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
        else if segue.identifier == "showBudgetItemEditor" {
            let budgetItemEditorVC:BudgetItemEditorViewController = segue.destinationViewController as BudgetItemEditorViewController
            let indexPath = self.tableView.indexPathForSelectedRow()
            let thisBudgetItem = fetchedResultsController.objectAtIndexPath(indexPath!) as BudgetItem
            budgetItemEditorVC.currentBudgetItem = thisBudgetItem
        }
    }
    
    //==================== IBAction Methods ====================
    @IBAction func editButtonPressed(sender: UIBarButtonItem) {
        if editMode == false {
            editMode = true;
            self.editButton.title = "Done"
            self.navigationItem.title = "Edit Budget"
        } else {
            editMode = false;
            self.editButton.title = "Edit"
            self.navigationItem.title = "Budget"
        }
    }
    
    @IBAction func debugButtonPressed(sender: UIBarButtonItem) {
        testAddBudgetItemInCoreData()
    }
    
    
    //==================== UITableViewDataSource Methods ====================
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return fetchedResultsController.sections!.count
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return fetchedResultsController.sections![section].numberOfObjects
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let thisBudgetItem = fetchedResultsController.objectAtIndexPath(indexPath) as BudgetItem
        
        var cell:BudgetItemCell = tableView.dequeueReusableCellWithIdentifier("BudgetItemCell") as BudgetItemCell
        
        cell.itemNameLabel.text = thisBudgetItem.name
        cell.remainingTimeLabel.text = thisBudgetItem.remaingTimeAsString()
        
        return cell
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let thisBudgetItem = fetchedResultsController.objectAtIndexPath(NSIndexPath(forRow: 0, inSection: section)) as BudgetItem
        
        var totalHours:Int = 0
        var totalMinutes:Int = 0
        
        var cell:SectionHeaderCell = tableView.dequeueReusableCellWithIdentifier("SectionHeaderCell") as SectionHeaderCell
        
        let arraySize = fetchedResultsController.sections?[section].numberOfObjects
            
        for var i = 0; i < arraySize; i++ {
            totalHours += (fetchedResultsController.objectAtIndexPath(NSIndexPath(forRow: i, inSection: section)) as BudgetItem).timeHrsRemain.integerValue
            totalMinutes += (fetchedResultsController.objectAtIndexPath(NSIndexPath(forRow: i, inSection: section)) as BudgetItem).timeMinsRemain.integerValue
            }
        
        var newTime:[Int] = cleanTime(totalHours, mins: totalMinutes)
        
        cell.sectionNameLabel.text = thisBudgetItem.category
        cell.remainingTimeLabel.text = "\(newTime[0]):\(newTime[1])"

        return cell
    }
    
    //==================== UITableViewDelegate Methods ====================
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if self.editMode == true {
            performSegueWithIdentifier("showBudgetItemEditor", sender: self)
        }
        else {
            performSegueWithIdentifier("showRecordsView", sender: self)
        }
        
        
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
    func taskFetchRequest() -> NSFetchRequest {
        let fetchRequest = NSFetchRequest(entityName: "BudgetItem")
        let sortDescriptor = NSSortDescriptor(key: "category", ascending: true)
        let sortDescriptor2 = NSSortDescriptor(key: "name", ascending: false)
        
        fetchRequest.sortDescriptors = [sortDescriptor, sortDescriptor2]
        
        return fetchRequest
    }
    
    func getFetchedResultsController() -> NSFetchedResultsController {
        
        var localFetchedResultsController = NSFetchedResultsController(fetchRequest: taskFetchRequest(), managedObjectContext: managedObjectContext, sectionNameKeyPath: "category", cacheName: nil)
        
        return localFetchedResultsController
    }
    
    func testAddBudgetItemInCoreData() {
        let appDelegate = (UIApplication.sharedApplication().delegate as AppDelegate)
        let entityDescription = NSEntityDescription.entityForName("BudgetItem", inManagedObjectContext: self.managedObjectContext)
        let testBudgetItem = BudgetItem(entity: entityDescription!, insertIntoManagedObjectContext: self.managedObjectContext)
        
        testBudgetItem.name = "Test Budget Item"
        testBudgetItem.descript = "This is a Test"
        testBudgetItem.category = "Test Category 2"
        testBudgetItem.timeHrsRemain = 5
        testBudgetItem.timeMinsRemain = 15
        testBudgetItem.isVisible = true
        
        appDelegate.saveContext()
        
        var request = NSFetchRequest(entityName: "BudgetItem")
        var error:NSError? = nil
        var results:NSArray = self.managedObjectContext.executeFetchRequest(request, error: &error)!
        
        for res in results {
            println(res)
        }
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
            self.navigationItem.prompt = "Time Remaining This Week:"
        } else {
            clearPrompt()
        }
    }
    
    func clearPrompt() {
        displayPrompt = false
        self.navigationItem.prompt = nil
    }
    
    func cleanTime(hrs: Int, mins: Int) -> [Int] {
        var newHrs:Int = hrs
        var newMins:Int = mins
        
        while newMins >= 60 {
            newHrs += 1
            newMins -= 60
        }
        
        return [newHrs, newMins]
    }
}

