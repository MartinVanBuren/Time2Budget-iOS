import UIKit
import RealmSwift

class CellFactory {
    
    func prepareCategoryCell(tableView tableView: UITableView, categoryList: List<Category>, section: Int) -> CategoryCell {
        
        let thisCategory = categoryList[section]
        
        if let preparedCell = tableView.dequeueReusableCellWithIdentifier("CategoryCell") as? CategoryCell {
            preparedCell.customContentView.backgroundColor = UIColor.clearColor()
            preparedCell.backgroundColor = UIColor.clearColor()
            
            preparedCell.sectionNameLabel.text = thisCategory.name
            
            preparedCell.remainingTimeBarOutline.layer.cornerRadius = 60/8
            preparedCell.remainingTimeBar.layer.cornerRadius = 60/8
            preparedCell.remainingTimeBarOutline.layer.masksToBounds = true
            preparedCell.remainingTimeBar.layer.masksToBounds = true
            preparedCell.remainingTimeBarOutline.layer.borderWidth = 1.0
            preparedCell.remainingTimeBarOutline.layer.borderColor = UIColor.greenColor().CGColor
            
            preparedCell.remainingTimeLabel.text = Time(newTime: thisCategory.totalTimeRemaining).toString()
            
            preparedCell.category = thisCategory
            
            Style.category(preparedCell)
            
            return preparedCell
        } else {
            return CategoryCell()
        }
        
    }

    func prepareCategoryView(tableView tableView: UITableView, categoryList: List<Category>, section: Int, editorViewController: BudgetEditorViewController?=nil) -> CategoryView {
        
        let thisCategory = categoryList[section]
        var editor = false
        
        if let preparedView = tableView.dequeueReusableHeaderFooterViewWithIdentifier("CategoryView") as? CategoryView {
            if let unwrappedVC = editorViewController {
                preparedView.VC = unwrappedVC
                preparedView.editButton.enabled = true
                preparedView.editButton.hidden = false
                editor = true
            } else {
                preparedView.editButton.enabled = false
                preparedView.editButton.hidden = true
            }
            
            if editor {
                preparedView.remainingTimeLabel.text = Time(newTime: thisCategory.totalTimeBudgeted).toString()
            } else {
                preparedView.remainingTimeLabel.text = Time(newTime: thisCategory.totalTimeRemaining).toString()
            }
            
            preparedView.sectionNameLabel.text = thisCategory.name
            
            preparedView.category = thisCategory
            preparedView.editor = editor
            
            Style.category(preparedView)
            
            return preparedView
        } else {
            return CategoryView()
        }
        
    }
    
    func prepareTaskCell(tableView tableView: UITableView, categoryList: List<Category>, indexPath: NSIndexPath, editor: Bool) -> UITableViewCell {
        
        let thisTask = categoryList[indexPath.section].tasks[indexPath.row]
        
        if thisTask.memo == "" {
            if let preparedCell = tableView.dequeueReusableCellWithIdentifier("DetailCell") as? DetailCell {
                preparedCell.title.text = thisTask.name
                preparedCell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
                
                if editor {
                    preparedCell.detail.text = Time(newTime: thisTask.timeBudgeted).toString()
                } else {
                    preparedCell.detail.text = Time(newTime: thisTask.timeRemaining).toString()
                }
                
                preparedCell.task = thisTask
                preparedCell.editor = editor
                
                Style.task(preparedCell)
                
                return preparedCell
            } else {
                return DetailCell()
            }
        } else {
            if let preparedCell = tableView.dequeueReusableCellWithIdentifier("SubtitleDetailCell") as? SubtitleDetailCell {
                preparedCell.title.text = thisTask.name
                preparedCell.subtitle.text = thisTask.memo
                preparedCell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
                
                if editor {
                    preparedCell.detail.text = Time(newTime: thisTask.timeBudgeted).toString()
                } else {
                    preparedCell.detail.text = Time(newTime: thisTask.timeRemaining).toString()
                }
                
                preparedCell.task = thisTask
                preparedCell.editor = editor
                
                Style.task(preparedCell)
                
                return preparedCell
            } else {
                return SubtitleDetailCell()
            }
        }
    }
    
    func prepareAddRecordTaskCell(tableView tableView: UITableView, currentTask: Task?) -> DetailCell {
        
        if let preparedCell = tableView.dequeueReusableCellWithIdentifier("DetailCell") as? DetailCell {
            preparedCell.title.text = "Task"
            
            if let unwrappedTaskName = currentTask?.name {
                preparedCell.detail.text = unwrappedTaskName
            } else {
                preparedCell.detail.text = "Choose a Task"
            }
            
            preparedCell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
            
            Style.detailCell(preparedCell)
            
            return preparedCell
        } else {
            return DetailCell()
        }
        
    }
    
    func prepareAddRecordTimeCell(tableView tableView: UITableView, timeSpent: Time?) -> DetailCell {
        
        if let preparedCell = tableView.dequeueReusableCellWithIdentifier("DetailCell") as? DetailCell {
            preparedCell.title.text = "Time Spent"
            
            if let unwrappedTimeSpent = timeSpent?.toDouble() {
                preparedCell.detail.text = Time(newTime: unwrappedTimeSpent).toString()
            } else {
                preparedCell.detail.text = "00:00"
            }
            
            preparedCell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
            Style.detailCell(preparedCell)
            
            return preparedCell
        } else {
            return DetailCell()
        }
        
    }
    
