import UIKit

class CategoryCell: UITableViewCell {

    @IBOutlet weak var sectionNameLabel: UILabel!
    @IBOutlet weak var remainingTimeLabel: UILabel!
    @IBOutlet weak var customContentView: UIView!
    @IBOutlet weak var remainingTimeBar: UIView!
    @IBOutlet weak var remainingTimeBarOutline: UIView!
    var category: Category?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
