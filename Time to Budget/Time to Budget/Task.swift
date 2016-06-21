import Foundation
import RealmSwift

public class Task: Object {

    public dynamic var parent: Category!
    public dynamic var clock: Clock? = Clock()
    public dynamic var name = ""
    public dynamic var memo = ""
    public dynamic var timeBudgeted = 0.0
    public dynamic var totalTimeSpent = 0.0
    public dynamic var timeRemaining = 0.0
    public let records = List<Record>()

    public func calcTime() {
        self.totalTimeSpent = 0.0
        self.timeRemaining = 0.0
        
        for record in records {
            totalTimeSpent += record.timeSpent
        }
        
        self.timeRemaining = (self.timeBudgeted - self.totalTimeSpent)
        
        self.parent.calcTime()
    }
    
}
