//
//  TrackingViewController.swift
//  Time to Budget
//
//  Created by Robert Kennedy on 2/7/15.
//  Copyright (c) 2015 Arrken Games, LLC. All rights reserved.
//

import UIKit
import Realm

class AddRecordViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    
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

        if let unwrappedDate = self.date? {
            
        } else {
            self.date = NSDate()
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
            let taskSelectorVC = segue.destinationViewController as TaskSelectorViewController
            taskSelectorVC.addRecordVC = self
        } else if (segue.identifier == "showTimePickerView") {
            let timePickerVC = segue.destinationViewController as TimePickerViewController
            timePickerVC.addRecordVC = self
        } else if (segue.identifier == "showDatePickerView") {
            let datePickerVC = segue.destinationViewController as DatePickerViewController
            datePickerVC.addRecordVC = self
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
            return Factory.prepareAddRecordTaskCell(tableView: tableView, currentTask: self.currentTask?)
        case 1:
            return Factory.prepareAddRecordTimeCell(tableView: tableView, timeSpent: self.timeSpent?)
        case 2:
            return Factory.prepareAddRecordDateCell(tableView: tableView, date: self.date)
        default:
            return Factory.prepareAddRecordMemoCell(tableView: tableView, memo: self.memo?)
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
        
        if let unwrappedTask = self.currentTask? {
            if let unwrappedTime = self.timeSpent? {
                if let unwrappedMemo = self.memo? {
                    if !editRecord {
                        Database.addRecord(taskName: unwrappedTask.name, note: unwrappedMemo, timeSpent: unwrappedTime.toDouble(), date: self.date!)
                    } else {
                        if let unwrappedRecord = self.currentRecord? {
                            Database.updateRecord(record: unwrappedRecord, taskName: unwrappedTask.name, note: unwrappedMemo, timeSpent: unwrappedTime.toDouble(), date: self.date!)
                        } else {
                            Factory.displayAlert(viewController: self, title: "Error: Record Missing", message: "Record missing while in edit mode. D':")
                        }
                    }
                } else {
                    if !editRecord {
                        Database.addRecord(taskName: unwrappedTask.name, note: "", timeSpent: unwrappedTime.toDouble(), date: self.date!)
                    } else {
                        if let unwrappedRecord = self.currentRecord? {
                            Database.updateRecord(record: unwrappedRecord, taskName: unwrappedTask.name, note: "", timeSpent: unwrappedTime.toDouble(), date: self.date!)
                        } else {
                            Factory.displayAlert(viewController: self, title: "Error: Record Missing", message: "Record missing while in edit mode. D':")
                        }
                    }
                }
            } else {
                Factory.displayAlert(viewController: self, title: "Time Spent Not Selected", message: "You must select an amount of time to spend.")
            }
        } else {
            Factory.displayAlert(viewController: self, title: "Task Not Selected", message: "You must select a Task.")
        }
    
        self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func fixContentInset(#calledFromSegue: Bool) {
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
