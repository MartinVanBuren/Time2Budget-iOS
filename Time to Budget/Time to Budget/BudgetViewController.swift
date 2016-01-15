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
    @IBOutlet weak var tableView: UITableView!
    
    //==================== Time Clock Properties ===============
    var finalClockTime:Time!
    var segueFromTimeClock:Bool = false
    @IBOutlet weak var clockButton: UIButton!
    var timer:NSTimer!
    
    //==================== Realm Properties ====================
    let realm = Database.getRealm()
    var currentBudget:Budget?
    var notificationToken: NotificationToken!
    
    //==================== Pre-Generated Methods ====================
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var nib = UINib(nibName: "CategoryView", bundle: nil)
        self.tableView.registerNib(nib, forHeaderFooterViewReuseIdentifier: "CategoryView")
        
        nib = UINib(nibName: "DetailCell", bundle: nil)
        self.tableView.registerNib(nib, forCellReuseIdentifier: "DetailCell")
        
        nib = UINib(nibName: "SubtitleDetailCell", bundle: nil)
        self.tableView.registerNib(nib, forCellReuseIdentifier: "SubtitleDetailCell")
        
        let nav = self.navigationController!.navigationBar
        Style.navbar(nav)
        Style.viewController(self, tableView: self.tableView)
        Style.button(self.clockButton)
        
        self.currentBudget = realm.objects(Budget).filter("isCurrent = true").first!
        
        // Set realm notification block
        self.notificationToken = realm.addNotificationBlock { notification, realm in
            
            self.currentBudget = Database.budgetSafetyNet()

            self.tableView.reloadData()
        }
        
        self.tableView.reloadData()
        
        // Run Display Prompt Code
        self.displayPromptControl()
        
    }
    
    override func viewDidLayoutSubviews() {
        self.automaticallyAdjustsScrollViewInsets = false
        tableView.contentInset = UIEdgeInsetsMake(self.topLayoutGuide.length, 0, 54, 0)
    }
    
    override func viewWillAppear(animated: Bool) {
        self.tableView.reloadData()
        
        // Prepare timer if clocked in
        if self.currentBudget!.clock!.clockedIn {
            self.updateClock()
            let aSelector:Selector = "updateClock"
            self.timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: aSelector, userInfo: nil, repeats: true)
        } else if self.timer != nil {
            self.timer.invalidate()
            self.clockButton.setTitle("Clock In", forState: UIControlState.Normal)
            self.clockButton.setTitle("Clock In", forState: UIControlState.Highlighted)
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        if self.timer != nil {
            if self.timer.valid {
                self.timer.invalidate()
            }
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
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
            if self.segueFromTimeClock {
                let recordEditorVC = (segue.destinationViewController as! UINavigationController).topViewController as! RecordEditorViewController
                recordEditorVC.currentTask = nil
                recordEditorVC.currentRecord = nil
                recordEditorVC.timeSpent = self.finalClockTime
                self.segueFromTimeClock = false
            } else {
                let recordEditorVC = (segue.destinationViewController as! UINavigationController).topViewController as! RecordEditorViewController
                recordEditorVC.currentTask = nil
                recordEditorVC.currentRecord = nil
            }
        }
    }
    
    //==================== IBAction Methods ====================
    @IBAction func addRecordButtonPressed(sender: UIBarButtonItem) {
        performSegueWithIdentifier("showTrackingView", sender: self)
    }
    
    @IBAction func clockButtonPressed(sender: UIButton) {
        if self.currentBudget!.clock!.clockedIn {
            if let unwrappedFinalTime = Database.clockInOut(self.currentBudget!) {
                self.timer.invalidate()
                self.finalClockTime = Time.doubleToTime(unwrappedFinalTime)
                self.segueFromTimeClock = true
                self.clockButton.setTitle("Clock In", forState: UIControlState.Normal)
                self.clockButton.setTitle("Clock In", forState: UIControlState.Highlighted)
                performSegueWithIdentifier("showTrackingView", sender: self)
            }
        } else {
            let aSelector:Selector = "updateClock"
            self.timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: aSelector, userInfo: nil, repeats: true)
            Database.clockInOut(self.currentBudget!)
        }
    }
    
    //==================== UITableViewDataSource Methods ====================
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return Int(currentBudget!.categories.count)
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return currentBudget!.categories[section].tasks.count
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        return Factory.prepareTaskCell(tableView: tableView, categoryList: currentBudget!.categories, indexPath: indexPath, editor: false)
        
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        return Factory.prepareCategoryView(tableView: tableView, categoryList: currentBudget!.categories, section: section)
        
    }
    
    //==================== UITableViewDelegate Methods ====================
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("showRecordsView", sender: self)
    }
    
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
    //==================== Helper Methods ====================
    func updateClock() {
        
        let currentTime = NSDate.timeIntervalSinceReferenceDate()
        
        var elapsedTime = currentTime - self.currentBudget!.clock!.startTime
        
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
