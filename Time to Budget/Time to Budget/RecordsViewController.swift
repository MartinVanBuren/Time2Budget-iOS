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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        recordList = currentTask.records
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        fixContentInset(calledFromSegue: false)
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showTrackingViewAlt" {
            
            let trackingVC:TrackingViewController = (segue.destinationViewController as UINavigationController).topViewController as TrackingViewController
            
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
        return 44
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Int(self.recordList.count)
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.editRecord = true
        performSegueWithIdentifier("showTrackingViewAlt", sender: self)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 0
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
