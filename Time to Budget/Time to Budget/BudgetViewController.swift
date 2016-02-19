//
//  BudgetViewController.swift
//  Time to Budget
//
//  Created by Robert Kennedy on 1/23/15.
//  Copyright (c) 2015 Arrken Games, LLC. All rights reserved.
//

import UIKit
import RealmSwift
import Instructions

class BudgetViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, CoachMarksControllerDataSource {
    
    //============ View Properties ============
    var displayPrompt:Bool = false
    @IBOutlet weak var tableView: UITableView!
    let tutorialController = CoachMarksController()
    
    //============ Time Clock Properties ============
    var finalClockTime:Time?
    @IBOutlet weak var clockButton: UIButton!
    var timer:NSTimer!
    
    //============ Realm Properties ============
    var realm:Realm!
    var currentBudget:Budget?
    var notificationToken: NotificationToken!
    
    //============ View Controller Functions ============
    override func viewDidLoad() {
        super.viewDidLoad()
        // Setting up tutorial controller
        self.tutorialController.datasource = self
        Style.tutorialController(self.tutorialController)
        
        // Fetch Database
        self.realm = Database.getRealm()
        
        // Register Nibs for Cells/Header Views
        let catViewNib = UINib(nibName: "CategoryView", bundle: nil)
        let detailNib = UINib(nibName: "DetailCell", bundle: nil)
        let subtitleNib = UINib(nibName: "SubtitleDetailCell", bundle: nil)
        self.tableView.registerNib(catViewNib, forHeaderFooterViewReuseIdentifier: "CategoryView")
        self.tableView.registerNib(detailNib, forCellReuseIdentifier: "DetailCell")
        self.tableView.registerNib(subtitleNib, forCellReuseIdentifier: "SubtitleDetailCell")
        
        // Apply Time to Budget theme to view
        let nav = self.navigationController!.navigationBar
        Style.navbar(nav)
        Style.viewController(self, tableView: self.tableView)
        Style.button(self.clockButton)
        
        // Retrieve current budget
        self.currentBudget = Database.budgetSafetyNet()
        
        // Set realm notification block to run each time the database is updated.
        self.notificationToken = realm.addNotificationBlock { notification, realm in
            self.currentBudget = Database.budgetSafetyNet()
            self.tableView.reloadData()
        }
        
        // Register a tap gesture for the navigation bar to display the current budget name.
        self.registerPromptTap()
    }
    
