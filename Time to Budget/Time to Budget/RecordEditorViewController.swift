//
//  RecordEditorViewController.swift
//  Time to Budget
//
//  Created by Robert Kennedy on 2/7/15.
//  Copyright (c) 2015 Arrken Games, LLC. All rights reserved.
//

import UIKit
import RealmSwift

class RecordEditorViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, writeTaskBackDelegate {
    
    @IBOutlet weak var saveRecordButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    var editRecord:Bool = false
    var currentTask:Task?
    var currentRecord:Record?
    
    var timeSpent:Time?
    var date:NSDate = NSDate()
    var memo:String?
    var returning:Bool? = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: "DetailCell", bundle: nil)
        self.tableView.registerNib(nib, forCellReuseIdentifier: "DetailCell")
        
        let nav = self.navigationController!.navigationBar
        Style.navbar(nav)
        Style.viewController(self, tableView: self.tableView)
        Style.button(self.saveRecordButton)
        
        if let unwrappedRecord = self.currentRecord {
            self.timeSpent = Time.doubleToTime(unwrappedRecord.timeSpent)
            self.date = unwrappedRecord.date
            self.memo = unwrappedRecord.note
            self.navigationItem.title = "Edit Record"
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        tableView.reloadData()
    }
    
    @IBAction func cancelButtonPressed(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //==================== Segue Preperation ====================
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "showTaskSelectorView") {
            let taskSelectorVC = (segue.destinationViewController as! RecordEditorTaskSelectorViewController)
            taskSelectorVC.delegate = self
        } else if (segue.identifier == "showTimePickerView") {
            let timePickerVC = segue.destinationViewController as! RecordEditorTimePickerViewController
            timePickerVC.recordEditorVC = self
        } else if (segue.identifier == "showDatePickerView") {
            let datePickerVC = segue.destinationViewController as! RecordEditorDatePickerViewController
            datePickerVC.recordEditorVC = self
        }
    }
    
    func writeTaskBack(task: Task) {
        self.currentTask = task
        self.tableView.reloadData()
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
            let preparedCell = Factory.prepareMemoTextfieldCell(tableView: tableView, memo: self.memo)
            preparedCell.textField.delegate = self
            return preparedCell
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
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
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
                if unwrappedTime.toDouble() != 0.0 {
                    if self.editRecord {
                        // Edit Record Mode
                        if let unwrappedRecord = self.currentRecord {
                            Database.updateRecord(record: unwrappedRecord, taskName: unwrappedTask.name, note: finalMemo, timeSpent: unwrappedTime.toDouble(), date: self.date)
                            self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
                        } else {
                            Factory.displayAlert(viewController: self, title: "Error: Record Missing", message: "Record missing while in edit mode. D':")
                        }
                    } else {
                        // New Record Mode
                        Database.addRecord(parentTask: unwrappedTask, note: finalMemo, timeSpent: unwrappedTime.toDouble(), date: self.date)
                        self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
                    }
                } else {
                    Factory.displayAlert(viewController: self, title: "Time Spent Cannot Be 0", message: "You must select an amount of time to spend.")
                }
                
            } else {
                Factory.displayAlert(viewController: self, title: "Time Spent Cannot Be 0", message: "You must select an amount of time to spend.")
            }
        } else {
            Factory.displayAlert(viewController: self, title: "Task Not Selected", message: "You must select a Task.")
        }
    }
    
}
