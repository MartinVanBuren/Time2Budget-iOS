//
//  RecordViewController.swift
//  Time to Budget
//
//  Created by Robert Kennedy on 12/8/14.
//  Copyright (c) 2014 Arrken Games, LLC. All rights reserved.
//

import UIKit
import RealmSwift

class RecordsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITabBarControllerDelegate {

    var currentTask:Task?
    var returning:Bool? = false
    var editRecord:Bool = false
    var notificationToken: NotificationToken!
    var recordList = List<Record>()
    let realm = Database.getRealm()
    var promptEnabled:Bool = false
    var timer:NSTimer!
    var finalClockTime:Time!
    var segueFromTimeClock:Bool = false
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var clockButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBarController?.delegate = self
        
        var nib = UINib(nibName: "SubtitleDetailCell", bundle: nil)
        self.tableView.registerNib(nib, forCellReuseIdentifier: "SubtitleDetailCell")
        
        nib = UINib(nibName: "DetailCell", bundle: nil)
        self.tableView.registerNib(nib, forCellReuseIdentifier: "DetailCell")
        
        Style.viewController(self, tableView: self.tableView)
        Style.button(self.clockButton)
        
        // Set realm notification block
        notificationToken = realm.addNotificationBlock { notification, realm in
            
            if let unwrappedTask = self.currentTask {
                let recordResults = unwrappedTask.records.sorted("date", ascending: false)
                self.recordList = List<Record>()
                for rec in recordResults {
                    self.recordList.append(rec)
                }
                
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        navigationItem.title = currentTask!.name
        
        let recordResults = self.currentTask!.records.sorted("date", ascending: false)
        self.recordList = List<Record>()
        for rec in recordResults {
            self.recordList.append(rec)
        }
        
        if currentTask!.memo != "" {
            navigationItem.prompt = currentTask!.memo
            self.promptEnabled = true
        }
        
        self.tableView.reloadData()
        
        if self.currentTask!.clock!.clockedIn {
            let aSelector:Selector = "updateClock"
            self.timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: aSelector, userInfo: nil, repeats: true)
        } else if self.timer != nil {
            self.timer.invalidate()
            self.clockButton.setTitle("Clock In", forState: UIControlState.Normal)
            self.clockButton.setTitle("Clock In", forState: UIControlState.Highlighted)
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        if (self.isMovingFromParentViewController()){
            self.currentTask = nil
            if self.timer != nil {
                if self.timer.valid {
                    self.timer.invalidate()
                }
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        self.automaticallyAdjustsScrollViewInsets = false
        tableView.contentInset = UIEdgeInsetsMake(self.topLayoutGuide.length, 0, 54, 0)
    }
    
    func tabBarController(tabBarController: UITabBarController, didSelectViewController viewController: UIViewController) {
        if (viewController != self.navigationController) {
            self.navigationController?.popToRootViewControllerAnimated(false)
            self.currentTask = nil
        }
    }

    // ============================= Segue Preperation =============================
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showTrackingViewAlt" {
            
            let recordEditorVC = (segue.destinationViewController as! UINavigationController).topViewController as! RecordEditorViewController
            
            if self.editRecord {
                let indexPath = self.tableView.indexPathForSelectedRow!
                
                recordEditorVC.editRecord = true
                recordEditorVC.currentTask = self.currentTask
                recordEditorVC.currentRecord = recordList[indexPath.row]
                self.editRecord = false
            } else {
                if self.segueFromTimeClock {
                    recordEditorVC.currentTask = self.currentTask
                    recordEditorVC.currentRecord = nil
                    recordEditorVC.timeSpent = self.finalClockTime
                    self.segueFromTimeClock = false
                } else {
                    recordEditorVC.currentTask = self.currentTask
                }
            }
        }
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
    
    @IBAction func clockButtonPressed(sender: UIButton) {
        if self.currentTask!.clock!.clockedIn {
            if let unwrappedFinalTime = Database.clockInOut(self.currentTask!) {
                self.timer.invalidate()
                self.finalClockTime = Time.doubleToTime(unwrappedFinalTime)
                self.segueFromTimeClock = true
                self.clockButton.setTitle("Clock In", forState: UIControlState.Normal)
                self.clockButton.setTitle("Clock In", forState: UIControlState.Highlighted)
                performSegueWithIdentifier("showTrackingViewAlt", sender: self)
            }
        } else {
            let aSelector:Selector = "updateClock"
            self.timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: aSelector, userInfo: nil, repeats: true)
            Database.clockInOut(self.currentTask!)
        }
    }
    // ============================= Helper Functions =============================
    func updateClock() {
        
        let currentTime = NSDate.timeIntervalSinceReferenceDate()
        
        var elapsedTime = currentTime - self.currentTask!.clock!.startTime
        
        let hours = Int((elapsedTime / 60.0) / 60.0)
        elapsedTime -= ((NSTimeInterval(hours) * 60) * 60)
        
        let minutes = Int((elapsedTime / 60.0))
        elapsedTime -= (NSTimeInterval(minutes) * 60)
        
        let seconds = Int(elapsedTime)
        elapsedTime -= (NSTimeInterval(seconds))
        
        var hoursString:String!
        var minutesString:String!
        var secondsString:String!
        
        if hours >= 10 {
            hoursString = "\(hours):"
        } else {
            hoursString = "0\(hours):"
        }
        
        if minutes >= 10 {
            minutesString = "\(minutes):"
        } else {
            minutesString = "0\(minutes):"
        }
        
        if seconds >= 10 {
            secondsString = "\(seconds)"
        } else {
            secondsString = "0\(seconds)"
        }
        
        let finalTimeString = hoursString + minutesString + secondsString
        
        UIView.setAnimationsEnabled(false)
        self.clockButton.setTitle(("Clock Out - " + finalTimeString), forState: UIControlState.Normal)
        self.clockButton.setTitle(("Clock Out - " + finalTimeString), forState: UIControlState.Highlighted)
        UIView.setAnimationsEnabled(true)
    }
}
