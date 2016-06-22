import UIKit

class TaskEditorViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, writeCategoryBackDelegate {

    //========== View Properties ==========
    var budgetEditorViewController: BudgetEditorViewController!
    var currentTask: Task?
    var returning: Bool? = false
    var editTask: Bool = false
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var saveTaskButton: UIButton!
    
    //========== Task Properties ==========
    var taskName: String?
    var taskMemo: String!
    var taskCategory: String?
    internal var taskTime: Double? = 0.0
    
    //==================== View Controller Methods ====================
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Apply Time to Budget theme to this view, navbar, and buttons.
        let nav = navigationController!.navigationBar
        Style.navbar(nav)
        Style.viewController(self, tableView: tableView)
        Style.button(saveTaskButton)
        
        // Register nibs for Cell/Headers.
        let nib = UINib(nibName: "DetailCell", bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: "DetailCell")
        
        // Set Nav bar title based on whether the user is editing or adding a task.
        if editTask {
            navigationItem.title = "Edit \(currentTask!.name)"
        } else {
            navigationItem.title = "Add Task"
        }

        // Apply the previous task information if editing.
        if let unwrappedTask = currentTask {
            taskName = unwrappedTask.name
            taskCategory = unwrappedTask.parent.name
            taskTime = unwrappedTask.timeBudgeted
            
            if unwrappedTask.memo != "" {
                taskMemo = unwrappedTask.memo
            }
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        tableView.reloadData()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "showTaskEditorTimePickerView") {
            // Pass self into target view.
            let timePickerVC = segue.destinationViewController as? TaskEditorTimePickerViewController
            timePickerVC?.taskEditorVC = self
        } else if (segue.identifier == "showTaskEditorCategorySelectorView") {
            // Pass self into target view.
            let categorySelectorVC = segue.destinationViewController as? TaskEditorCategorySelectorViewController
            categorySelectorVC?.delegate = self
        }
    }
    
    //==================== UITableViewDataSource Methods ====================
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let preparedCell = Factory.prepareNameTextfieldCell(tableView: tableView, name: taskName)
            preparedCell.textField.delegate = self
            return preparedCell
        case 1:
            let preparedCell = Factory.prepareMemoTextfieldCell(tableView: tableView, memo: taskMemo)
            preparedCell.textField.delegate = self
            return preparedCell
        case 2:
            return Factory.prepareAddTaskCategoryCell(tableView: tableView, categoryName: taskCategory)
        default:
            return Factory.prepareAddTaskTimeCell(tableView: tableView, time: taskTime)
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    //==================== UITableViewDelegate Methods ====================
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == 2 {
            performSegueWithIdentifier("showTaskEditorCategorySelectorView", sender: self)
        } else if indexPath.row == 3 {
            performSegueWithIdentifier("showTaskEditorTimePickerView", sender: self)
        }
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    //==================== Protocol Methods ====================
    func writeCategoryBack(cat: Category) {
        taskCategory = cat.name
    }
    
    //==================== UITextFieldDelegate Methods ====================
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
    
    //==================== IBAction Methods ====================
    @IBAction func taskNameTextfieldChanged(sender: UITextField) {
        if sender.text == "" {
            taskName = nil
        } else {
            taskName = sender.text
        }
    }
    
    @IBAction func taskMemoTextfieldChanged(sender: UITextField) {
        if sender.text == "" {
            taskMemo = nil
        } else {
            taskMemo = sender.text
        }
    }
    
    @IBAction func cancelButtonPressed(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: {})
    }
    
    @IBAction func saveButtonPressed(sender: UIButton) {
        // Verify task.memo is no nil
        if taskMemo == nil {
            taskMemo = ""
        }
        
        // Verify that a task name has been given.
        if let unwrappedName = taskName {
            // Verify that a category has been selected.
            if let unwrappedCategory = taskCategory {
                // Verify that a time has been selected.
                if let unwrappedTime = taskTime {
                    // Determine whether to edit a task or add a new one.
                    if editTask {
                        // Verify a previous task is available.
                        if let unwrappedTask = currentTask {
                            // Update the previous task in the database and return to previous view.
                            Database.updateTask(task: unwrappedTask, name: unwrappedName, memo: taskMemo, time: unwrappedTime, categoryName: unwrappedCategory)
                            dismissViewControllerAnimated(true, completion: {})
                        } else {
                            // Alert user that there was an error accessing the previous task.
                            Factory.displayAlert(viewController: self, title: "Error: Task Missing", message: "Task missing while in edit mode. D':")
                        }
                    } else {
                        // Add a new task to the database and return to previous view.
                        Database.addTask(name: unwrappedName, memo: taskMemo, time: unwrappedTime, categoryName: unwrappedCategory)
                        dismissViewControllerAnimated(true, completion: {})
                    }
                }
            } else {
                // Alert the user that a category has not been selected.
                Factory.displayAlert(viewController: self, title: "Category Not Selected", message: "You must select a Category")
            }
        } else {
            // Alert the user that a task name was not given.
            Factory.displayAlert(viewController: self, title: "Task Must Be Named", message: "You must name the task before saving.")
        }
    }
    
}
