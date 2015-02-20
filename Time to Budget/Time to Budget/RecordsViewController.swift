//
//  RecordViewController.swift
//  Time to Budget
//
//  Created by Robert Kennedy on 12/8/14.
//  Copyright (c) 2014 Arrken Games, LLC. All rights reserved.
//

import UIKit
import Realm

class RecordsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var currentTask:Task!
    var returning:Bool? = false
    var editRecord:Bool = false
    var recordList:RLMArray!
    @IBOutlet weak var tableView: UITableView!
    var notificationToken: RLMNotificationToken?
    var promptEnabled:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        recordList = currentTask.records
        
        // Set realm notification block
        notificationToken = RLMRealm.defaultRealm().addNotificationBlock { note, realm in
            self.tableView.reloadData()
        }
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        navigationItem.title = currentTask.name
        
        if currentTask.memo != "" {
            navigationItem.prompt = currentTask.memo
            self.promptEnabled = true
        }
        
        fixContentInset(calledFromSegue: false)
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showTrackingViewAlt" {
            
            let trackingVC:AddRecordViewController = (segue.destinationViewController as UINavigationController).topViewController as AddRecordViewController
            
            if self.editRecord {
                let indexPath = self.tableView.indexPathForSelectedRow()!
                
                trackingVC.editRecord = true
                trackingVC.currentTask = self.currentTask
                trackingVC.currentRecord = (recordList.objectAtIndex(UInt(indexPath.row)) as Record)
                self.editRecord = false
            } else {
                trackingVC.currentTask = self.currentTask
            }
            
        }
        
        fixContentInset(calledFromSegue: true)
    }

    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Int(self.recordList.count)
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
    
    @IBAction func addRecordButtonPressed(sender: UIButton) {
        self.editRecord = false
        performSegueWithIdentifier("showTrackingViewAlt", sender: self)
    }
    
    func fixContentInset(#calledFromSegue: Bool) {
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
