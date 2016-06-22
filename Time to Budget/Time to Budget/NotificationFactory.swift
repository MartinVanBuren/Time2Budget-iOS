import UIKit

class NotificationFactory {
    
    func archiveBudgetNotification() -> UILocalNotification {
        let realm = Database.getRealm()
        let thisBudget = realm.objects(Budget).filter("isCurrent = TRUE").first!
        let localNotif = UILocalNotification()
        
        localNotif.alertTitle = "Budget Archived"
        localNotif.alertBody = "Your fresh budget is ready!"
        localNotif.fireDate = thisBudget.endDate
        
        return localNotif
    }
    
}