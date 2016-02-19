//
//  TaskEditorCategorySelectorViewController.swift
//  Time to Budget
//
//  Created by Robert Kennedy on 3/1/15.
//  Copyright (c) 2015 Arrken Games, LLC. All rights reserved.
//

import UIKit
import RealmSwift
import Instructions

class TaskEditorCategorySelectorViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, CoachMarksControllerDataSource {

    //========== View Properties ==========
    var taskEditorVC:TaskEditorViewController!
    var delegate: writeCategoryBackDelegate?
    var returning:Bool? = false
    @IBOutlet weak var tableView: UITableView!
    let tutorialController = CoachMarksController()
    
    //========== Realm Properties ==========
    var realm:Realm!
    var currentBudget:Budget!
    var notificationToken:NotificationToken!
    
    //==================== View Controller Methods ====================
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup tutorial controller
        tutorialController.datasource = self
        Style.tutorialController(self.tutorialController)
        
        // Register nibs for Cells/Headers
        let catCellNib = UINib(nibName: "CategoryCell", bundle: nil)
        self.tableView.registerNib(catCellNib, forCellReuseIdentifier: "CategoryCell")
        
        // Apply Time to Budget theme to this view and table view.
        Style.viewController(self, tableView: self.tableView)
        
        // Retrieve database and current budget.
        self.realm = Database.getRealm()
        self.currentBudget = Database.budgetSafetyNet()
        
        // Create realm notification token to update this table view on databse changes.
        notificationToken = realm.addNotificationBlock { notification, realm in
            self.currentBudget = realm.objects(Budget).filter("isCurrent = true").first!
            self.tableView.reloadData()
        }
        
        self.tableView.reloadData()
    }
    
    override func viewDidAppear(animated: Bool) {
        if Tutorial.shouldRun(addTaskView: true) {
            self.tutorialController.startOn(self)
        }
    }
    
    override func viewDidLayoutSubviews() {
        // Adjust table view content insets
        self.automaticallyAdjustsScrollViewInsets = false
        self.tableView.contentInset = UIEdgeInsetsMake(self.topLayoutGuide.length, 0, 54, 0)
        self.tableView.scrollToRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0), atScrollPosition: UITableViewScrollPosition.Top, animated: false)
        
        // Setup tutorial points of interest
        self.tableView.reloadData()
        Tutorial.addTaskPOI[0] = self.navigationController?.navigationBar
        Tutorial.addTaskPOI[1] = (self.navigationItem.rightBarButtonItem!.valueForKey("view") as! UIView)
    }
    
    //==================== UITableViewDataSource Methods ====================
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Int(self.currentBudget.categories.count)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let catCell = Factory.prepareCategoryCell(tableView: self.tableView, categoryList: self.currentBudget.categories, section: indexPath.row)
        
        if indexPath.section == 0 && indexPath.row == 0 {
            Tutorial.addTaskPOI[0] = catCell
        }
        
        return catCell
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UITableViewHeaderFooterView()
    }
    
    //==================== UITableViewDelegate Methods ====================
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // Pass the category selected back to the Task Editor view and then return to previous view.
        self.delegate?.writeCategoryBack(currentBudget.categories[indexPath.row])
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    //==================== IBAction Methods ====================
    @IBAction func addCategoryButtonPressed(sender: UIBarButtonItem) {
        Factory.displayAddCategoryAlert(viewController: self)
    }
    
    //==================== CoachMarksControllerDataSource Methods ====================
    func numberOfCoachMarksForCoachMarksController(coachMarksController: CoachMarksController) -> Int {
        return Tutorial.addTaskPOI.count
    }
    
    func coachMarksController(coachMarksController: CoachMarksController, coachMarksForIndex index: Int) -> CoachMark {
        return coachMarksController.coachMarkForView(Tutorial.addTaskPOI[index] as UIView!)
    }
    
    func coachMarksController(coachMarksController: CoachMarksController, coachMarkViewsForIndex index: Int, coachMark: CoachMark) -> (bodyView: CoachMarkBodyView, arrowView: CoachMarkArrowView?) {
        let coachViews = coachMarksController.defaultCoachViewsWithArrow(true, arrowOrientation: coachMark.arrowOrientation)
        
        coachViews.bodyView.hintLabel.text = Tutorial.getHintLabelForIndex(index, addTaskView: true)
        coachViews.bodyView.nextLabel.text = Tutorial.getNextLabel()
        
        return (bodyView: coachViews.bodyView, arrowView: coachViews.arrowView)
        
    }
}
