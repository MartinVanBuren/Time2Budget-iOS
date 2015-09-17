//
//  RecordViewController.swift
//  Time to Budget
//
//  Created by Robert Kennedy on 12/8/14.
//  Copyright (c) 2014 Arrken Games, LLC. All rights reserved.
//

import UIKit
import RealmSwift

class RecordsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var currentTask:Task!
    var returning:Bool? = false
    var editRecord:Bool = false
    var recordList = List<Record>()
    @IBOutlet weak var tableView: UITableView!
    var promptEnabled:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidLayoutSubviews() {
        if let rect = self.navigationController?.navigationBar.frame {
            let y = rect.size.height + rect.origin.y
            self.tableView.contentInset = UIEdgeInsetsMake(y, 0, 0, 0)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        navigationItem.title = currentTask.name
        
        let nav = self.navigationController?.navigationBar
        Style.navbarSetColor(nav: nav!)
        
        let recordResults = currentTask.records.sorted("date", ascending: false)
        for rec in recordResults {
            self.recordList.append(rec)
        }
        
        if currentTask.memo != "" {
            navigationItem.prompt = currentTask.memo
            self.promptEnabled = true
        }
        
        self.tableView.reloadData()
        
        fixContentInset(calledFromSegue: false)
    }

    // ============================= Segue Preperation =============================
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showTrackingViewAlt" {
            
            let trackingVC = (segue.destinationViewController as! UINavigationController).topViewController as! RecordEditorViewController
            
            if self.editRecord {
                let indexPath = self.tableView.indexPathForSelectedRow!
                
                trackingVC.editRecord = true
                trackingVC.currentTask = self.currentTask
                trackingVC.currentRecord = recordList[indexPath.row]
                self.editRecord = false
            } else {
                trackingVC.currentTask = self.currentTask
            }
            
        }
        
        fixContentInset(calledFromSegue: true)
    }
    
    // ============================= Table View Overrides =============================

    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.recordList.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.editRecord = true
        performSegueWithIdentifier("showTrackingViewAlt", sender: self)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return Factory.prepareRecordCell(tableView: tableView, recordList: self.recordList, indexPath: indexPath)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        Factory.displayDeleteRecordAlert(self, record: recordList[indexPath.row])
    }
    
    // ============================= IBActions =============================
    @IBAction func addRecordButtonPressed(sender: UIBarButtonItem) {
        self.editRecord = false
        performSegueWithIdentifier("showTrackingViewAlt", sender: self)
    }
    
    // ============================= Helper Functions =============================
    
    func fixContentInset(calledFromSegue calledFromSegue: Bool) {
        if calledFromSegue {
            if (returning != nil) {
                self.returning = true
            }
        } else if !self.promptEnabled {
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
