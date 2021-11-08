//
//  TransactionDetailCell.swift
//  Expense Manager
//
//  Created by aashna.narula on 03/11/21.
//

import UIKit

class TransactionDetailCell: UITableViewCell {

    @IBOutlet weak var amount: UILabel!
    @IBOutlet weak var desc: UILabel!
    func setupCell(detail: TxnDetail) {
        if (detail.txnType == TransactionType.expense) {
            self.amount.textColor = UIColor.systemRed
            self.amount.text = Constants.expensePrefix + (detail.amountInString)
        } else {
            self.amount.textColor = UIColor.systemGreen
            self.amount.text = Constants.incomePrefix + (detail.amountInString)
        }
        self.desc.text = detail.description
    }
}
