//
//  Model.swift
//  Expense Manager
//
//  Created by aashna.narula on 03/11/21.
//

import Foundation

@objc public enum TransactionType: Int32 {
    case expense
    case income
    case balance
    static let allValues = [expense, income, balance]
    
    var placeHolder: String {
        switch self {
        case .expense:
            return Constants.expenseTitle
        case .income:
            return Constants.incomeTitle
        case .balance:
            return Constants.balanceTitle
        }
    }
}

struct TxnDetail {
    var description: String
    var date: Date
    var dateInString: String {
        get {
            return date.localizedDescription
        }
    }
    var amount: Int = 0
    var amountInString: String {
        get {
            return String(amount)
        }
    }
    var txnType: TransactionType
    var uid: String
}

struct Category {
    var txnType: TransactionType
    var list: Array<TxnDetail>
    var total: Int = 0
    var totalInString: String {
        get {
            return "\(Constants.currencyType) \(total)"
        }
    }
}

class Manager {
    static let sharedInstance = Manager()
    var expenseCategory: Category = Category(txnType: TransactionType.expense, list: [])
    var incomeCategory: Category = Category(txnType: TransactionType.income, list: [])
    var balanceCategory: Category = Category(txnType: TransactionType.balance, list: [])
    
    func updateCategory(type: TransactionType, byAmount: Int, desc: String, date: Date, uid: String) {
        if (type == TransactionType.expense) {
            self.expenseCategory.list.append(TxnDetail(description: desc, date: date, amount: byAmount, txnType: TransactionType.expense, uid: uid))
            self.expenseCategory.total += byAmount
            self.balanceCategory.total -= byAmount
        } else if (type == TransactionType.income) {
            self.incomeCategory.list.append(TxnDetail(description: desc, date: date, amount: byAmount, txnType: TransactionType.income, uid: uid))
            self.incomeCategory.total += byAmount
            self.balanceCategory.total += byAmount
        }
    }
    
    func fetchvaluesFromDB(completionHanlder: (Bool) -> Void) {
        do {
            guard let result = try PersistentStorage.shared.context.fetch(TxnDetailCD.fetchRequest()) as? [TxnDetailCD] else { return }
            result.forEach(
                {
                    if($0.txnType == TransactionType.expense.rawValue) {
                        Manager.sharedInstance.updateCategory(type: TransactionType.expense, byAmount: Int($0.amount), desc: $0.desc ?? Constants.defaultDescForNewEntry, date: $0.date ?? Date(), uid: $0.uid ?? "0")
                    } else if($0.txnType == TransactionType.income.rawValue) {
                        Manager.sharedInstance.updateCategory(type: TransactionType.income, byAmount: Int($0.amount), desc: $0.desc ?? Constants.defaultDescForNewEntry, date: $0.date ?? Date(), uid: $0.uid ?? "0")
                    }
                }
            )
            completionHanlder(true)
        }
        catch let error {
            print(error)
        }
    }
    
    func deleteEntryFromDB(objToDelete: TxnDetail) {
        do {
            guard let result = try PersistentStorage.shared.context.fetch(TxnDetailCD.fetchRequest()) as? [TxnDetailCD] else { return }
            result.forEach({
                if($0.txnType == objToDelete.txnType.rawValue && $0.amount == objToDelete.amount && $0.desc == objToDelete.description && $0.date == objToDelete.date) {
                    PersistentStorage.shared.context.delete($0)
                }
            })
        } catch let error {
            print(error)
        }
        PersistentStorage.shared.saveContext()
    }
    
    func setValuesInDB(withUUID: String, transactionType: TransactionType, date: Date, amount: String, desc: String) {
        let txnDetails = TxnDetailCD(context: PersistentStorage.shared.context)
        txnDetails.amount = Int64(amount) ?? 0
        txnDetails.desc = desc
        txnDetails.txnType = transactionType.rawValue
        txnDetails.date = date
        txnDetails.uid = withUUID
        PersistentStorage.shared.saveContext()
    }
    
    func deleteTask(uuid: String) {
        do {
            guard let result = try PersistentStorage.shared.context.fetch(TxnDetailCD.fetchRequest()) as? [TxnDetailCD] else { return }
            for expense in result {
                if expense.uid == uuid {
                    PersistentStorage.shared.context.delete(expense)
                }
            }
        } catch let error {
            print(error)
        }
        PersistentStorage.shared.saveContext()
    }
    
    func editTask(withUUID: String, category: String, date: Date, amount: Int64, transactionType: TransactionType, desc: String) {
        do {
            guard let result = try PersistentStorage.shared.context.fetch(TxnDetailCD.fetchRequest()) as? [TxnDetailCD] else { return }
            for expense in result {
                if expense.uid == withUUID {
                    expense.date = date
                    expense.amount = amount
                    expense.txnType = transactionType.rawValue
                    expense.desc = desc
                }
            }
        } catch let error {
            print(error)
        }
        PersistentStorage.shared.saveContext()
    }
}

extension TimeZone {
    static let gmt = TimeZone(secondsFromGMT: 0)!
}
extension Formatter {
    static let date = DateFormatter()
}

extension Date {
    func localizedDescription(dateStyle: DateFormatter.Style = .medium,
                              locale   : Locale = .current) -> String {
        Formatter.date.locale = locale
        Formatter.date.dateStyle = dateStyle
        return Formatter.date.string(from: self)
    }
    var localizedDescription: String { localizedDescription() }
}
