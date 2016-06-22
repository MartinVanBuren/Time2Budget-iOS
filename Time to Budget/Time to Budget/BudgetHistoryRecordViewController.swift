import UIKit
import RealmSwift

class BudgetHistoryRecordViewController: UITableViewController {

    // ========== Realm Properties ==========
    var currentRecord: Record?
    var currentTask: Task?
    
    // ==================== View Controller Methods ====================
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Retrieve and register the nib files for tableView elements.
        let detailNib = UINib(nibName: "DetailCell", bundle: nil)
        tableView.registerNib(detailNib, forCellReuseIdentifier: "DetailCell")
        
        // Apple the Time to Budget theme to this view and navigation bar.
        let nav = navigationController!.navigationBar
        Style.navbar(nav)
        Style.viewController(self)
    }
    
    override func viewWillAppear(animated: Bool) {
        tableView.reloadData()
    }

    // ==================== UITableViewDataSource Methods ====================
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellFactory = CellFactory()
        
        switch indexPath.row {
        case 0:
            let cell = cellFactory.prepareAddRecordTaskCell(tableView: tableView, currentTask: currentTask)
            cell.accessoryType = UITableViewCellAccessoryType.None
            cell.userInteractionEnabled = false
            return cell
        case 1:
            let cell =  cellFactory.prepareAddRecordTimeCell(tableView: tableView, timeSpent: Time(newTime: currentRecord!.timeSpent))
            cell.accessoryType = UITableViewCellAccessoryType.None
            cell.userInteractionEnabled = false
            return cell
        case 2:
            let cell =  cellFactory.prepareAddRecordDateCell(tableView: tableView, date: currentRecord?.date)
            cell.accessoryType = UITableViewCellAccessoryType.None
            cell.userInteractionEnabled = false
            return cell
        default:
            let cell = cellFactory.prepareMemoTextfieldCell(tableView: tableView, memo: currentRecord?.note)
            cell.textField.placeholder = "No Memo"
            cell.userInteractionEnabled = false
            return cell
        }
    }
    
    // ==================== UITableViewDelegate Methods ====================
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
}
