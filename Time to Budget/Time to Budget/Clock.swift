import Foundation
import RealmSwift

public class Clock: Object {

    public dynamic var clockedIn: Bool = false
    public dynamic var startTime: NSTimeInterval = NSDate.timeIntervalSinceReferenceDate()
    public dynamic var finalTime: Double = 0.0

    internal func clockInOut() {
        if clockedIn {
            clockedIn = false
            let currentTime = NSDate.timeIntervalSinceReferenceDate()
            var elapsedTime = currentTime - startTime

            let hours = Int((elapsedTime / 60.0) / 60.0)
            elapsedTime -= ((NSTimeInterval(hours) * 60) * 60)

            let rawMinutes = Int(round((elapsedTime / 60.0) / 15) * 15)
            elapsedTime -= (NSTimeInterval(rawMinutes) * 60)

            let seconds = Int(elapsedTime)
            elapsedTime -= (NSTimeInterval(seconds))
            
            var minutes = 0.0
            
            switch(rawMinutes){
            case 15:
                minutes = 0.25
            case 30:
                minutes = 0.5
            case 45:
                minutes = 0.75
            default:
                minutes = 0.0
            }
            
            finalTime = (Double(hours) + minutes)
        } else {
            clockedIn = true
            startTime = NSDate.timeIntervalSinceReferenceDate()
        }
    }
    
}
