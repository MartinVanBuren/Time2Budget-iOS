import UIKit
import RealmSwift
import Instructions

class BudgetViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, CoachMarksControllerDataSource {
    
    // ============ View Properties ============
    var displayPrompt: Bool = false
    @IBOutlet weak var tableView: UITableView!
    let tutorialController = CoachMarksController()
    
    // ============ Time Clock Properties ============
    var finalClockTime: Time?
    @IBOutlet weak var clockButton: UIButton!
    var timer: NSTimer!
    
    // ============ Realm Properties ============
    var realm: Realm!
    var currentBudget: Budget?
    
    // ============ View Controller Functions ============
    override func viewDidLoad() {
        super.viewDidLoad()
        registerNibs()
        applyStyling()
        
        realm = Database.getRealm()
        currentBudget = Database.getBudget()
        
        registerPromptTap()
    }
    
    func initializeTutorial() {
        tutorialController.dataSource = self
        Style.tutorialController(tutorialController)
    }
    
    func applyStyling() {
        let nav = navigationController!.navigationBar
        Style.navbar(nav)
        Style.viewController(self, tableView: tableView)
        Style.button(clockButton)
    }
    
    func registerNibs() {
        let catViewNib = UINib(nibName: "CategoryView", bundle: nil)
        let detailNib = UINib(nibName: "DetailCell", bundle: nil)
        let subtitleNib = UINib(nibName: "SubtitleDetailCell", bundle: nil)
        tableView.registerNib(catViewNib, forHeaderFooterViewReuseIdentifier: "CategoryView")
        tableView.registerNib(detailNib, forCellReuseIdentifier: "DetailCell")
        tableView.registerNib(subtitleNib, forCellReuseIdentifier: "SubtitleDetailCell")
    }
    
    override func viewWillAppear(animated: Bool) {
        currentBudget = Database.getBudget()
        tableView.reloadData()
        
        // Check if clocked in and update the Clock In button accordingly.
        if currentBudget!.clock!.clockedIn {
            initializeClock()
        } else if timer != nil {
            invalidateClock()
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        if Tutorial.shouldRun(budgetView: true) {
            tutorialController.startOn(self)
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        // Invalidate timer when leaving the view to avoid conflicts.
        if timer != nil {
            if timer.valid {
                timer.invalidate()
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        // Reload table data to update header bar widths properly.
        tableView.reloadData()
        
        // Setup tutorial points of interest.
        Tutorial.budgetViewPOI[0] = navigationController?.navigationBar
        Tutorial.budgetViewPOI[1] = navigationController?.navigationBar
        Tutorial.budgetViewPOI[2] = navigationController?.navigationBar
        Tutorial.budgetViewPOI[3] = navigationItem.rightBarButtonItem!.valueForKey("view") as? UIView
        Tutorial.budgetViewPOI[4] = clockButton
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showRecordsView" {
            
            // Prepare Budget View (origin view) for segue.
            let indexPath = tableView.indexPathForSelectedRow!
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
            clearPrompt()
            
            // Pass the selected task into the Records View.
            let recordsVC = segue.destinationViewController as? RecordsViewController
            let selectedTask = currentBudget!.categories[indexPath.section].tasks[indexPath.row]
            recordsVC?.currentTask = selectedTask
            
        } else if segue.identifier == "showTrackingView" {
            // Pass the time spent from the clock button if any.
            let navController = segue.destinationViewController as? UINavigationController
            let recordEditorVC = navController?.topViewController as? RecordEditorViewController
            if finalClockTime != nil {
                recordEditorVC?.timeSpent = finalClockTime!.toDouble()
            }
        }
    }
    
    // ==================== UITableViewDataSource Methods ====================
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return Int(currentBudget!.categories.count)
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return currentBudget!.categories[section].tasks.count
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let taskCell = CellFactory().prepareTaskCell(tableView: tableView, categoryList: currentBudget!.categories, indexPath: indexPath, editor: false)
        
        if(indexPath.section == 0 && indexPath.row == 0) {
            Tutorial.budgetViewPOI[2] = taskCell
        }
        
        return taskCell
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = CellFactory().prepareCategoryView(tableView: tableView, categoryList: currentBudget!.categories, section: section)
        
        if(section == 0) {
            Tutorial.budgetViewPOI[1] = headerView
        }
        
        return headerView
    }
    
    // ==================== IBAction Methods ====================
    @IBAction func addRecordButtonPressed(sender: UIBarButtonItem) {
        performSegueWithIdentifier("showTrackingView", sender: self)
    }
    
    @IBAction func clockButtonPressed(sender: UIButton) {
        if currentBudget!.clock!.clockedIn {
            // Clock out and retrieve the final clock time.
            if let unwrappedFinalTime = Database.clockInOut(currentBudget!) {
                finalClockTime = Time(newTime: unwrappedFinalTime)
                invalidateClock()
                performSegueWithIdentifier("showTrackingView", sender: self)
            }
        } else {
            // Clock in and nullify the final clock time.
            finalClockTime = nil
            Database.clockInOut(currentBudget!)
            initializeClock()
        }
    }
    
    // ==================== UITableViewDelegate Methods ====================
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("showRecordsView", sender: self)
    }
    
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
    // ==================== CoachMarksDataSource Methods ====================
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
    
    // ==================== Helper Methods ====================
    func initializeClock() {
        updateClock()
        let aSelector: Selector = #selector(BudgetViewController.updateClock)
        timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: aSelector, userInfo: nil, repeats: true)
    }
    
    func invalidateClock() {
        timer.invalidate()
        clockButton.setTitle("Clock In", forState: UIControlState.Normal)
        clockButton.setTitle("Clock In", forState: UIControlState.Highlighted)
    }
    
    func updateClock() {
        // Calculate elapsed time.
        let currentTime = NSDate.timeIntervalSinceReferenceDate()
        var elapsedTime = currentTime - currentBudget!.clock!.startTime
        
        // Break elapsed time down into hours, minutes, and seconds.
        let hours = Int((elapsedTime / 60.0) / 60.0)
        elapsedTime -= ((NSTimeInterval(hours) * 60) * 60)
        
        let minutes = Int((elapsedTime / 60.0))
        elapsedTime -= (NSTimeInterval(minutes) * 60)
        
        let seconds = Int(elapsedTime)
        elapsedTime -= (NSTimeInterval(seconds))
        
        // Generate a string to represent the elapsed time.
        var hoursString: String!
        var minutesString: String!
        var secondsString: String!
        
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
        clockButton.setTitle(("Clock Out - " + finalTimeString), forState: UIControlState.Normal)
        clockButton.setTitle(("Clock Out - " + finalTimeString), forState: UIControlState.Highlighted)
        UIView.setAnimationsEnabled(true)
    }
    
    func registerPromptTap() {
        let navSingleTap = UITapGestureRecognizer(target: self, action: #selector(BudgetViewController.navSingleTap))
        navSingleTap.numberOfTapsRequired = 1
        navigationController?.navigationBar.subviews[1].userInteractionEnabled = true
        navigationController?.navigationBar.subviews[1].addGestureRecognizer(navSingleTap)
    }

    func navSingleTap() {
        if displayPrompt == false {
            displayPrompt = true
            navigationItem.prompt = "\(currentBudget!.name)"
        } else {
            clearPrompt()
        }
    }

    func clearPrompt() {
        displayPrompt = false
        navigationItem.prompt = nil
    }
    
}
