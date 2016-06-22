import UIKit
import RealmSwift

class BudgetHistoryRecordsViewController: UITableViewController {
    
    // ============== Realm Properties ==============
    var currentTask: Task?
    var recordsList = List<Record>()

    // =================== View Controller Methods ===================
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Retrieve and register the nib files for tableView elements.
        let detailNib = UINib(nibName: "DetailCell", bundle: nil)
        let subtitleNib = UINib(nibName: "SubtitleDetailCell", bundle: nil)
        tableView.registerNib(detailNib, forCellReuseIdentifier: "DetailCell")
        tableView.registerNib(subtitleNib, forCellReuseIdentifier: "SubtitleDetailCell")
        
        // Apply the Time to Budget theme to this view.
        Style.viewController(self)
    }
    
    override func viewWillAppear(animated: Bool) {
        // Retrieve up-to-date record information and display it to the table view
        let recordsResults = currentTask?.records.sorted("date", ascending: false)
        for rec in recordsResults! {
            recordsList.append(rec)
        }
        tableView.reloadData()
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let indexPath = tableView.indexPathForSelectedRow!
        
        if segue.identifier == "showHistoryRecord" {
            let historyRecordVC = segue.destinationViewController as? BudgetHistoryRecordViewController
            historyRecordVC?.currentRecord = recordsList[indexPath.row]
            historyRecordVC?.currentTask = currentTask!
        }
    }

    // ========================= UITableViewDataSource Methods =========================
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Int(currentTask!.records.count)
    }

    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return CellFactory().prepareRecordCell(tableView: tableView, recordList: recordsList, indexPath: indexPath)
    }
    
    // ========================= UITableViewDelegate Methods =========================
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("showHistoryRecord", sender: self)
    }
    
}
