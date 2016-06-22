import RealmSwift

class PickerFactory {
    
    func prepareTimeHourPickerData() -> [Int] {
        var finalValue: [Int] = []
        
        for i in 0...99 {
            finalValue.append(i)
        }
        
        return finalValue
    }
    
    func prepareTimeMinutePickerData() -> [Int] {
        var finalValue: [Int] = []
        
        for i in 0...3 {
            finalValue.append(i * 15)
        }
        
        return finalValue
    }
    
    func prepareCategoryPickerData(categoryList: Results<Category>) -> [String] {
        var finalData: [String] = []
        
        for category in categoryList {
            finalData.append(category.name)
        }
        
        return finalData
    }
    
}