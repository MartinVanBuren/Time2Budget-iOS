//
//  BudgetViewController.swift
//  Time to Budget
//
//  Created by Robert Kennedy on 1/23/15.
//  Copyright (c) 2015 Arrken Games, LLC. All rights reserved.
//

import Foundation
import UIKit
import Realm

class BudgetViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    //==================== Properties ====================
    var editMode:Bool = false
    var displayPrompt:Bool = false
    
    //==================== IBOutlets ====================
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var editButton: UIBarButtonItem!
    
    //==================== Realm Properties ====================
    let realm = Database.getRealm()
    let categoryList = Category.allObjects()
    var notificationToken: RLMNotificationToken?
    
    //==================== Pre-Generated Methods ====================
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set realm notification block
        notificationToken = RLMRealm.defaultRealm().addNotificationBlock { note, realm in
            self.tableView.reloadData()
        }
        
        self.tableView.reloadData()
        
        // Run Display Prompt Code
        self.displayPromptControl()
    }
    override func viewWillAppear(animated: Bool) {
        self.tableView.reloadData()
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
            
            let indexPath = self.tableView.indexPathForSelectedRow()!
            let thisTask = ((categoryList.objectAtIndex(UInt(indexPath.section)) as Category).tasks.objectAtIndex(UInt(indexPath.row))) as Task
            recordsVC.currentTask = thisTask
        }
        else if segue.identifier == "showBudgetEditorView" {
            let budgetEditorVC:BudgetEditorViewController = segue.destinationViewController as BudgetEditorViewController
            budgetEditorVC.returning = false
        }
    }
    
    //==================== IBAction Methods ====================
    @IBAction func editButtonPressed(sender: UIBarButtonItem) {
        performSegueWithIdentifier("showBudgetEditorView", sender: self)
    }
    
    @IBAction func addRecordButtonPressed(sender: UIButton) {
        performSegueWithIdentifier("showTrackingView", sender: self)
    }
    
    //==================== UITableViewDataSource Methods ====================
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return Int(categoryList.count)
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return Int((categoryList.objectAtIndex(UInt(section)) as Category).tasks.count)
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        return Factory.prepareTaskCell(tableView: tableView, categoryList: categoryList, indexPath: indexPath)
        
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        return Factory.prepareCategoryCell(tableView: tableView, categoryList: categoryList, section: section)
        
    }
    
    //==================== UITableViewDelegate Methods ====================
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        performSegueWithIdentifier("showRecordsView", sender: self)
        
    }
    
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 44
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
