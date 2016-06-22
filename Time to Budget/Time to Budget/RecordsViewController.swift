import UIKit
import RealmSwift
import Instructions

class RecordsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITabBarControllerDelegate, CoachMarksControllerDataSource {

    // ========= View Properties =========
    var returning = false
    var editRecord: Bool = false
    var promptEnabled: Bool = false
    var timeReturning = 0
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var clockButton: UIButton!
    let tutorialController = CoachMarksController()

    // ========= Time Clock Properties =========
    var timer: NSTimer!
    var finalClockTime: Time?
    
    // ========= Realm Properties =========
    var realm: Realm!
    var currentTask: Task?
    var recordList = List<Record>()
    
    // ================== View Controller Methods ==================
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setting up tutorial controller
        tutorialController.dataSource = self
        Style.tutorialController(tutorialController)
        Tutorial.recordsViewPOI[1] = navigationController?.navigationBar
        Tutorial.recordsViewPOI[2] = navigationController?.navigationBar
        
        // Retrieve database
        realm = Database.getRealm()
        
        tabBarController?.delegate = self
        
        // Register Nibs for the table view cells and header views.
        let detailNib = UINib(nibName: "DetailCell", bundle: nil)
        let subtitleNib = UINib(nibName: "SubtitleDetailCell", bundle: nil)
        let catViewNib = UINib(nibName: "CategoryView", bundle: nil)
        tableView.registerNib(detailNib, forCellReuseIdentifier: "DetailCell")
        tableView.registerNib(subtitleNib, forCellReuseIdentifier: "SubtitleDetailCell")
        tableView.registerNib(catViewNib, forHeaderFooterViewReuseIdentifier: "CategoryView")
        
        // Applying the Time to Budget theme to this view.
        Style.viewController(self, tableView: tableView)
        Style.button(clockButton)
        
