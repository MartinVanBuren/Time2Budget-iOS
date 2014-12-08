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
    
    //==================== IBOutlets ====================
    @IBOutlet weak var tableView: UITableView!

    //==================== Variables ====================
    
    //==================== Constants ====================

    
    //==================== Pre-Generated Methods ====================
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //==================== IBAction Methods ====================
    @IBAction func editButtonPressed(sender: UIBarButtonItem) {
        self.performSegueWithIdentifier("showBudgetEditor", sender: self)
    }
    
    //==================== UITableViewDataSource Methods ====================
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 0
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        return UITableViewCell()
    }
    
    //==================== UITableViewDelegate Methods ====================
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 25
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Default"
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    //==================== NSFetchedResultsControllerDelegate Methods ====================
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        
    }
    
    //==================== Helper Methods ====================
    
}

