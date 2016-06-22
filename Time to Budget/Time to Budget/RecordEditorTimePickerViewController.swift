import UIKit

class RecordEditorTimePickerViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    // ========== View Properties ==========
    var recordEditorVC: RecordEditorViewController!
    @IBOutlet weak var timePicker: UIPickerView!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var colonLabel: UILabel!
    
    // ========== Time Picker Properties ==========
    var timeHourPickerData: [Int] = PickerFactory().prepareTimeHourPickerData()
    var timeMinutePickerData: [Int] = PickerFactory().prepareTimeMinutePickerData()
    var timePicked: Time = Time()

    // ==================== View Controller Methods ====================
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Style.viewController(self)
        Style.button(doneButton)
        Style.label(colonLabel)

        // Time Picker Setup
        timePicker.dataSource = self
        timePicker.delegate = self
        
        timePicked = Time(newTime: recordEditorVC.timeSpent)
        
        timePicker.selectRow(getHourIndex(), inComponent: 0, animated: true)
        timePicker.selectRow(getMinIndex(), inComponent: 1, animated: true)
    }
    
    override func viewDidLayoutSubviews() {
        labelForHours()
        labelForMinutes()
    }

    // ==================== UIPickerViewDataSource Methods ====================
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return timeHourPickerData.count
        } else {
            return timeMinutePickerData.count
        }
    }
    
    // ==================== UIPickerDelegate Methods ====================
    func pickerView(pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        if component == 0 {
            return Style.picker(timeHourPickerData[row])
        }
        else {
            return Style.picker(timeMinutePickerData[row])
        }
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0 {
            timePicked.hours = timeHourPickerData[row]
        } else {
            timePicked.minutes = timeMinutePickerData[row]
        }
    }
    
    // ==================== IBAction Methods ====================
    @IBAction func saveButtonPressed(sender: UIButton) {
        recordEditorVC.timeSpent = timePicked.toDouble()
        
        navigationController?.popViewControllerAnimated(true)
    }
    
    // ==================== Helper Methods ====================
    func getHourIndex() -> Int {
        return timePicked.hours
    }

    func getMinIndex() -> Int {
        if timePicked.minutes == 15 {
            return 1
        }
        else if timePicked.minutes == 30 {
            return 2
        }
        else if timePicked.minutes == 45 {
            return 3
        }
        else {
            return 0
        }
    }
    
    func labelForHours() {
        let lblText = "Hours"
        let lblWidth = timePicker.frame.size.width / CGFloat(timePicker.numberOfComponents)
        let lblXPos = timePicker.frame.origin.x
        let lblYPos = timePicker.frame.origin.y
        
        let hrsLabel = UILabel()
        hrsLabel.frame = CGRect(x: lblXPos, y: lblYPos, width: lblWidth, height: 20)
        hrsLabel.text = lblText
        hrsLabel.textAlignment = NSTextAlignment.Center
        
        Style.label(hrsLabel)
        
        view.addSubview(hrsLabel)
    }
    
    func labelForMinutes() {
        let lblText = "Minutes"
        let lblWidth = timePicker.frame.size.width / CGFloat(timePicker.numberOfComponents)
        let lblXPos = timePicker.frame.origin.x + lblWidth
        let lblYPos = timePicker.frame.origin.y
        
        let minsLabel = UILabel(frame: CGRect(x: lblXPos, y: lblYPos, width: lblWidth, height: 20))
        minsLabel.text = lblText
        minsLabel.textAlignment = NSTextAlignment.Center
        
        Style.label(minsLabel)
        
        view.addSubview(minsLabel)
    }
    
}
