//
//  Style.swift
//  Time to Budget
//
//  Created by Robert Kennedy on 9/15/15.
//  Copyright (c) 2015 Arrken Games, LLC. All rights reserved.
//

import UIKit

/**
 Manages the style of every element in Time to Budget.
 
 The purpose of this class is to modify the style of UI elements in Time to Budget to make style changes more modular.
 This allows us to support multiple themes with ease.
 
 Class Attributes:
 + aquaBurst
 + sky
 + blue
 + green
 + yellow
 + red
 + grey
 + seperatorGrey
 + textColor
 + detailColor
 
 Class Methods:
 - navbar(nav: UINavigationBar)
 - viewController(vc: UITableViewController)
 - viewController(vc: UIViewController)
 - viewController(vc: UIViewController, tableView: UITableView)
 - button(button: UIButton)
 - picker(pickerData: Int)
 - picker(picker: UIDatePicker)
 - category(cell: CategoryCell)
 - category(view: CategoryView)
 - task(cell: DetailCell)
 - task(cell: SubtitleDetailCell)
 - record(cell: DetailCell)
 - record(cell: SubtitleDetailCell)
 - basicHeader(view: CategoryView)
 - detailCell(cell: DetailCell)
 - textfieldCell(cell: NameTextfieldCell)
 - textfieldCell(cell: MemoTextfieldCell)
 - categoryTimeRemainingBar(cell: CategoryCell)
 - categoryTimeRemainingBar(view: CategoryView)
 - taskTimeRemainingLabel(cell: DetailCell, task: Task, editor: Bool)
 - taskTimeRemainingLabel(cell: SubtitleDetailCell, task: Task, editor: Bool)
 */
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
    
    /**
     Sets the Style of the Navigation Bar for Time to Budget.
     
     - Parameter nav: UINavigationBar for Style to be applied to.
     - returns: Nothing
     */
    class func navbar(nav: UINavigationBar) {
        nav.barStyle = UIBarStyle.Black
        nav.tintColor = UIColor.whiteColor()
        nav.barTintColor = UIColor(red: 80/255, green: 83/255, blue: 90/255, alpha: 1.0)
    }
    
    /**
     Sets the Style of any TableViewControllers for Time to Budget.
     
     - Parameter vc: UITableViewController for Style to be applied to.
     - returns: Nothing
     */
    class func viewController(vc: UITableViewController) {
        vc.tableView.backgroundColor = self.grey
        vc.tableView.separatorColor = self.seperatorGrey
        vc.tableView.separatorInset = UIEdgeInsets(top: 0, left: 25, bottom: 0, right: 0)
    }
    
    /**
     Sets the Style of any ViewController for Time to Budget.
     
     - Parameter vc: UIViewController for Style to be applied to.
     - returns: Nothing
     */
    class func viewController(vc: UIViewController) {
        vc.view.backgroundColor = self.grey
    }
    
    /**
     Sets the Style of any ViewControllers containing TableViews for Time to Budget.
     
     - Parameter vc: UIViewController for Style to be applied to.
     - Parameter tableView: UITableView for Style to be applied to.
     - returns: Nothing
     */
    class func viewController(vc: UIViewController, tableView: UITableView) {
        vc.view.backgroundColor = self.grey
        tableView.backgroundColor = self.grey
        tableView.separatorColor = self.seperatorGrey
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 25, bottom: 0, right: 0)
        tableView.indicatorStyle = UIScrollViewIndicatorStyle.White
    }
    
    /**
     Sets the Style of any UILabel for Time to Budget.
     
     - Parameter label: UILabel for Style to be applied to.
     - returns: Nothing
     */
    class func label(label: UILabel) {
        label.textColor = self.textColor
    }
    
    /**
     Sets the Style of any Button for Time to Budget.
     
     - Parameter button: UIButton for Style to be applied to.
     - returns: Nothing
     */
    class func button(button: UIButton) {
        button.backgroundColor = self.blue
        button.alpha = 0.90
        button.opaque = false
        
        button.layer.cornerRadius = CGRectGetWidth(button.frame)/8
        button.layer.masksToBounds = true
    }
    
    /**
     Sets the Style of any PickerViews for Time to Budget.
     
     - Parameter pickerData: Data for pickerView for Style to be applied to.
     - returns: Nothing
     */
    class func picker(pickerData: Int) -> NSAttributedString {
        let attributes : [String : AnyObject]? = [NSForegroundColorAttributeName : self.textColor]
        let attributedString = NSAttributedString(string: "\(pickerData)", attributes: attributes)
        return attributedString
    }
    
    /**
     Sets the Style of any DatePickers for Time to Budget.
     
     - Parameter picker: UIDatePicker for Style to be applied to.
     - returns: Nothing
     */
    class func picker(picker: UIDatePicker) {
        picker.setValue(self.textColor, forKeyPath: "textColor")
        picker.datePickerMode = UIDatePickerMode.CountDownTimer
        picker.datePickerMode = UIDatePickerMode.Date
    }
    
    /**
     Sets the Style of any Category Cells for Time to Budget.
     
     - Parameter cell: CategoryCell for Style to be applied to.
     - returns: CategoryCell after Style has been applied.
     */
    class func category(cell: CategoryCell) -> CategoryCell {
        cell.remainingTimeBarOutline.layer.cornerRadius = 60/8
        cell.remainingTimeBar.layer.cornerRadius = 60/8
        cell.remainingTimeBarOutline.layer.masksToBounds = true
        cell.remainingTimeBar.layer.masksToBounds = true
        cell.remainingTimeBarOutline.layer.borderWidth = 1.0
        
        cell.backgroundColor = self.grey
        cell.customContentView.backgroundColor = self.grey
        cell.customContentView.alpha = 0.90
        cell.customContentView.opaque = false
        cell.sectionNameLabel.textColor = self.textColor
        self.categoryTimeRemainingBar(cell)
        
        return cell
    }
    
    /**
     Sets the Style of any Category Views for Time to Budget.
     
     - Parameter view: CategoryView for Style to be applied to.
     - returns: CategoryView after Style has been applied.
     */
    class func category(view: CategoryView) -> CategoryView {
        
        view.remainingTimeBarOutline.layer.cornerRadius = 60/8
        view.remainingTimeBar.layer.cornerRadius = 60/8
        view.remainingTimeBarOutline.layer.masksToBounds = true
        view.remainingTimeBar.layer.masksToBounds = true
        view.remainingTimeBarOutline.layer.borderWidth = 1.0
        
        view.customContentView.backgroundColor = self.grey
        view.customContentView.alpha = 0.90
        view.customContentView.opaque = false
        view.sectionNameLabel.textColor = self.textColor
        self.categoryTimeRemainingBar(view)
        
        return view
    }
    
    /**
     Sets the Style of any Task Detail Cells for Time to Budget.
     
     - Parameter cell: DetailCell for Style to be applied to.
     - returns: DetailCell after Style has been applied.
     */
    class func task(cell: DetailCell) -> DetailCell {
        cell.backgroundColor = UIColor.clearColor()
        cell.customContentView.backgroundColor = UIColor.clearColor()
        cell.title.textColor = self.textColor
        self.taskTimeRemainingLabel(cell, task: cell.task!, editor: cell.editor!)
        
        return cell
    }
    
    /**
     Sets the Style of any Task Subtitle Detail Cells for Time to Budget.
     
     - Parameter cell: SubtitleDetailCell for Style to be applied to.
     - returns: SubtitleDetailCell after Style has been applied.
     */
    class func task(cell: SubtitleDetailCell) -> SubtitleDetailCell {
        cell.backgroundColor = UIColor.clearColor()
        cell.customContentView.backgroundColor = UIColor.clearColor()
        cell.title.textColor = self.textColor
        cell.subtitle.textColor = self.textColor
        self.taskTimeRemainingLabel(cell, task: cell.task!, editor: cell.editor!)
        
        return cell
    }
    
    /**
     Sets the Style of any Record Detail Cells for Time to Budget.
     
     - Parameter cell: DetailCell for Style to be applied to.
     - returns: DetailCell after Style has been applied.
     */
    class func record(cell: DetailCell) -> DetailCell {
        cell.title.textColor = self.textColor
        cell.detail.textColor = self.detailColor
        cell.backgroundColor = UIColor.clearColor()
        
        return cell
    }
    
    /**
     Sets the Style of any Record Subtitle Detail Cells for Time to Budget.
     
     - Parameter cell: SubtitleDetailCell for Style to be applied to.
     - returns: SubtitleDetailCell after Style has been applied.
     */
    class func record(cell: SubtitleDetailCell) -> SubtitleDetailCell {
        cell.title.textColor = self.textColor
        cell.subtitle.textColor = self.textColor
        cell.detail.textColor = self.detailColor
        cell.backgroundColor = UIColor.clearColor()
        
        return cell
    }
    
    /**
     Sets the Style of any generic Header Views for Time to Budget.
     
     - Parameter view: CategoryView for Style to be applied to.
     - returns: CategoryView after Style has been applied.
     */
    class func basicHeader(view: CategoryView) -> CategoryView {
        // View background settings
        view.customContentView.backgroundColor = self.grey
        view.customContentView.alpha = 0.90
        view.customContentView.opaque = false
        
        // Section Bar Colors
        view.sectionNameLabel.textColor = self.textColor
        view.remainingTimeBar.backgroundColor = self.blue
        view.remainingTimeBarOutline.layer.borderColor = self.blue.CGColor
        
        // Section Bar Rounding
        view.remainingTimeBarOutline.layer.cornerRadius = 60/8
        view.remainingTimeBarOutline.layer.masksToBounds = true
        view.remainingTimeBarOutline.layer.borderWidth = 1.0
        
        // Section Bar Set to Full
        view.remainingTimeBar.layer.mask = nil
        
        return view
    }
    
    /**
     Sets the Style of any generic Detail Cells for Time to Budget.
     
     - Parameter cell: DetailCell for Style to be applied to.
     - returns: DetailCell after Style has been applied.
     */
    class func detailCell(cell: DetailCell) -> DetailCell {
        cell.backgroundColor = UIColor.clearColor()
        cell.customContentView.backgroundColor = UIColor.clearColor()
        cell.title.textColor = self.textColor
        cell.detail.textColor = self.detailColor
        
        return cell
    }
    
    /**
     Sets the Style of any Name Textfield Cells for Time to Budget.
     
     - Parameter cell: NameTextfieldCell for Style to be applied to.
     - returns: NameTextfieldCell after Style has been applied.
     */
    class func textfieldCell(cell: NameTextfieldCell) -> NameTextfieldCell {
        cell.backgroundColor = UIColor.clearColor()
        
        return cell
    }
    
    /**
     Sets the Style of any Memo Textfield Cells for Time to Budget.
     
     - Parameter cell: MemoTextfieldCell for Style to be applied to.
     - returns: MemoTextfieldCell after Style has been applied.
     */
    class func textfieldCell(cell: MemoTextfieldCell) -> MemoTextfieldCell {
        
        cell.backgroundColor = UIColor.clearColor()
        
        return cell
    }
    
    /**
     Sets the Style of any Category Time Remaining Bars contained within a Category Cell for Time to Budget.
     
     - Parameter cell: CategoryCell for Style to be applied to.
     - returns: CategoryCell after Style has been applied.
     */
    private class func categoryTimeRemainingBar(cell: CategoryCell) -> CategoryCell {
        cell.remainingTimeLabel.textColor = self.textColor
        
        if cell.category!.totalTimeRemaining == cell.category!.totalTimeBudgeted {
            cell.remainingTimeBar.backgroundColor = self.blue
            cell.remainingTimeBarOutline.layer.borderColor = self.blue.CGColor
            cell.remainingTimeBar.layer.mask = nil
        } else {
            var barRatio:CGFloat!
            
            if cell.category!.totalTimeRemaining >= 0 {
                barRatio = CGFloat(cell.category!.totalTimeRemaining/cell.category!.totalTimeBudgeted)
                cell.remainingTimeBar.backgroundColor = self.blue
                cell.remainingTimeBarOutline.layer.borderColor = self.blue.CGColor
            } else if cell.category!.totalTimeRemaining < 0 {
                barRatio = CGFloat(cell.category!.totalTimeRemaining/cell.category!.totalTimeBudgeted) * -1.0
                cell.remainingTimeBar.backgroundColor = self.yellow
                cell.remainingTimeBarOutline.layer.borderColor = self.yellow.CGColor
            }
            
            let newWidth = cell.remainingTimeBar.frame.size.width * barRatio
            let oldHeight = cell.remainingTimeBar.frame.height
            let oldX = cell.remainingTimeBar.frame.origin.x
            let oldY = cell.remainingTimeBar.frame.origin.y
            
            let maskLayer = CAShapeLayer()
            let maskRect = CGRectMake(oldX, oldY, newWidth, oldHeight)
            let newPath = CGPathCreateWithRect(maskRect, nil)
            maskLayer.path = newPath
            
            cell.remainingTimeBar.layer.mask = maskLayer
        }
        
        return cell
    }
    
    /**
     Sets the Style of any Category Time Remaining Bars contained within a Category View for Time to Budget.
     
     - Parameter view: CategoryView for Style to be applied to.
     - returns: CategoryView after Style has been applied.
     */
    private class func categoryTimeRemainingBar(view: CategoryView) -> CategoryView {
        view.remainingTimeLabel.textColor = self.textColor
        
        if view.editor! {
            view.remainingTimeBar.backgroundColor = self.blue
            view.remainingTimeBarOutline.layer.borderColor = self.blue.CGColor
            view.remainingTimeBar.layer.mask = nil
        } else {
            if view.category!.totalTimeRemaining == view.category!.totalTimeBudgeted {
                view.remainingTimeBar.backgroundColor = self.blue
                view.remainingTimeBarOutline.layer.borderColor = self.blue.CGColor
                view.remainingTimeBar.layer.mask = nil
            } else {
                var barRatio:CGFloat!
                
                if view.category!.totalTimeRemaining >= 0 && view.category!.totalTimeBudgeted > 0 {
                    barRatio = CGFloat(view.category!.totalTimeRemaining/view.category!.totalTimeBudgeted)
                    view.remainingTimeBar.backgroundColor = self.blue
                    view.remainingTimeBarOutline.layer.borderColor = self.blue.CGColor
                } else if view.category!.totalTimeRemaining < 0 && view.category!.totalTimeBudgeted > 0 {
                    barRatio = CGFloat(view.category!.totalTimeRemaining/view.category!.totalTimeBudgeted) * -1
                    view.remainingTimeBar.backgroundColor = self.yellow
                    view.remainingTimeBarOutline.layer.borderColor = self.yellow.CGColor
                } else {
                    barRatio = CGFloat(1)
                    view.remainingTimeBar.backgroundColor = self.yellow
                    view.remainingTimeBarOutline.layer.borderColor = self.yellow.CGColor
                }
                
                let newWidth = view.remainingTimeBar.frame.size.width * barRatio
                let oldHeight = view.remainingTimeBar.frame.height
                let oldX = view.remainingTimeBar.frame.origin.x
                let oldY = view.remainingTimeBar.frame.origin.y
                
                let maskLayer = CAShapeLayer()
                let maskRect = CGRectMake(oldX, oldY, newWidth, oldHeight)
                let newPath = CGPathCreateWithRect(maskRect, nil)
                maskLayer.path = newPath
                
                view.remainingTimeBar.layer.mask = maskLayer
            }
        }
        
        return view
    }
    
    /**
     Sets the Style of any Task Time Remaining Labels contained within a Task Detail Cell for Time to Budget.
     
     - Parameter cell: DetailCell for Style to be applied to.
     - returns: DetailCell after Style has been applied.
     */
    private class func taskTimeRemainingLabel(cell: DetailCell, task: Task, editor: Bool) -> DetailCell {
        
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
    
    /**
     Sets the Style of any Task Time Remaining Labels contained within a Task Subtitle Detail Cell for Time to Budget.
     
     - Parameter cell: SubtitleDetailCell for Style to be applied to.
     - returns: SubtitleDetailCell after Style has been applied.
     */
    private class func taskTimeRemainingLabel(cell: SubtitleDetailCell, task: Task, editor: Bool) -> SubtitleDetailCell {
        
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