//
//  TxnDetailCD+CoreDataProperties.swift
//  Expense Manager
//
//  Created by aashna.narula on 08/11/21.
//
//

import Foundation
import CoreData


extension TxnDetailCD {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TxnDetailCD> {
        return NSFetchRequest<TxnDetailCD>(entityName: "TxnDetailCD")
    }

    @NSManaged public var amount: Int64
    @NSManaged public var date: Date?
    @NSManaged public var desc: String?
    @NSManaged public var txnType: Int32
    @NSManaged public var uid: String?

}

extension TxnDetailCD : Identifiable {

}
