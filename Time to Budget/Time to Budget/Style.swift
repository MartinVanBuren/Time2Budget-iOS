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
    class func navbarSetColor(nav nav: UINavigationBar) {
        
        nav.barStyle = UIBarStyle.Black
        nav.tintColor = UIColor.whiteColor()
        nav.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        nav.barTintColor = UIColor(red: 29/255, green: 98/255, blue: 240/255, alpha: 255/255)
    }
    
    class func categoryCellBackgroundColors(cell: CategoryCell) -> CategoryCell {
        
        cell.customContentView.backgroundColor = UIColor.whiteColor()
        
        return cell
    }
    
    class func categoryViewBackgroundColors(view: CategoryView) -> CategoryView {
        
        view.sectionNameLabel.textColor = UIColor.whiteColor()
        view.customContentView.backgroundColor = UIColor(red: 122/255, green: 158/255, blue: 224/255, alpha: 255/255)
        view.customContentView.alpha = 0.75
        view.customContentView.opaque = false
        
        return view
    }
    
    class func categoryCellTimeRemainingLabelStyle(cell:CategoryCell, category:Category) -> CategoryCell {
        
        cell.sectionNameLabel.textColor = UIColor.blackColor()
        cell.remainingTimeLabel.textColor = UIColor.whiteColor()
        
        if category.totalTimeRemaining > 0.0 {
            cell.remainingTimeLabel.backgroundColor = UIColor(red: 0.25, green: 0.65, blue: 0.05, alpha: 1.0)
        } else if category.totalTimeRemaining < 0.0 {
            cell.remainingTimeLabel.backgroundColor = UIColor.redColor()
        } else {
            cell.remainingTimeLabel.backgroundColor = UIColor(red: 85/255, green: 85/255, blue: 85/255, alpha: 1.0)
        }
        
        cell.remainingTimeLabel.layer.cornerRadius = CGRectGetWidth(cell.remainingTimeLabel.frame)/8
        cell.remainingTimeLabel.layer.borderWidth = 1.0
        cell.remainingTimeLabel.layer.masksToBounds = true
        
        cell.remainingTimeLabel.alpha = 0.75
        cell.remainingTimeLabel.opaque = false;
        
        return cell
    }
    
    class func categoryViewTimeRemainingLabelStyle(view: CategoryView, category:Category, isEditor:Bool) -> CategoryView {
        view.remainingTimeLabel.textColor = UIColor.whiteColor()
        
        if isEditor {
            view.remainingTimeLabel.backgroundColor = UIColor.darkGrayColor()
        } else {
            if category.totalTimeRemaining > 0.0 {
                view.remainingTimeLabel.backgroundColor = UIColor(red: 0.25, green: 0.65, blue: 0.05, alpha: 1.0)
            } else if category.totalTimeRemaining < 0.0 {
                view.remainingTimeLabel.backgroundColor = UIColor.redColor()
            } else {
                view.remainingTimeLabel.backgroundColor = UIColor(red: 85/255, green: 85/255, blue: 85/255, alpha: 1.0)
            }
        }
        
        view.remainingTimeLabel.layer.cornerRadius = 60/8
        view.remainingTimeLabel.layer.borderWidth = 1.0
        view.remainingTimeLabel.layer.masksToBounds = true
        
        return view
    }
    
    class func taskDetailCellTimeRemainingLabelStyle(cell:DetailCell, task:Task, editor:Bool) -> DetailCell {
        
        if !editor {
            if task.timeRemaining > 0.0 {
                cell.detail.textColor = UIColor(red: 0.25, green: 0.65, blue: 0.05, alpha: 1.0)
            } else if task.timeRemaining < 0.0 {
                cell.detail.textColor = UIColor.redColor()
            } else {
                cell.detail.textColor = UIColor(red: 127/255, green: 127/255, blue: 127/255, alpha: 1.0)
            }
        } else {
            cell.detail.textColor = UIColor.darkGrayColor()
        }
        
        return cell
    }
    
    class func taskSubtitleDetailCellTimeRemainingLabelStyle(cell:SubtitleDetailCell, task:Task, editor:Bool) -> SubtitleDetailCell {
        
        if !editor {
            if task.timeRemaining > 0.0 {
                cell.detail.textColor = UIColor(red: 0.25, green: 0.65, blue: 0.05, alpha: 1.0)
            } else if task.timeRemaining < 0.0 {
                cell.detail.textColor = UIColor.redColor()
            } else {
                cell.detail.textColor = UIColor(red: 127/255, green: 127/255, blue: 127/255, alpha: 1.0)
            }
        } else {
            cell.detail.textColor = UIColor.darkGrayColor()
        }
        
        return cell
    }
}