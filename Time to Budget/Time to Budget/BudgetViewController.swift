//
//  BudgetViewController.swift
//  Time to Budget
//
//  Created by Robert Kennedy on 1/23/15.
//  Copyright (c) 2015 Arrken Games, LLC. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

class BudgetViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    //==================== Properties ====================
    var editMode:Bool = false
    var displayPrompt:Bool = false
    
    //==================== IBOutlets ====================
    @IBOutlet weak var tableView: UITableView!
    
    //==================== Realm Properties ====================
    let realm = try! Realm()
    var currentBudget:Budget?
    var notificationToken: NotificationToken!
    
    //==================== Pre-Generated Methods ====================
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nav = self.navigationController?.navigationBar
        Style.navbarSetColor(nav: nav!)
        
        self.currentBudget = realm.objects(Budget).filter("isCurrent == TRUE").first!
        
        // Set realm notification block
        notificationToken = realm.addNotificationBlock { notification, realm in
            
            if realm.objects(Budget).filter("isCurrent == TRUE").count > 0 {
                self.currentBudget = realm.objects(Budget).filter("isCurrent == TRUE").first!
            } else {
                Database.newBudget()
            }

            self.tableView.reloadData()
        }
        
        self.tableView.reloadData()
        
        // Run Display Prompt Code
        self.displayPromptControl()
    }
    
    /*
    override func viewDidLayoutSubviews() {
        UIView.animateWithDuration(CATransaction.animationDuration(), animations: {
            if let rect = self.navigationController?.navigationBar.frame {
                let y = rect.size.height + rect.origin.y
                self.tableView.contentInset = UIEdgeInsetsMake(y, 0, 0, 0)
            }
        })
    }
    */
    
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
            let recordsVC:RecordsViewController = segue.destinationViewController as! RecordsViewController
            
            let indexPath = self.tableView.indexPathForSelectedRow!
            let thisTask = currentBudget!.categories[indexPath.section].tasks[indexPath.row]
            recordsVC.currentTask = thisTask
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
        }
        else if segue.identifier == "showTrackingView" {
            let recordEditorVC = (segue.destinationViewController as! UINavigationController).topViewController as! RecordEditorViewController
            recordEditorVC.currentTask = nil
            recordEditorVC.currentRecord = nil
        }
        
    }
    
    //==================== IBAction Methods ====================
    @IBAction func addRecordButtonPressed(sender: UIBarButtonItem) {
        performSegueWithIdentifier("showTrackingView", sender: self)
    }
    
    //==================== UITableViewDataSource Methods ====================
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return Int(currentBudget!.categories.count)
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return currentBudget!.categories[section].tasks.count
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        return Factory.prepareTaskCell(tableView: tableView, categoryList: currentBudget!.categories, indexPath: indexPath, isEditor: false)
        
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        return Factory.prepareCategoryCell(tableView: tableView, categoryList: currentBudget!.categories, section: section, isEditor: false)
        
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
        let navSingleTap = UITapGestureRecognizer(target: self, action: "navSingleTap")
        navSingleTap.numberOfTapsRequired = 1
        (self.navigationController?.navigationBar.subviews[1])!.userInteractionEnabled = true
        (self.navigationController?.navigationBar.subviews[1])!.addGestureRecognizer(navSingleTap)
    }
    
    func navSingleTap() {
        if displayPrompt == false {
            displayPrompt = true
            self.navigationItem.prompt = "\(currentBudget!.name)"
        } else {
            clearPrompt()
        }
    }
    
    func clearPrompt() {
        displayPrompt = false
        self.navigationItem.prompt = nil
    }
    
}
