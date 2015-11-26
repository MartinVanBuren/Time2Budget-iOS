//
//  RecordViewController.swift
//  Time to Budget
//
//  Created by Robert Kennedy on 12/8/14.
//  Copyright (c) 2014 Arrken Games, LLC. All rights reserved.
//

import UIKit
import RealmSwift

class RecordsViewController: UITableViewController {

    var currentTask:Task!
    var returning:Bool? = false
    var editRecord:Bool = false
    var notificationToken: NotificationToken!
    var recordList = List<Record>()
    let realm = Database.getRealm()
    var promptEnabled:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var nib = UINib(nibName: "SubtitleDetailCell", bundle: nil)
        self.tableView.registerNib(nib, forCellReuseIdentifier: "SubtitleDetailCell")
        
        nib = UINib(nibName: "DetailCell", bundle: nil)
        self.tableView.registerNib(nib, forCellReuseIdentifier: "DetailCell")
        
        Style.viewController(self)
        
        // Set realm notification block
        notificationToken = realm.addNotificationBlock { notification, realm in
            
            let recordResults = self.currentTask.records.sorted("date", ascending: false)
            self.recordList = List<Record>()
            for rec in recordResults {
                self.recordList.append(rec)
            }
            
            self.tableView.reloadData()
        }

        
    }
    
    /*
    override func viewDidLayoutSubviews() {
        if self.currentTask.memo == "" {
            UIView.animateWithDuration(CATransaction.animationDuration(), animations: {
                if let rect = self.navigationController?.navigationBar.frame {
                    let y = rect.size.height + rect.origin.y
                    self.tableView.contentInset = UIEdgeInsetsMake(y, 0, 0, 0)
                }
            })
        }
    }
    */
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        navigationItem.title = currentTask.name
        
        //let nav = self.navigationController!.navigationBar
        //Style.navbar(nav)
        
        let recordResults = currentTask.records.sorted("date", ascending: false)
        self.recordList = List<Record>()
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

    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.recordList.count
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.editRecord = true
        performSegueWithIdentifier("showTrackingViewAlt", sender: self)
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return Factory.prepareRecordCell(tableView: tableView, recordList: self.recordList, indexPath: indexPath)
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
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
