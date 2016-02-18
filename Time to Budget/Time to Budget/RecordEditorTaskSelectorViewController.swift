//
//  TaskSelectorViewController.swift
//  Time to Budget
//
//  Created by Robert Kennedy on 2/14/15.
//  Copyright (c) 2015 Arrken Games, LLC. All rights reserved.
//

import UIKit
import RealmSwift
import Instructions

class RecordEditorTaskSelectorViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, CoachMarksControllerDataSource {

    //========== View Properties ==========
    var recordEditorVC:RecordEditorViewController!
    var delegate: writeTaskBackDelegate?
    var returning:Bool? = false
    @IBOutlet weak var tableView: UITableView!
    let tutorialController = CoachMarksController()
    
    //========== Realm Properties ==========
    var realm:Realm!
    var currentBudget:Budget!
    
    //==================== View Controller Methods ====================
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup Tutorial controller
        self.tutorialController.datasource = self
        
        // Register Nibs for Cells/Header Views
        let catViewNib = UINib(nibName: "CategoryView", bundle: nil)
        let detailNib = UINib(nibName: "DetailCell", bundle: nil)
        let subtitleNib = UINib(nibName: "SubtitleDetailCell", bundle: nil)
        self.tableView.registerNib(catViewNib, forHeaderFooterViewReuseIdentifier: "CategoryView")
        self.tableView.registerNib(detailNib, forCellReuseIdentifier: "DetailCell")
        self.tableView.registerNib(subtitleNib, forCellReuseIdentifier: "SubtitleDetailCell")
        
        // Apply Time to Bduget theme to this view.
        Style.viewController(self, tableView: self.tableView)
        
        // Retrieve database and current budget.
        self.realm = Database.getRealm()
        self.currentBudget = Database.budgetSafetyNet()
    }
    
    override func viewWillAppear(animated: Bool) {
        self.currentBudget = Database.budgetSafetyNet()
        self.tableView.reloadData()
    }
    
    override func viewDidAppear(animated: Bool) {
        if Tutorial.shouldRun(addRecordView: true) {
            self.tutorialController.startOn(self)
        }
    }
    
    override func viewDidLayoutSubviews() {
        // Adjust table view insets
        self.automaticallyAdjustsScrollViewInsets = false
        self.tableView.contentInset = UIEdgeInsetsMake(self.topLayoutGuide.length, 0, 54, 0)
        
        // Setup Tutorial points of interest
        self.tableView.reloadData()
        Tutorial.addRecordPOI[0] = self.navigationController?.navigationBar
        Tutorial.addRecordPOI[1] = (self.navigationItem.rightBarButtonItem!.valueForKey("view") as! UIView)
    }
    
    //==================== UITableViewDataSource Methods ====================
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return Int(currentBudget.categories.count)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentBudget.categories[section].tasks.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let taskCell = Factory.prepareTaskCell(tableView: tableView, categoryList: currentBudget.categories, indexPath: indexPath, editor: false)
        
        if indexPath.section == 0 && indexPath.row == 0 {
            Tutorial.addRecordPOI[0] = taskCell
        }
        
        return taskCell
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return Factory.prepareCategoryView(tableView: tableView, categoryList: currentBudget.categories, section: section)
    }
    
    //==================== UITableViewDelegate Methods ====================
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // Pass the selected task back to the Record Editor and return to that view.
        let currentTask = currentBudget.categories[indexPath.section].tasks[indexPath.row]
        print("RecordEditorTaskSelector->currentTask.name", currentTask.name)
        self.delegate?.writeTaskBack(currentTask)
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    //==================== IBAction Methods ====================
    @IBAction func addTaskButtonPressed(sender: UIBarButtonItem) {
        performSegueWithIdentifier("showTaskEditorFromRecordEditor", sender: self)
    }
    
    //==================== CoachMarksControllerDataSource Methods ====================
    func numberOfCoachMarksForCoachMarksController(coachMarksController: CoachMarksController) -> Int {
        return Tutorial.addRecordPOI.count
    }
    
    func coachMarksController(coachMarksController: CoachMarksController, coachMarksForIndex index: Int) -> CoachMark {
        return coachMarksController.coachMarkForView(Tutorial.addRecordPOI[index] as UIView!)
    }
    
    func coachMarksController(coachMarksController: CoachMarksController, coachMarkViewsForIndex index: Int, coachMark: CoachMark) -> (bodyView: CoachMarkBodyView, arrowView: CoachMarkArrowView?) {
        let coachViews = coachMarksController.defaultCoachViewsWithArrow(true, arrowOrientation: coachMark.arrowOrientation)
        
        coachViews.bodyView.hintLabel.text = Tutorial.getHintLabelForIndex(index, addRecordView: true)
        coachViews.bodyView.nextLabel.text = Tutorial.getNextLabel()
        
        return (bodyView: coachViews.bodyView, arrowView: coachViews.arrowView)
        
    }
}






