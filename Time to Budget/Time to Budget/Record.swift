import Foundation
import RealmSwift

public class Record: Object {
    
    public dynamic var date = NSDate(timeIntervalSince1970: 1)
    public dynamic var note = ""
    public dynamic var timeSpent = 0.0
    public dynamic var parent: Task!
    
    public func dateToString() -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MMMM dd, yyyy"
        
        return dateFormatter.stringFromDate(date)
    }
    
}
