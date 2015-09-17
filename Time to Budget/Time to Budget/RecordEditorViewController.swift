//
//  TrackingViewController.swift
//  Time to Budget
//
//  Created by Robert Kennedy on 2/7/15.
//  Copyright (c) 2015 Arrken Games, LLC. All rights reserved.
//

import UIKit
import Realm

class RecordEditorViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    
    var editRecord:Bool = false
    var currentTask:Task?
    var currentRecord:Record?
    
    var timeSpent:Time?
    var date:NSDate?
    var memo:String?
    var returning:Bool? = false
    
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nav = self.navigationController?.navigationBar
        Style.navbarSetColor(nav: nav!)

        if let unwrappedDate = self.date {
            // Do nothing
        } else {
            self.date = NSDate()
        }
        
        if let unwrappedRecord = self.currentRecord {
            self.timeSpent = Time.doubleToTime(unwrappedRecord.timeSpent)
            self.date = unwrappedRecord.date
            self.memo = unwrappedRecord.note
            self.navigationItem.title = "Edit Record"
        }
    }
    
    override func viewDidLayoutSubviews() {
        if let rect = self.navigationController?.navigationBar.frame {
            let y = rect.size.height + rect.origin.y
            self.tableView.contentInset = UIEdgeInsetsMake(y, 0, 0, 0)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        //fixContentInset(calledFromSegue: false)
        tableView.reloadData()
    }
    
    @IBAction func cancelButtonPressed(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //==================== Segue Preperation ====================
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "showTaskSelectorView") {
            let taskSelectorVC = segue.destinationViewController as! RecordEditorTaskSelectorViewController
            taskSelectorVC.recordEditorVC = self
        } else if (segue.identifier == "showTimePickerView") {
            let timePickerVC = segue.destinationViewController as! RecordEditorTimePickerViewController
            timePickerVC.recordEditorVC = self
        } else if (segue.identifier == "showDatePickerView") {
            let datePickerVC = segue.destinationViewController as! RecordEditorDatePickerViewController
            datePickerVC.recordEditorVC = self
        }
        
        fixContentInset(calledFromSegue: true)
    }
    
    
    //==================== UITableViewDataSource Methods ====================
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            return Factory.prepareAddRecordTaskCell(tableView: tableView, currentTask: self.currentTask)
        case 1:
            return Factory.prepareAddRecordTimeCell(tableView: tableView, timeSpent: self.timeSpent)
        case 2:
            return Factory.prepareAddRecordDateCell(tableView: tableView, date: self.date)
        default:
            return Factory.prepareAddRecordMemoCell(tableView: tableView, memo: self.memo)
        }
    }
    
    //==================== UITableViewDataSource Methods ====================
    
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
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    //==================== UITextField Methods ====================
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    @IBAction func memoTextFieldChanged(sender: UITextField) {
        self.memo = sender.text
    }
    
    @IBAction func saveRecordButtonPressed(sender: UIButton) {
        var finalMemo = ""
        
        if let unwrappedMemo = self.memo {
            finalMemo = unwrappedMemo
        }
        
        if let unwrappedTask = self.currentTask {
            if let unwrappedTime = self.timeSpent {
                if self.editRecord {
                    // Edit Record Mode
                    if let unwrappedRecord = self.currentRecord {
                        try! Database.updateRecord(record: unwrappedRecord, taskName: unwrappedTask.name, note: finalMemo, timeSpent: unwrappedTime.toDouble(), date: self.date!)
                        self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
                    } else {
                        Factory.displayAlert(viewController: self, title: "Error: Record Missing", message: "Record missing while in edit mode. D':")
                    }
                } else {
                    // New Record Mode
                    try! Database.addRecord(parentTask: unwrappedTask, note: finalMemo, timeSpent: unwrappedTime.toDouble(), date: self.date!)
                    self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
                }
            } else {
                Factory.displayAlert(viewController: self, title: "Time Spent Not Selected", message: "You must select an amount of time to spend.")
            }
        } else {
            Factory.displayAlert(viewController: self, title: "Task Not Selected", message: "You must select a Task.")
        }
    }
    
    func fixContentInset(calledFromSegue calledFromSegue: Bool) {
        if calledFromSegue {
            if (returning != nil) {
                self.returning = true
            }
        } else {
            if (returning != nil) {
                if !returning! {
                    self.tableView.contentInset.top = 64
                }
                else if returning! {
                    self.tableView.contentInset.top -= 64
                    self.returning = nil
                }
            }
            else {
                
            }
        }
    }
}
