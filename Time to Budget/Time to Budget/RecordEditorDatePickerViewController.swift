import UIKit

class RecordEditorDatePickerViewController: UIViewController {

    var recordEditorVC: RecordEditorViewController!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var datePicker: UIDatePicker!
    var datePicked: NSDate!

    override func viewDidLoad() {
        super.viewDidLoad()

        Style.viewController(self)
        Style.button(self.doneButton)
        Style.picker(self.datePicker)
        
        self.datePicker.setDate(self.recordEditorVC.date, animated: true)
    }

    @IBAction func saveButtonPressed(sender: UIButton) {
        recordEditorVC.date = self.datePicked
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func datePickerChanged(sender: UIDatePicker) {
        datePicked = sender.date
    }
    
}
