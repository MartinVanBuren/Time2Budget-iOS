import UIKit
import RealmSwift

class BudgetHistoryListViewController: UITableViewController {
    
    // ============= Realm Properties =============
    var realm: Realm!
    var budgetList: Results<Budget>!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Retrieve databse and list of previous budgets.
        realm = Database.getRealm()
        budgetList = realm.objects(Budget).filter("isCurrent = false").sorted("endDate", ascending: false)
        
        // Apply the Time to Budget theme to the view controller.
        let nav = navigationController!.navigationBar
        Style.navbar(nav)
        Style.viewController(self)
    }
    
    override func viewWillAppear(animated: Bool) {
        tableView.reloadData()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showHistoryBudget" {
            // Pass the selected budget into the Budget History View Controller
            let historyBudgetVC = segue.destinationViewController as? BudgetHistoryViewController
            let indexPath = tableView.indexPathForSelectedRow!
            historyBudgetVC?.currentBudget = budgetList[indexPath.row]
        }
    }

    // ======================= UITableViewDataSource Methods =======================
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Int(budgetList.count)
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return Factory.prepareBasicCell(tableView: tableView, titleText: budgetList[indexPath.row].name)
    }
    
    // ========================== UITableViewDelegate Methods ==========================
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("showHistoryBudget", sender: self)
    }
    
}
