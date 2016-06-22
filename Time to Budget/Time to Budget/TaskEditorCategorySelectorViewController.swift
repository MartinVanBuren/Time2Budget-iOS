import UIKit
import RealmSwift
import Instructions

class TaskEditorCategorySelectorViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, CoachMarksControllerDataSource {

    // ========== View Properties ==========
    var taskEditorVC: TaskEditorViewController!
    var delegate: writeCategoryBackDelegate?
    var returning: Bool? = false
    @IBOutlet weak var tableView: UITableView!
    let tutorialController = CoachMarksController()
    
    // ========== Realm Properties ==========
    var realm: Realm!
    var currentBudget: Budget!
    
    // ==================== View Controller Methods ====================
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup tutorial controller
        tutorialController.dataSource = self
        Style.tutorialController(tutorialController)
        
        // Register nibs for Cells/Headers
        let catCellNib = UINib(nibName: "CategoryCell", bundle: nil)
        tableView.registerNib(catCellNib, forCellReuseIdentifier: "CategoryCell")
        
        // Apply Time to Budget theme to this view and table view.
        Style.viewController(self, tableView: tableView)
        
        // Retrieve database and current budget.
        realm = Database.getRealm()
        currentBudget = Database.getBudget()
        
        tableView.reloadData()
    }
    
    override func viewDidAppear(animated: Bool) {
        if Tutorial.shouldRun(addTaskView: true) {
            tutorialController.startOn(self)
        }
    }
    
    override func viewDidLayoutSubviews() {
        // Adjust table view content insets
        automaticallyAdjustsScrollViewInsets = false
        tableView.contentInset = UIEdgeInsetsMake(topLayoutGuide.length, 0, 54, 0)
        if tableView.indexPathsForVisibleRows?.count != 0 {
            tableView.scrollToRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0), atScrollPosition: UITableViewScrollPosition.Top, animated: false)
        }
        
        // Setup tutorial points of interest
        tableView.reloadData()
        Tutorial.addTaskPOI[0] = navigationController?.navigationBar
        Tutorial.addTaskPOI[1] = (navigationItem.rightBarButtonItem!.valueForKey("view") as? UIView)
    }
    
    // ==================== UITableViewDataSource Methods ====================
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Int(currentBudget.categories.count)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let catCell = CellFactory().prepareCategoryCell(tableView: tableView, categoryList: currentBudget.categories, section: indexPath.row)
        
        if indexPath.section == 0 && indexPath.row == 0 {
            Tutorial.addTaskPOI[0] = catCell
        }
        
        return catCell
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UITableViewHeaderFooterView()
    }
    
    // ==================== UITableViewDelegate Methods ====================
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // Pass the category selected back to the Task Editor view and then return to previous view.
        delegate?.writeCategoryBack(currentBudget.categories[indexPath.row])
        navigationController?.popViewControllerAnimated(true)
    }
    
    // ==================== IBAction Methods ====================
    @IBAction func addCategoryButtonPressed(sender: UIBarButtonItem) {
        AlertFactory().displayAddCategoryAlert(viewController: self)
    }
    
    // ==================== CoachMarksControllerDataSource Methods ====================
    func numberOfCoachMarksForCoachMarksController(coachMarksController: CoachMarksController) -> Int {
        return Tutorial.addTaskPOI.count
    }
    
    func coachMarksController(coachMarksController: CoachMarksController, coachMarksForIndex index: Int) -> CoachMark {
        return coachMarksController.coachMarkForView(Tutorial.addTaskPOI[index] as UIView!)
    }
    
    func coachMarksController(coachMarksController: CoachMarksController, coachMarkViewsForIndex index: Int, coachMark: CoachMark) -> (bodyView: CoachMarkBodyView, arrowView: CoachMarkArrowView?) {
        let coachViews = coachMarksController.defaultCoachViewsWithArrow(true, arrowOrientation: coachMark.arrowOrientation)
        
        coachViews.bodyView.hintLabel.text = Tutorial.getHintLabelForIndex(index, addTaskView: true)
        coachViews.bodyView.nextLabel.text = Tutorial.getNextLabel()
        
        return (bodyView: coachViews.bodyView, arrowView: coachViews.arrowView)
        
    }
    
}