        // Fixes the content inset for the table view.
        fixInsetLoad()
    }
    
    override func viewDidLayoutSubviews() {
        // Setup Tutorial points of interest.
        Tutorial.recordsViewPOI[0] = navigationController?.navigationBar
        Tutorial.recordsViewPOI[3] = navigationController?.navigationBar.subviews[2]
        Tutorial.recordsViewPOI[4] = clockButton
    }
    
    override func viewWillAppear(animated: Bool) {
        // Set nav bar title to the current task name
        navigationItem.title = currentTask!.name
        
        // Retrieve and filter current records by date.
        let recordResults = currentTask!.records.sorted("date", ascending: false)
        recordList = List<Record>()
        for rec in recordResults {
            recordList.append(rec)
        }
        
        // Set nav bar prompt to the current task memo if any
        if currentTask!.memo != "" {
            navigationItem.prompt = currentTask!.memo
            promptEnabled = true
        }
        
        tableView.reloadData()
        
        // Prepare timer if clocked in
        if currentTask!.clock!.clockedIn {
            initializeClock()
        } else if timer != nil {
            invalidateClock()
        }
        
        // Fix content inset if needed
        if returning && currentTask!.memo == "" {
            fixInsetSegue()
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        // Invalidate timer when leaving the view to avoid conflicts.
        if (isMovingFromParentViewController()) {
            currentTask = nil
            if timer != nil {
                if timer.valid {
                    timer.invalidate()
                }
            }
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        if Tutorial.shouldRun(recordsView: true) {
            tutorialController.startOn(self)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showTrackingViewAlt" {
            returning = true
            // Retrieve targeted view
            let navController = segue.destinationViewController as? UINavigationController
            let recordEditorVC = navController?.topViewController as? RecordEditorViewController
            
            if editRecord {
                // Pass the current task and selected record.
                let indexPath = tableView.indexPathForSelectedRow!
                recordEditorVC?.editRecord = true
                recordEditorVC?.currentTask = currentTask
                recordEditorVC?.currentRecord = recordList[indexPath.row]
                editRecord = false
            } else {
                // Pass the current task and the time spent from the clock button if any.
                recordEditorVC?.currentTask = currentTask
                recordEditorVC?.timeSpent = finalClockTime!.toDouble()
            }
        }
    }
    
    // ========================== UITabBarControllerDelegate Methods ==========================
    func tabBarController(tabBarController: UITabBarController, didSelectViewController viewController: UIViewController) {
        // If the user navigates away from this tab then pop to the budget view controller to avoid conflicts.
        if (viewController != navigationController) {
            navigationController?.popToRootViewControllerAnimated(false)
            currentTask = nil
        }
    }
    
    // ========================== UITableViewDataSource Methods ==========================

    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = CellFactory().prepareBasicHeader(tableView: tableView, titleText: "Records")
        
        Tutorial.recordsViewPOI[1] = headerView
        
        return headerView
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recordList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let recordCell = CellFactory().prepareRecordCell(tableView: tableView, recordList: recordList, indexPath: indexPath)
        
        if(indexPath.section == 0 && indexPath.row == 0) {
            Tutorial.recordsViewPOI[2] = recordCell
        }
        
        return recordCell
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    // ============================ UITableViewDelegate Methods ============================
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        editRecord = true
        performSegueWithIdentifier("showTrackingViewAlt", sender: self)
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        AlertFactory().displayDeleteRecordAlert(self, record: recordList[indexPath.row])
    }
    
    // ============================= IBAction Methods =============================
    @IBAction func addRecordButtonPressed(sender: UIBarButtonItem) {
        editRecord = false
        performSegueWithIdentifier("showTrackingViewAlt", sender: self)
    }
    
    @IBAction func clockButtonPressed(sender: UIButton) {
        if currentTask!.clock!.clockedIn {
            // Clock out and retrieve the final clock time.
            if let unwrappedFinalTime = Database.clockInOut(currentTask!) {
                finalClockTime = Time(newTime: unwrappedFinalTime)
                invalidateClock()
                performSegueWithIdentifier("showTrackingViewAlt", sender: self)
            }
        } else {
            // Clock in and nullify the final clock time.
            finalClockTime = nil
            Database.clockInOut(currentTask!)
            initializeClock()
        }
    }
    
    // ==================== CoachMarksDataSource Methods ====================
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
    func initializeClock() {
        updateClock()
        let aSelector: Selector = #selector(RecordsViewController.updateClock)
        timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: aSelector, userInfo: nil, repeats: true)
    }

    func invalidateClock() {
        timer.invalidate()
        clockButton.setTitle("Clock In", forState: UIControlState.Normal)
        clockButton.setTitle("Clock In", forState: UIControlState.Highlighted)
    }

    func updateClock() {
        
        let currentTime = NSDate.timeIntervalSinceReferenceDate()
        
        var elapsedTime = currentTime - currentTask!.clock!.startTime
        
        let hours = Int((elapsedTime / 60.0) / 60.0)
        elapsedTime -= ((NSTimeInterval(hours) * 60) * 60)
        
        let minutes = Int((elapsedTime / 60.0))
        elapsedTime -= (NSTimeInterval(minutes) * 60)
        
        let seconds = Int(elapsedTime)
        elapsedTime -= (NSTimeInterval(seconds))
        
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
        
        UIView.setAnimationsEnabled(false)
        clockButton.setTitle(("Clock Out - " + finalTimeString), forState: UIControlState.Normal)
        clockButton.setTitle(("Clock Out - " + finalTimeString), forState: UIControlState.Highlighted)
        UIView.setAnimationsEnabled(true)
    }

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

    func fixInsetSegue() {
        timeReturning += 1
        
        if(timeReturning >= 2) {
            let top = navigationController!.navigationBar.frame.size.height + navigationController!.navigationBar.frame.origin.y
            tableView.contentInset = UIEdgeInsetsMake(top, 0, 50, 0)
        } else {
            tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
        }
        
        returning = false
    }
    
}
