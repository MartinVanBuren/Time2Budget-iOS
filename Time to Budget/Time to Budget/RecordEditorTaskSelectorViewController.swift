//
//  TaskSelectorViewController.swift
//  Time to Budget
//
//  Created by Robert Kennedy on 2/14/15.
//  Copyright (c) 2015 Arrken Games, LLC. All rights reserved.
//

import UIKit
import RealmSwift

class RecordEditorTaskSelectorViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var realm:Realm!
    var currentBudget:Budget!
    var recordEditorVC:RecordEditorViewController!
    @IBOutlet weak var tableView: UITableView!
    var delegate: writeTaskBackDelegate?
    var returning:Bool? = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var nib = UINib(nibName: "CategoryView", bundle: nil)
        self.tableView.registerNib(nib, forHeaderFooterViewReuseIdentifier: "CategoryView")
        
        nib = UINib(nibName: "DetailCell", bundle: nil)
        self.tableView.registerNib(nib, forCellReuseIdentifier: "DetailCell")
        
        nib = UINib(nibName: "SubtitleDetailCell", bundle: nil)
        self.tableView.registerNib(nib, forCellReuseIdentifier: "SubtitleDetailCell")
        
        Style.viewController(self, tableView: self.tableView)
        
        self.realm = Database.getRealm()
        self.currentBudget = realm.objects(Budget).filter("isCurrent = TRUE").first!

    }
    
    override func viewWillAppear(animated: Bool) {
        self.tableView.reloadData()
    }
    
    override func viewDidLayoutSubviews() {
        self.automaticallyAdjustsScrollViewInsets = false
        tableView.contentInset = UIEdgeInsetsMake(self.topLayoutGuide.length, 0, 54, 0)
    }
    
    //==================== UITableViewDataSource Methods ====================
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return Int(currentBudget.categories.count)
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return currentBudget.categories[section].tasks.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        return Factory.prepareTaskCell(tableView: tableView, categoryList: currentBudget.categories, indexPath: indexPath, editor: false)
        
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        return Factory.prepareCategoryView(tableView: tableView, categoryList: currentBudget.categories, section: section)
        
    }
    
    //==================== UITableViewDelegate Methods ====================
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let currentTask = currentBudget.categories[indexPath.section].tasks[indexPath.row]
        print("RecordEditorTaskSelector->currentTask.name", currentTask.name)
        self.delegate?.writeTaskBack(currentTask)
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 44
    }
    
    @IBAction func addTaskButtonPressed(sender: UIBarButtonItem) {
        performSegueWithIdentifier("showTaskEditorFromRecordEditor", sender: self)
    }
    
}
