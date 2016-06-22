import UIKit

class RecordEditorDatePickerViewController: UIViewController {

    var recordEditorVC: RecordEditorViewController!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var datePicker: UIDatePicker!
    var datePicked: NSDate!

    override func viewDidLoad() {
        super.viewDidLoad()

        Style.viewController(self)
        Style.button(doneButton)
        Style.picker(datePicker)
        
        datePicker.setDate(recordEditorVC.date, animated: true)
    }

    @IBAction func saveButtonPressed(sender: UIButton) {
        recordEditorVC.date = datePicked
        navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func datePickerChanged(sender: UIDatePicker) {
        datePicked = sender.date
    }
    
}