    override func viewWillAppear(animated: Bool) {
        // Check if clocked in and update the Clock In button accordingly.
        if self.currentBudget!.clock!.clockedIn {
            self.initializeClock()
        } else if self.timer != nil {
            self.invalidateClock()
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        if Tutorial.shouldRun(budgetView: true) {
            self.tutorialController.startOn(self)
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        // Invalidate timer when leaving the view to avoid conflicts.
        if self.timer != nil {
            if self.timer.valid {
                self.timer.invalidate()
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        // Reload table data to update header bar widths properly.
        self.tableView.reloadData()
        
        // Setup tutorial points of interest.
        Tutorial.budgetViewPOI[0] = self.navigationController?.navigationBar
        Tutorial.budgetViewPOI[1] = self.navigationController?.navigationBar
        Tutorial.budgetViewPOI[2] = self.navigationController?.navigationBar
        Tutorial.budgetViewPOI[3] = (self.navigationItem.rightBarButtonItem!.valueForKey("view") as! UIView)
        Tutorial.budgetViewPOI[4] = self.clockButton
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showRecordsView" {
            
            // Prepare Budget View (origin view) for segue.
            let indexPath = self.tableView.indexPathForSelectedRow!
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
            self.clearPrompt()
            
            // Pass the selected task into the Records View.
            let recordsVC:RecordsViewController = segue.destinationViewController as! RecordsViewController
            let selectedTask = currentBudget!.categories[indexPath.section].tasks[indexPath.row]
            recordsVC.currentTask = selectedTask
            
        } else if segue.identifier == "showTrackingView" {
            // Pass the time spent from the clock button if any.
            let recordEditorVC = (segue.destinationViewController as! UINavigationController).topViewController as! RecordEditorViewController
            recordEditorVC.timeSpent = self.finalClockTime
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
        let taskCell = Factory.prepareTaskCell(tableView: tableView, categoryList: currentBudget!.categories, indexPath: indexPath, editor: false)
        
        if(indexPath.section == 0 && indexPath.row == 0) {
            Tutorial.budgetViewPOI[2] = taskCell
        }
        
        return taskCell
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = Factory.prepareCategoryView(tableView: tableView, categoryList: currentBudget!.categories, section: section)
        
        if(section == 0) {
            Tutorial.budgetViewPOI[1] = headerView
        }
        
        return headerView
    }
    
    //==================== IBAction Methods ====================
    @IBAction func addRecordButtonPressed(sender: UIBarButtonItem) {
        performSegueWithIdentifier("showTrackingView", sender: self)
    }
    
    @IBAction func clockButtonPressed(sender: UIButton) {
        if self.currentBudget!.clock!.clockedIn {
            // Clock out and retrieve the final clock time.
            if let unwrappedFinalTime = Database.clockInOut(self.currentBudget!) {
                self.finalClockTime = Time(newTime: unwrappedFinalTime)
                self.invalidateClock()
                performSegueWithIdentifier("showTrackingView", sender: self)
            }
        } else {
            // Clock in and nullify the final clock time.
            self.finalClockTime = nil
            Database.clockInOut(self.currentBudget!)
            self.initializeClock()
        }
    }
    
    //==================== UITableViewDelegate Methods ====================
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("showRecordsView", sender: self)
    }
    
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
    //==================== CoachMarksDataSource Methods ====================
    func numberOfCoachMarksForCoachMarksController(coachMarksController: CoachMarksController) -> Int {
        return Tutorial.budgetViewPOI.count
    }

    func coachMarksController(coachMarksController: CoachMarksController, coachMarksForIndex index: Int) -> CoachMark {
        return coachMarksController.coachMarkForView(Tutorial.budgetViewPOI[index] as UIView!)
    }
    
    func coachMarksController(coachMarksController: CoachMarksController, coachMarkViewsForIndex index: Int, coachMark: CoachMark) -> (bodyView: CoachMarkBodyView, arrowView: CoachMarkArrowView?) {
        let coachViews = coachMarksController.defaultCoachViewsWithArrow(true, arrowOrientation: coachMark.arrowOrientation)
        
        coachViews.bodyView.hintLabel.text = Tutorial.getHintLabelForIndex(index, budgetView: true)
        coachViews.bodyView.nextLabel.text = Tutorial.getNextLabel()
        
        return (bodyView: coachViews.bodyView, arrowView: coachViews.arrowView)
        
    }
    
    //==================== Helper Methods ====================
    
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
        // Calculate elapsed time.
        let currentTime = NSDate.timeIntervalSinceReferenceDate()
        var elapsedTime = currentTime - self.currentBudget!.clock!.startTime
        
        // Break elapsed time down into hours, minutes, and seconds.
        let hours = Int((elapsedTime / 60.0) / 60.0)
        elapsedTime -= ((NSTimeInterval(hours) * 60) * 60)
        
        let minutes = Int((elapsedTime / 60.0))
        elapsedTime -= (NSTimeInterval(minutes) * 60)
        
        let seconds = Int(elapsedTime)
        elapsedTime -= (NSTimeInterval(seconds))
        
        // Generate a string to represent the elapsed time.
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
        
        // Update and animate the clock in button title text.
        UIView.setAnimationsEnabled(false)
        self.clockButton.setTitle(("Clock Out - " + finalTimeString), forState: UIControlState.Normal)
        self.clockButton.setTitle(("Clock Out - " + finalTimeString), forState: UIControlState.Highlighted)
        UIView.setAnimationsEnabled(true)
    }
    
    /**
     Creates and registers a tap gesture for the navigation bar title to display the current budget name on tap.
     
     This method generates a UITapGestureRecognizer and then registers to the navigations bar's title text
     so that if the title is tapped the view will display the current budget name in the navigation bar
     prompt.
     
     - Parameter None:
     - returns: Nothing
     */
    func registerPromptTap() {
        let navSingleTap = UITapGestureRecognizer(target: self, action: "navSingleTap")
        navSingleTap.numberOfTapsRequired = 1
        self.navigationController?.navigationBar.subviews[1].userInteractionEnabled = true
        self.navigationController?.navigationBar.subviews[1].addGestureRecognizer(navSingleTap)
    }
    
    /**
     Toggles whether the current budget name is displayed in the navigation bar prompt.
     
     - Parameter None:
     - returns: Nothing
     */
    func navSingleTap() {
        if displayPrompt == false {
            displayPrompt = true
            self.navigationItem.prompt = "\(currentBudget!.name)"
        } else {
            clearPrompt()
        }
    }
    
    /**
     Clears the navigation bar prompt so it is no longer displayed.
     
     - Parameter None:
     - returns: Nothing
     */
    func clearPrompt() {
        displayPrompt = false
        self.navigationItem.prompt = nil
    }
    
}
