//
//  Style.swift
//  Time to Budget
//
//  Created by Robert Kennedy on 9/15/15.
//  Copyright (c) 2015 Arrken Games, LLC. All rights reserved.
//

import Foundation
import UIKit

public class Style {
    private static let aquaBurst = UIColor(red: 0/255, green: 223/255, blue: 252/255, alpha: 255/255)
    private static let sky = UIColor(red: 102/255, green: 204/255, blue: 255/255, alpha: 1.0)
    private static let blue = UIColor(red: 105/255, green: 175/255, blue: 239/255, alpha: 1.0)
    private static let green = UIColor(red: 136/255, green: 209/255, blue: 115/255, alpha: 1.0)
    private static let yellow = UIColor(red: 253/255, green: 199/255, blue: 103/255, alpha: 1.0)
    private static let red = UIColor(red: 252/255, green: 87/255, blue: 63/255, alpha: 1.0)
    private static let grey = UIColor(red: 52/255, green: 56/255, blue: 56/255, alpha: 255/255)
    private static let seperatorGrey = UIColor(white: 0.5, alpha: 1.0)
    private static let textColor = UIColor.whiteColor()
    private static let detailColor = UIColor(white: 0.95, alpha: 1.0)
    
    class func navbar(nav: UINavigationBar) {
        nav.barStyle = UIBarStyle.Black
        nav.tintColor = UIColor.whiteColor()
        nav.barTintColor = UIColor(red: 80/255, green: 83/255, blue: 90/255, alpha: 1.0)
    }
    
    class func viewController(vc: UITableViewController) {
        
        vc.tableView.backgroundColor = self.grey
        vc.tableView.separatorColor = self.seperatorGrey
        vc.tableView.separatorInset = UIEdgeInsets(top: 0, left: 25, bottom: 0, right: 0)
    }
    
    class func viewController(vc: UIViewController) {
        
        vc.view.backgroundColor = self.grey
    }
    
    class func viewController(vc: UIViewController, tableView: UITableView) {
        
