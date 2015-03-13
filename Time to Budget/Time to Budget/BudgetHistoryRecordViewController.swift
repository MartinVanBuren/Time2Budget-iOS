//
//  BudgetHistoryRecordViewController.swift
//  Time to Budget
//
//  Created by Robert Kennedy on 3/12/15.
//  Copyright (c) 2015 Arrken Games, LLC. All rights reserved.
//

import UIKit
import Realm

class BudgetHistoryRecordViewController: UITableViewController {

    var currentRecord:Record?
    var currentTask:Task?
    var notificationToken: RLMNotificationToken?
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        self.tableView.reloadData()
    }

    // MARK: - Table view data source

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
        switch indexPath.row {
        case 0:
            let cell = Factory.prepareAddRecordTaskCell(tableView: tableView, currentTask: self.currentTask?)
            cell.accessoryType = UITableViewCellAccessoryType.None
            return cell
        case 1:
            let cell =  Factory.prepareAddRecordTimeCell(tableView: tableView, timeSpent: Time.doubleToTime(currentRecord!.timeSpent))
            cell.accessoryType = UITableViewCellAccessoryType.None
            return cell
        case 2:
            let cell =  Factory.prepareAddRecordDateCell(tableView: tableView, date: currentRecord?.date)
            cell.accessoryType = UITableViewCellAccessoryType.None
            return cell
        default:
            return Factory.prepareAddRecordMemoCell(tableView: tableView, memo: currentRecord?.note)
        }
    }
}
