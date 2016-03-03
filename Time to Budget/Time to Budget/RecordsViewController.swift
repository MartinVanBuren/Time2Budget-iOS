//
//  RecordViewController.swift
//  Time to Budget
//
//  Created by Robert Kennedy on 12/8/14.
//  Copyright (c) 2014 Arrken Games, LLC. All rights reserved.
//

import UIKit
import RealmSwift
import Instructions

class RecordsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITabBarControllerDelegate, CoachMarksControllerDataSource {

    //========= View Properties =========
    var returning = false
    var editRecord:Bool = false
    var promptEnabled:Bool = false
    var timeReturning = 0
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var clockButton: UIButton!
    let tutorialController = CoachMarksController()

    //========= Time Clock Properties =========
    var timer:NSTimer!
    var finalClockTime:Time?
    
    //========= Realm Properties =========
    var realm:Realm!
    var currentTask:Task?
    var recordList = List<Record>()
    var notificationToken: NotificationToken!
    
    //================== View Controller Methods ==================
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setting up tutorial controller
        self.tutorialController.datasource = self
        Style.tutorialController(self.tutorialController)
        
        // Retrieve database
        self.realm = Database.getRealm()
        
        self.tabBarController?.delegate = self
        
        // Register Nibs for the table view cells and header views.
        let detailNib = UINib(nibName: "DetailCell", bundle: nil)
        let subtitleNib = UINib(nibName: "SubtitleDetailCell", bundle: nil)
        let catViewNib = UINib(nibName: "CategoryView", bundle: nil)
        self.tableView.registerNib(detailNib, forCellReuseIdentifier: "DetailCell")
        self.tableView.registerNib(subtitleNib, forCellReuseIdentifier: "SubtitleDetailCell")
        self.tableView.registerNib(catViewNib, forHeaderFooterViewReuseIdentifier: "CategoryView")
        
        // Applying the Time to Budget theme to this view.
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
        
