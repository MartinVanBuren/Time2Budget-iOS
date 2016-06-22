import UIKit
import RealmSwift

class RecordEditorViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, writeTaskBackDelegate {
    
    // ============ View Properties ============
    @IBOutlet weak var saveRecordButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    var editRecord: Bool = false
    var returning: Bool? = false
    
    //============ Record Properties ============
    var currentTask: Task?
    var currentRecord: Record?
    var timeSpent: Double = 0.0
    var date: NSDate = NSDate()
    var memo: String!
    
    // ===================== View Controller Methods =====================
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Register Nibs for Cells/Header Views
        let detailNib = UINib(nibName: "DetailCell", bundle: nil)
        tableView.registerNib(detailNib, forCellReuseIdentifier: "DetailCell")
        
        // Apply Time to Budget theme to view, nav bar, and buttons.
        let nav = navigationController!.navigationBar
        Style.navbar(nav)
        Style.viewController(self, tableView: tableView)
        Style.button(saveRecordButton)
        
        // Apply the record information if any was passed into the view.
        if let unwrappedRecord = currentRecord {
            timeSpent = unwrappedRecord.timeSpent
            date = unwrappedRecord.date
            navigationItem.title = "Edit Record"
            
            if unwrappedRecord.note != "" {
                memo = unwrappedRecord.note
            }
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        tableView.reloadData()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "showTaskSelectorView") {
            // Pass self into the target view.
            let taskSelectorVC = (segue.destinationViewController as? RecordEditorTaskSelectorViewController)
            taskSelectorVC?.delegate = self
        } else if (segue.identifier == "showTimePickerView") {
            // Pass self into the target view.
            let timePickerVC = segue.destinationViewController as? RecordEditorTimePickerViewController
            timePickerVC?.recordEditorVC = self
        } else if (segue.identifier == "showDatePickerView") {
            // Pass self into the target view.
            let datePickerVC = segue.destinationViewController as? RecordEditorDatePickerViewController
            datePickerVC?.recordEditorVC = self
        }
    }
    
    // =============== Protocol Methods ===============
    func writeTaskBack(task: Task) {
        // Retrieve Task back from the Record Editor Task Selector View.
        currentTask = task
        tableView.reloadData()
    }
    
    // ==================== UITableViewDataSource Methods ====================
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellFactory = CellFactory()
        
        switch indexPath.row {
        case 0:
            return cellFactory.prepareAddRecordTaskCell(tableView: tableView, currentTask: currentTask)
        case 1:
            return cellFactory.prepareAddRecordTimeCell(tableView: tableView, timeSpent: Time(newTime: timeSpent))
        case 2:
            return cellFactory.prepareAddRecordDateCell(tableView: tableView, date: date)
        default:
            let preparedCell = cellFactory.prepareMemoTextfieldCell(tableView: tableView, memo: memo)
            preparedCell.textField.delegate = self
            return preparedCell
        }
    }
    
    // ==================== UITableViewDataSource Methods ====================
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch indexPath.row {
        case 0:
            performSegueWithIdentifier("showTaskSelectorView", sender: self)
            
        case 1:
            performSegueWithIdentifier("showTimePickerView", sender: self)
            
        case 2:
            performSegueWithIdentifier("showDatePickerView", sender: self)
            
        default:
            break
        }
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    // ==================== UITextFieldDelegate Methods ====================
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        // Close keyboard when finished editing.
        view.endEditing(true)
        return true
    }
    
    // ==================== IBAction Methods ====================
    @IBAction func cancelButtonPressed(sender: UIBarButtonItem) {
        // Return to previous view.
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func memoTextFieldChanged(sender: UITextField) {
        // Update memo property as textfield is updated.
        memo = sender.text!
    }
    
    @IBAction func saveRecordButtonPressed(sender: UIButton) {
        
        if recordInfoIsValid() { submitRecord() }
    }
    
    func submitRecord() {
        if memo == nil { memo = "" }
        
        if editRecord {
            updateRecord()
        } else {
            addRecord()
        }
    }

    func recordInfoIsValid() -> Bool {
        let alertFactory = AlertFactory()
        
        if currentTask == nil {
            alertFactory.displayAlert(viewController: self, title: "Task Not Selected", message: "You must select a Task.")
            return false
        }
        
        return true
    }
    
    func updateRecord() {
        if let unwrappedRecord = currentRecord {
            Database.updateRecord(record: unwrappedRecord, task: currentTask!, note: memo, timeSpent: timeSpent, date: date)
            navigationController?.dismissViewControllerAnimated(true, completion: nil)
        } else {
            AlertFactory().displayAlert(viewController: self, title: "Error: Record Missing", message: "Record missing while in edit mode. D':")
        }
    }
    
    func addRecord() {
        Database.addRecord(parentTask: currentTask!, note: memo, timeSpent: timeSpent, date: date)
        navigationController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
}
