import UIKit

class TaskEditorViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, writeCategoryBackDelegate {

    //========== View Properties ==========
    var budgetEditorViewController: BudgetEditorViewController!
    var currentTask: Task?
    var returning = false
    var editTask = false
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var saveTaskButton: UIButton!
    
    //========== Task Properties ==========
    var taskName: String?
    var taskMemo = ""
    var taskCategory: String?
    var taskTime = 0.0
    
    //==================== View Controller Methods ====================
    override func viewDidLoad() {
        super.viewDidLoad()
        applyStyling()
        registerNibs()
        populateFields()
    }
    
    func applyStyling() {
        let nav = navigationController!.navigationBar
        Style.navbar(nav)
        Style.viewController(self, tableView: tableView)
        Style.button(saveTaskButton)
        
        if editTask {
            navigationItem.title = "Edit \(currentTask!.name)"
        } else {
            navigationItem.title = "Add Task"
        }
    }
    
    func registerNibs() {
        let nib = UINib(nibName: "DetailCell", bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: "DetailCell")
    }
    
    func populateFields() {
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

            let timePickerVC = segue.destinationViewController as? TaskEditorTimePickerViewController
            timePickerVC?.taskEditorVC = self
            
        } else if (segue.identifier == "showTaskEditorCategorySelectorView") {

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
        let cellFactory = CellFactory()
        
        switch indexPath.row {
        case 0:
            let preparedCell = cellFactory.prepareNameTextfieldCell(tableView: tableView, name: taskName)
            preparedCell.textField.delegate = self
            return preparedCell
        case 1:
            let preparedCell = cellFactory.prepareMemoTextfieldCell(tableView: tableView, memo: taskMemo)
            preparedCell.textField.delegate = self
            return preparedCell
        case 2:
            return cellFactory.prepareAddTaskCategoryCell(tableView: tableView, categoryName: taskCategory)
        default:
            return cellFactory.prepareAddTaskTimeCell(tableView: tableView, time: taskTime)
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
        taskMemo = sender.text!
    }
    
    @IBAction func cancelButtonPressed(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: {})
    }
    
    @IBAction func saveButtonPressed(sender: UIButton) {
        if taskInfoIsValid() { submitTask() }
    }
    
    func submitTask() {        
        if editTask {
            updateTask()
        } else {
            addTask()
        }
    }
    
    func taskInfoIsValid() -> Bool {
        let alertFactory = AlertFactory()
        
        if taskName == nil {
            alertFactory.displayAlert(viewController: self, title: "Task Not Named", message: "You must name the task before saving.")
            return false
        }
        
        if taskCategory == nil {
            alertFactory.displayAlert(viewController: self, title: "Category Not Selected", message: "You must select a Category")
            return false
        }
        
        return true
    }
    
    func updateTask() {
        if let unwrappedTask = currentTask {
            Database.updateTask(task: unwrappedTask, name: taskName!, memo: taskMemo, time: taskTime, categoryName: taskCategory!)
            dismissViewControllerAnimated(true, completion: {})
        } else {
            AlertFactory().displayAlert(viewController: self, title: "Error: Task Missing", message: "Task missing while in edit mode. D':")
        }

    }
    
    func addTask() {
        Database.addTask(name: taskName!, memo: taskMemo, time: taskTime, categoryName: taskCategory!)
        dismissViewControllerAnimated(true, completion: {})
    }
    
}