    func prepareAddRecordDateCell(tableView tableView: UITableView, date: NSDate?) -> DetailCell {
        
        if let preparedCell = tableView.dequeueReusableCellWithIdentifier("DetailCell") as? DetailCell {
            preparedCell.title.text = "Date"
            
            if let unwrappedDate = date {
                let dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "MMMM dd, yyyy"
                
                preparedCell.detail.text = dateFormatter.stringFromDate(unwrappedDate)
            } else {
                preparedCell.detail.text = "Current Date"
            }
            
            preparedCell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
            Style.detailCell(preparedCell)
            
            return preparedCell
        } else {
            return DetailCell()
        }
        
    }
    
    func prepareNameTextfieldCell(tableView tableView: UITableView, name: String?) -> NameTextfieldCell {
        
        if let preparedCell = tableView.dequeueReusableCellWithIdentifier("NameTextfieldCell") as? NameTextfieldCell {
            if let unwrappedName = name {
                preparedCell.textField.text = unwrappedName
            } else {
                preparedCell.textField.placeholder = "Name (Required)"
            }
            
            preparedCell.selectionStyle = .None
            
            Style.textfieldCell(preparedCell)
            
            return preparedCell
        } else {
            return NameTextfieldCell()
        }
        
    }
    
    func prepareMemoTextfieldCell(tableView tableView: UITableView, memo: String?) -> MemoTextfieldCell {
        
        if let preparedCell = tableView.dequeueReusableCellWithIdentifier("MemoTextfieldCell") as? MemoTextfieldCell {
            if let unwrappedMemo = memo {
                preparedCell.textField.text = unwrappedMemo
            } else {
                preparedCell.textField.placeholder = "Description (Optional)"
            }
            
            preparedCell.selectionStyle = .None
            
            Style.textfieldCell(preparedCell)
            
            return preparedCell
        } else {
            return MemoTextfieldCell()
        }
        
    }
    
    func prepareAddTaskCategoryCell(tableView tableView: UITableView, categoryName: String?) -> DetailCell {
        
        if let preparedCell = tableView.dequeueReusableCellWithIdentifier("DetailCell") as? DetailCell {
            preparedCell.title.text = "Category"
            
            if let unwrappedCategoryName = categoryName {
                preparedCell.detail.text = unwrappedCategoryName
            } else {
                preparedCell.detail.text = "Choose Category"
            }
            
            preparedCell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
            Style.detailCell(preparedCell)
            
            return preparedCell
        } else {
            return DetailCell()
        }
        
    }
    
    func prepareAddTaskTimeCell(tableView tableView: UITableView, time: Double?) -> DetailCell {
        
        if let preparedCell = tableView.dequeueReusableCellWithIdentifier("DetailCell") as? DetailCell {
            preparedCell.title.text = "Time Budgeted"
            
            if let unwrappedTime = time {
                preparedCell.detail.text = Time(newTime: unwrappedTime).toString()
            } else {
                preparedCell.detail.text = "00:00"
            }
            
            preparedCell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
            Style.detailCell(preparedCell)
            
            return preparedCell
        } else {
            return DetailCell()
        }
        
    }
    
    func prepareRecordCell(tableView tableView: UITableView, recordList: List<Record>, indexPath: NSIndexPath) -> UITableViewCell {
        
        let thisRecord = recordList[indexPath.row]
        
        if thisRecord.note == "" {
            if let preparedCell = tableView.dequeueReusableCellWithIdentifier("DetailCell") as? DetailCell {
                preparedCell.title.text = thisRecord.dateToString()
                preparedCell.detail.text = Time(newTime: thisRecord.timeSpent).toString()
                preparedCell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
                
                Style.record(preparedCell)
                
                return preparedCell
            } else {
                return DetailCell()
            }
            
        } else {
            if let preparedCell = tableView.dequeueReusableCellWithIdentifier("SubtitleDetailCell") as? SubtitleDetailCell {
                preparedCell.title.text = thisRecord.note
                preparedCell.subtitle.text = thisRecord.dateToString()
                preparedCell.detail.text = Time(newTime: thisRecord.timeSpent).toString()
                preparedCell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
                
                Style.record(preparedCell)
                
                return preparedCell
            } else {
                return SubtitleDetailCell()
            }
            
        }
    }
    
    func prepareBasicCell(tableView tableView: UITableView, titleText: String) -> UITableViewCell {
        let preparedCell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "BasicCell")
        
        preparedCell.textLabel?.text = titleText
        preparedCell.textLabel?.textColor = UIColor.whiteColor()
        preparedCell.backgroundColor = UIColor.clearColor()
        preparedCell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        
        return preparedCell
    }
    
    func prepareBasicHeader(tableView tableView: UITableView, titleText: String) -> UIView {
        
        if let preparedView = tableView.dequeueReusableHeaderFooterViewWithIdentifier("CategoryView") as? CategoryView {
            preparedView.sectionNameLabel.text = titleText
            preparedView.remainingTimeLabel.hidden = true
            preparedView.editButton.enabled = false
            Style.basicHeader(preparedView)
            
            return preparedView
        } else {
            return CategoryView()
        }
        
    }
}
