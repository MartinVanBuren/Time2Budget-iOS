//
//  BudgetHistoryRecordViewController.swift
//  Time to Budget
//
//  Created by Robert Kennedy on 3/12/15.
//  Copyright (c) 2015 Arrken Games, LLC. All rights reserved.
//

import UIKit
import RealmSwift

class BudgetHistoryRecordViewController: UITableViewController {

    //========== Realm Properties ==========
    var currentRecord:Record?
    var currentTask:Task?
    
    //==================== View Controller Methods ====================
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Retrieve and register the nib files for tableView elements.
        let detailNib = UINib(nibName: "DetailCell", bundle: nil)
        self.tableView.registerNib(detailNib, forCellReuseIdentifier: "DetailCell")
        
        // Apple the Time to Budget theme to this view and navigation bar.
        let nav = self.navigationController!.navigationBar
        Style.navbar(nav)
        Style.viewController(self)
    }
    
    override func viewWillAppear(animated: Bool) {
        self.tableView.reloadData()
    }

    //==================== UITableViewDataSource Methods ====================
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
            let cell = Factory.prepareAddRecordTaskCell(tableView: tableView, currentTask: self.currentTask)
            cell.accessoryType = UITableViewCellAccessoryType.None
            cell.userInteractionEnabled = false
            return cell
        case 1:
            let cell =  Factory.prepareAddRecordTimeCell(tableView: tableView, timeSpent: Time(newTime: currentRecord!.timeSpent))
            cell.accessoryType = UITableViewCellAccessoryType.None
            cell.userInteractionEnabled = false
            return cell
        case 2:
            let cell =  Factory.prepareAddRecordDateCell(tableView: tableView, date: currentRecord?.date)
            cell.accessoryType = UITableViewCellAccessoryType.None
            cell.userInteractionEnabled = false
            return cell
        default:
            let cell = Factory.prepareMemoTextfieldCell(tableView: tableView, memo: currentRecord?.note)
            cell.textField.placeholder = "No Memo"
            cell.userInteractionEnabled = false
            return cell
        }
    }
    
    //==================== UITableViewDelegate Methods ====================
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}
