//
//  ViewModel.swift
//  Expense Manager
//
//  Created by aashna.narula on 03/11/21.
//

import Foundation

struct Objects {
    var sectionName : Date!
    var sectionObjects : [TxnDetail]!
}

class ViewModel {
    
    var dic = [Date:[TxnDetail]]()
    var uniqueSections: Set<Date> = Set<Date>()
    var objectArray = [Objects]()
    
    func assembleData() {
        objectArray = [Objects]()
        var allSections = Manager.sharedInstance.expenseCategory.list
        allSections += Manager.sharedInstance.incomeCategory.list
        for i in allSections {
            uniqueSections.insert(i.date)
        }
        uniqueSections.forEach {
            let dateKey = $0
            let filterArray = allSections.filter { $0.date == dateKey }
            dic[dateKey] = filterArray
        }
        
        for (key, value) in dic {
            objectArray.append(Objects(sectionName: key, sectionObjects: value))
        }
        
        objectArray.sort(by: {
            (p1: Objects, p2: Objects) -> Bool in
            return p1.sectionName < p2.sectionName
        })
    }
}
