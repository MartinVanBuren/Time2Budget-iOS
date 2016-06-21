import UIKit

class CategoryView: UITableViewHeaderFooterView {

    @IBOutlet weak var customContentView: UIView!
    @IBOutlet weak var remainingTimeBar: UIView!
    @IBOutlet weak var remainingTimeBarOutline: UIView!
    @IBOutlet weak var remainingTimeLabel: UILabel!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var sectionNameLabel: UILabel!
    internal var VC: BudgetEditorViewController?
    var category: Category?
    var editor: Bool?

    @IBAction func editCategoryButtonPressed(sender: UIButton) {
        Factory.displayEditCategoryAlert(viewController: self.VC!, categoryName: self.sectionNameLabel.text!)
    }
    
}