        // Fixes the content inset for the table view.
        fixInsetLoad()
    }
    
    override func viewDidLayoutSubviews() {
        // Setup Tutorial points of interest.
        Tutorial.recordsViewPOI[0] = self.navigationController?.navigationBar
        Tutorial.recordsViewPOI[1] = self.navigationController?.navigationBar
        Tutorial.recordsViewPOI[2] = self.navigationController?.navigationBar
        Tutorial.recordsViewPOI[3] = self.navigationController?.navigationBar.subviews[2]
        Tutorial.recordsViewPOI[4] = self.clockButton
    }
    
    override func viewWillAppear(animated: Bool) {
        // Set nav bar title to the current task name
        navigationItem.title = currentTask!.name
        
        // Retrieve and filter current records by date.
        let recordResults = self.currentTask!.records.sorted("date", ascending: false)
        self.recordList = List<Record>()
        for rec in recordResults {
            self.recordList.append(rec)
        }
        
        // Set nav bar prompt to the current task memo if any
        if currentTask!.memo != "" {
            navigationItem.prompt = currentTask!.memo
            self.promptEnabled = true
        }
        
        self.tableView.reloadData()
        
        // Prepare timer if clocked in
        if self.currentTask!.clock!.clockedIn {
            self.initializeClock()
        } else if self.timer != nil {
            self.invalidateClock()
        }
        
        // Fix content inset if needed
        if returning && currentTask!.memo == "" {
            fixInsetSegue()
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        // Invalidate timer when leaving the view to avoid conflicts.
        if (self.isMovingFromParentViewController()){
            self.currentTask = nil
            if self.timer != nil {
                if self.timer.valid {
                    self.timer.invalidate()
                }
            }
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        if Tutorial.shouldRun(recordsView: true) {
            self.tutorialController.startOn(self)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showTrackingViewAlt" {
            returning = true
            // Retrieve targeted view
            let recordEditorVC = (segue.destinationViewController as! UINavigationController).topViewController as! RecordEditorViewController
            
            if self.editRecord {
                // Pass the current task and selected record.
                let indexPath = self.tableView.indexPathForSelectedRow!
                recordEditorVC.editRecord = true
                recordEditorVC.currentTask = self.currentTask
                recordEditorVC.currentRecord = recordList[indexPath.row]
                self.editRecord = false
            } else {
                // Pass the current task and the time spent from the clock button if any.
                recordEditorVC.currentTask = self.currentTask
                recordEditorVC.timeSpent = self.finalClockTime
            }
        }
    }
    
    //========================== UITabBarControllerDelegate Methods ==========================
    func tabBarController(tabBarController: UITabBarController, didSelectViewController viewController: UIViewController) {
        // If the user navigates away from this tab then pop to the budget view controller to avoid conflicts.
        if (viewController != self.navigationController) {
            self.navigationController?.popToRootViewControllerAnimated(false)
            self.currentTask = nil
        }
    }
    
    //========================== UITableViewDataSource Methods ==========================

    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = Factory.prepareBasicHeader(tableView: self.tableView, titleText: "Records")
        
        Tutorial.recordsViewPOI[1] = headerView
        
        return headerView
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.recordList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let recordCell = Factory.prepareRecordCell(tableView: tableView, recordList: self.recordList, indexPath: indexPath)
        
        if(indexPath.section == 0 && indexPath.row == 0) {
            Tutorial.recordsViewPOI[2] = recordCell
        }
        
        return recordCell
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    //============================ UITableViewDelegate Methods ============================
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.editRecord = true
        performSegueWithIdentifier("showTrackingViewAlt", sender: self)
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        Factory.displayDeleteRecordAlert(self, record: recordList[indexPath.row])
    }
    
    //============================= IBAction Methods =============================
    @IBAction func addRecordButtonPressed(sender: UIBarButtonItem) {
        self.editRecord = false
        performSegueWithIdentifier("showTrackingViewAlt", sender: self)
    }
    
    @IBAction func clockButtonPressed(sender: UIButton) {
        if self.currentTask!.clock!.clockedIn {
            // Clock out and retrieve the final clock time.
            if let unwrappedFinalTime = Database.clockInOut(self.currentTask!) {
                self.finalClockTime = Time(newTime: unwrappedFinalTime)
                self.invalidateClock()
                performSegueWithIdentifier("showTrackingViewAlt", sender: self)
            }
        } else {
            // Clock in and nullify the final clock time.
            self.finalClockTime = nil
            Database.clockInOut(self.currentTask!)
            self.initializeClock()
        }
    }
    
    //==================== CoachMarksDataSource Methods ====================
    func numberOfCoachMarksForCoachMarksController(coachMarksController: CoachMarksController) -> Int {
        return Tutorial.recordsViewPOI.count
    }
    
    func coachMarksController(coachMarksController: CoachMarksController, coachMarksForIndex index: Int) -> CoachMark {
        return coachMarksController.coachMarkForView(Tutorial.recordsViewPOI[index] as UIView!)
    }
    
    func coachMarksController(coachMarksController: CoachMarksController, coachMarkViewsForIndex index: Int, coachMark: CoachMark) -> (bodyView: CoachMarkBodyView, arrowView: CoachMarkArrowView?) {
        let coachViews = coachMarksController.defaultCoachViewsWithArrow(true, arrowOrientation: coachMark.arrowOrientation)
        
        coachViews.bodyView.hintLabel.text = Tutorial.getHintLabelForIndex(index, recordsView: true)
        coachViews.bodyView.nextLabel.text = Tutorial.getNextLabel()
        
        return (bodyView: coachViews.bodyView, arrowView: coachViews.arrowView)
        
    }
    
    // ============================= Helper Functions =============================
    
    /**
    Creates a timer to update the clock button every second.
    
    This method calls updateClock() and generates a timer to repeat updateClock() every second in order to
    show the current amount of time the user has been clocked in on the clock button.
    
    - Parameter None:
    - returns: Nothing
    */
    func initializeClock() {
        self.updateClock()
        let aSelector:Selector = "updateClock"
        self.timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: aSelector, userInfo: nil, repeats: true)
    }
    
    /**
     Invalidates the timer created by initializeClock() and resets the clock button back to default.
     
     This method invalidates the timer used to update the clock button time and then sets the clock button text
     back to it's default "Clock In".
     
     - Parameter None:
     - returns: Nothing
     */
    func invalidateClock() {
        self.timer.invalidate()
        self.clockButton.setTitle("Clock In", forState: UIControlState.Normal)
        self.clockButton.setTitle("Clock In", forState: UIControlState.Highlighted)
    }
    
    /**
     Calculates the current amount of time the user has been clocked in and updates the clock button accordingly.
     
     This method calculates the amount of time the user have been clocked in by subtracting the time clocked in
     by the current time and breaks it down into hours, minutes, and seconds. These are then converted into a
     readable string format for use on the clock button title. The clock button title is then updated and animated
     to relflect the elapsed time since the user clocked in.
     
     - Parameter None:
     - returns: Nothing
     */
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
    
    /**
     Calculates the proper content inset for the tableView during load and applies it to the table view.
     
     - Parameter None:
     - returns: Nothing
     */
    func fixInsetLoad() {
        if currentTask!.memo == "" {
            UIView.animateWithDuration(CATransaction.animationDuration(), animations: {
                if let rect = self.navigationController?.navigationBar.frame {
                    let y = rect.size.height + rect.origin.y
                    self.tableView.contentInset = UIEdgeInsetsMake(y, 0, self.tableView.contentInset.bottom+50, 0)
                }
            })
        }
    }
    
    /**
     Calculates the proper content inset for the tableView during segue and applies it to the table view.
     
     - Parameter None:
     - returns: Nothing
     */
    func fixInsetSegue() {
        timeReturning++
        
        if(timeReturning >= 2) {
            let top = self.navigationController!.navigationBar.frame.size.height + self.navigationController!.navigationBar.frame.origin.y
            self.tableView.contentInset = UIEdgeInsetsMake(top, 0, 50, 0)
        } else {
            self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
        }
        
        self.returning = false
    }
}
