//
//  NewTransactionViewModel.swift
//  Expense Manager
//
//  Created by aashna.narula on 03/11/21.
//

import Foundation

protocol SaveAndDismiss {
    func dismissVC()
}

struct NewTransactionViewModel {
    var transactionType: TransactionType = TransactionType.expense
    var amount: String = "0"
    var uid: String = "0"
    var desc: String = Constants.defaultDescForNewEntry
    var date: Date = Calendar.current.startOfDay(for: Date())
    var dateWithDefaultTimestamp: Date {
        get {
            return Calendar.current.startOfDay(for: date)
        }
    }
    var dateInString: String {
        get {
            return date.localizedDescription
        }
    }
}
