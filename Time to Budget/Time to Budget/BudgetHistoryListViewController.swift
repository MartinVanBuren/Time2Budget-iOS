import UIKit
import RealmSwift

class BudgetHistoryListViewController: UITableViewController {
    
    // ============= Realm Properties =============
    var realm: Realm!
    var budgetList: Results<Budget>!
    var notificationToken: NotificationToken?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Retrieve databse and list of previous budgets.
        self.realm = Database.getRealm()
        self.budgetList = realm.objects(Budget).filter("isCurrent = false").sorted("endDate", ascending: false)
        
        // Apply the Time to Budget theme to the view controller.
        let nav = self.navigationController!.navigationBar
        Style.navbar(nav)
        Style.viewController(self)
        
        // Set realm notification block to update the table view data whenever the database is changed.
        notificationToken = realm.addNotificationBlock { note, realm in
            self.tableView.reloadData()
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showHistoryBudget" {
            // Pass the selected budget into the Budget History View Controller
            let historyBudgetVC = segue.destinationViewController as? BudgetHistoryViewController
            let indexPath = self.tableView.indexPathForSelectedRow!
            historyBudgetVC?.currentBudget = self.budgetList[indexPath.row]
        }
    }

    // ======================= UITableViewDataSource Methods =======================
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Int(self.budgetList.count)
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return Factory.prepareBasicCell(tableView: self.tableView, titleText: self.budgetList[indexPath.row].name)
    }
    
    // ========================== UITableViewDelegate Methods ==========================
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("showHistoryBudget", sender: self)
    }
    
}
