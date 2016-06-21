import UIKit
import Instructions

public class Style {
    private static let aquaBurst = UIColor(red: 0/255, green: 223/255, blue: 252/255, alpha: 255/255)
    private static let sky = UIColor(red: 102/255, green: 204/255, blue: 255/255, alpha: 1.0)
    private static let blue = UIColor(red: 105/255, green: 175/255, blue: 239/255, alpha: 1.0)
    private static let green = UIColor(red: 136/255, green: 209/255, blue: 115/255, alpha: 1.0)
    private static let yellow = UIColor(red: 253/255, green: 199/255, blue: 103/255, alpha: 1.0)
    private static let red = UIColor(red: 252/255, green: 87/255, blue: 63/255, alpha: 1.0)
    private static let grey = UIColor(red: 52/255, green: 56/255, blue: 56/255, alpha: 1.0)
    private static let seperatorGrey = UIColor(white: 0.5, alpha: 1.0)
    private static let textColor = UIColor.whiteColor()
    private static let detailColor = UIColor(white: 0.95, alpha: 1.0)
    private static let tutorialOverlayColor = UIColor(red: 170/255, green: 170/255, blue: 170/255, alpha: 0.60)
    
    class func tutorialController(tut: CoachMarksController) {
        tut.overlayBackgroundColor = self.tutorialOverlayColor
        tut.allowOverlayTap = true
    }
    
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
        tableView.indicatorStyle = UIScrollViewIndicatorStyle.White
    }

    class func label(label: UILabel) {
        label.textColor = self.textColor
    }

    class func button(button: UIButton) {
        button.backgroundColor = self.blue
        button.alpha = 0.90
        button.opaque = false
        
        button.layer.cornerRadius = CGRectGetHeight(button.frame)/4
        button.layer.masksToBounds = true
    }

    class func picker(pickerData: Int) -> NSAttributedString {
        let attributes: [String: AnyObject]? = [NSForegroundColorAttributeName: self.textColor]
        let attributedString = NSAttributedString(string: "\(pickerData)", attributes: attributes)
        return attributedString
    }
    
    class func picker(picker: UIDatePicker) {
        picker.setValue(self.textColor, forKeyPath: "textColor")
        picker.datePickerMode = UIDatePickerMode.CountDownTimer
        picker.datePickerMode = UIDatePickerMode.Date
    }

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

    private class func categoryTimeRemainingBar(cell: CategoryCell) -> CategoryCell {
        cell.remainingTimeLabel.textColor = self.textColor
        
        if cell.category!.totalTimeRemaining == cell.category!.totalTimeBudgeted {
            cell.remainingTimeBar.backgroundColor = self.blue
            cell.remainingTimeBarOutline.layer.borderColor = self.blue.CGColor
            cell.remainingTimeBar.layer.mask = nil
        } else {
            var barRatio: CGFloat!
            
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
                var barRatio: CGFloat!
                
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