        vc.view.backgroundColor = self.grey
        tableView.backgroundColor = self.grey
        tableView.separatorColor = self.seperatorGrey
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 25, bottom: 0, right: 0)
    }
    
    class func button(button: UIButton) {
        
        button.backgroundColor = self.blue
    }
    
    class func picker(pickerData: Int) -> NSAttributedString {
        
        let attributes : [String : AnyObject]? = [NSForegroundColorAttributeName : self.textColor]
        let attributedString = NSAttributedString(string: "\(pickerData)", attributes: attributes)
        
        return attributedString
    }
    
    class func picker(picker: UIDatePicker) {
        
        picker.setValue(self.textColor, forKeyPath: "textColor")
        picker.datePickerMode = UIDatePickerMode.CountDownTimer
        picker.datePickerMode = UIDatePickerMode.Date
    }
    
    class func category(cell: CategoryCell) -> CategoryCell {
        
        cell.backgroundColor = UIColor.clearColor()
        cell.sectionNameLabel.textColor = self.textColor
        self.categoryTimeRemainingLabel(cell, category: cell.category!)
        
        return cell
    }
    
    class func category(cell: CategoryView) -> CategoryView {
        
        cell.contentView.backgroundColor = UIColor.clearColor()
        cell.sectionNameLabel.textColor = self.textColor
        self.categoryTimeRemainingLabel(cell, category: cell.category!, editor: cell.editor!)
        
        return cell
    }
    
    class func task(cell: DetailCell) -> DetailCell {
        
        cell.backgroundColor = UIColor.clearColor()
        cell.customContentView.backgroundColor = UIColor.clearColor()
        cell.title.textColor = self.textColor
        self.taskTimeRemainingLabel(cell, task: cell.task!, editor: cell.editor!)
        
        return cell
    }
    
    class func task(cell: SubtitleDetailCell) -> SubtitleDetailCell {
        
        cell.backgroundColor = UIColor.clearColor()
        cell.customContentView.backgroundColor = UIColor.clearColor()
        cell.title.textColor = self.textColor
        cell.subtitle.textColor = self.textColor
        self.taskTimeRemainingLabel(cell, task: cell.task!, editor: cell.editor!)
        
        return cell
    }
    
    class func record(cell: DetailCell) -> DetailCell {
        
        cell.title.textColor = self.textColor
        cell.detail.textColor = self.detailColor
        cell.backgroundColor = UIColor.clearColor()
        
        return cell
    }
    
    class func record(cell: SubtitleDetailCell) -> SubtitleDetailCell {
        
        cell.title.textColor = self.textColor
        cell.subtitle.textColor = self.textColor
        cell.detail.textColor = self.detailColor
        cell.backgroundColor = UIColor.clearColor()
        
        return cell
    }
    
    class func basicHeader(view: CategoryView) -> CategoryView {
        
        view.sectionNameLabel.textColor = self.textColor
        view.contentView.backgroundColor = UIColor.clearColor()
        
        return view
    }
    
    class func detailCell(cell: DetailCell) -> DetailCell {
        
        cell.backgroundColor = UIColor.clearColor()
        cell.customContentView.backgroundColor = UIColor.clearColor()
        cell.title.textColor = self.textColor
        cell.detail.textColor = self.detailColor
        
        return cell
    }
    
    class func textfieldCell(cell: NameTextfieldCell) -> NameTextfieldCell {
        
        cell.backgroundColor = UIColor.clearColor()
        
        return cell
    }
    
    class func textfieldCell(cell: MemoTextfieldCell) -> MemoTextfieldCell {
        
        cell.backgroundColor = UIColor.clearColor()
        
        return cell
    }
    
    private class func categoryTimeRemainingLabel(cell:CategoryCell, category:Category) -> CategoryCell {
        
        cell.remainingTimeLabel.textColor = UIColor.blackColor()
        
        cell.remainingTimeLabel.layer.cornerRadius = CGRectGetWidth(cell.remainingTimeLabel.frame)/8
        cell.remainingTimeLabel.layer.masksToBounds = true
        
        cell.remainingTimeLabel.alpha = 0.75
        cell.remainingTimeLabel.opaque = false;
        
        if category.totalTimeRemaining > 0.0 {
            cell.remainingTimeLabel.backgroundColor = self.blue
        } else if category.totalTimeRemaining < 0.0 {
            cell.remainingTimeLabel.backgroundColor = self.yellow
        } else {
            cell.remainingTimeLabel.backgroundColor = self.grey
            cell.remainingTimeLabel.textColor = self.textColor
            cell.remainingTimeLabel.layer.borderWidth = 1.0
            //cell.remainingTimeLabel.layer.borderColor = self.textColor.CGColor
        }
        
        return cell
    }
    
    private class func categoryTimeRemainingLabel(view: CategoryView, category:Category, editor:Bool) -> CategoryView {
        view.remainingTimeLabel.textColor = UIColor.blackColor()
        
        view.remainingTimeLabel.layer.cornerRadius = 60/8
        view.remainingTimeLabel.layer.masksToBounds = true
        
        if editor {
            view.remainingTimeLabel.backgroundColor = self.blue
        } else {
            if category.totalTimeRemaining > 0.0 {
                view.remainingTimeLabel.backgroundColor = self.blue
            } else if category.totalTimeRemaining < 0.0 {
                view.remainingTimeLabel.backgroundColor = self.yellow
            } else {
                view.remainingTimeLabel.backgroundColor = self.grey
                view.remainingTimeLabel.textColor = self.textColor
                view.remainingTimeLabel.layer.borderWidth = 1.0
                //view.remainingTimeLabel.layer.borderColor = self.textColor.CGColor
            }
        }
        
        return view
    }
    
    private class func taskTimeRemainingLabel(cell:DetailCell, task:Task, editor:Bool) -> DetailCell {
        
        if editor {
            cell.detail.textColor = self.detailColor
        } else {
            if task.timeRemaining > 0.0 {
                cell.detail.textColor = self.blue
            } else if task.timeRemaining < 0.0 {
                cell.detail.textColor = self.yellow
            } else {
                cell.detail.textColor = self.textColor
            }
        }
        
        return cell
    }
    
    private class func taskTimeRemainingLabel(cell:SubtitleDetailCell, task:Task, editor:Bool) -> SubtitleDetailCell {
        
        if editor {
            cell.detail.textColor = self.detailColor
        } else {
            if task.timeRemaining > 0.0 {
                cell.detail.textColor = self.blue
            } else if task.timeRemaining < 0.0 {
                cell.detail.textColor = self.yellow
            } else {
                cell.detail.textColor = self.textColor
            }
        }
        
        return cell
    }
}