//
//  NewTransactionView.swift
//  Expense Manager
//
//  Created by aashna.narula on 03/11/21.
//

import Foundation
import UIKit

class NewTransactionView: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var increaseButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var decreaseButton: UIButton!
    @IBOutlet weak var amountLabel: UIView!
    @IBOutlet weak var transactionDec: UITextField!
    @IBOutlet weak var dropDown: UIPickerView!
    @IBOutlet weak var amount: UITextField!
    var list = [TransactionType]()
    var newTransactionViewModel: NewTransactionViewModel!
    var delegate: ViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.newTransactionViewModel = NewTransactionViewModel()
        self.amount.delegate = self
        self.transactionDec.delegate = self
        self.setupUI()
    }
    
    func setupUI() {
        datePicker.datePickerMode = UIDatePicker.Mode.date
        datePicker.addTarget(self, action: #selector(NewTransactionView.datePickerValueChanged), for: UIControl.Event.valueChanged)
        self.list.append(TransactionType.expense)
        self.list.append(TransactionType.income)
        amount.text = "0"
        amountLabel.layer.borderWidth = 1
        amountLabel.layer.borderColor = UIColor.black.cgColor
        increaseButton.layer.borderWidth = 1
        increaseButton.layer.borderColor = UIColor.black.cgColor
        decreaseButton.layer.borderWidth = 1
        decreaseButton.layer.borderColor = UIColor.black.cgColor
        addButton.layer.borderWidth = 1
        addButton.layer.borderColor = UIColor.black.cgColor
    }
    
    @objc func datePickerValueChanged(sender:UIDatePicker) {
        self.newTransactionViewModel.date = sender.date
        presentedViewController?.dismiss(animated: true, completion: nil)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if (textField == amount) {
            self.newTransactionViewModel.amount = textField.text ?? "0"
        } else if (textField == transactionDec) {
            self.newTransactionViewModel.desc = ((textField.text == "" ? Constants.defaultDescForNewEntry : textField.text) ?? Constants.defaultDescForNewEntry)
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if (textField == amount) {
            textField.text = ""
        }
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if (textField == amount) {
            if let text = textField.text as NSString? {
                let txtAfterUpdate = text.replacingCharacters(in: range, with: string)
                self.newTransactionViewModel.amount = txtAfterUpdate
            }
        }
        if (textField == transactionDec) {
            if let text = textField.text as NSString? {
                let txtAfterUpdate = text.replacingCharacters(in: range, with: string)
                self.newTransactionViewModel.desc = txtAfterUpdate
            }
        }
        return true
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return list.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return list[row].placeHolder
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.newTransactionViewModel.transactionType = TransactionType(rawValue: self.list[row].rawValue) ?? TransactionType.expense
    }
    
    @IBAction func increaseTransactionPressed(_ sender: Any) {
        if let amt = Int(self.amount.text ?? "0") {
            let updatedAmt = amt + 1
            self.amount.text = String(updatedAmt)
            self.newTransactionViewModel.amount = String(updatedAmt)
        }
    }
    
    @IBAction func decreaseTransactionPressed(_ sender: Any) {
        if (self.amount.text == "0") {
            return
        }
        if let amt = Int(self.amount.text ?? "0") {
            let updatedAmt = amt - 1
            self.amount.text = String(updatedAmt)
            self.newTransactionViewModel.amount = String(updatedAmt)
        }
    }
    
    @IBAction func addNewRowClicked(_ sender: Any) {
        if (self.newTransactionViewModel.amount != "0" && self.newTransactionViewModel.amount != "") {
            self.newTransactionViewModel.uid = UUID().uuidString
            if (self.newTransactionViewModel.transactionType == TransactionType.expense) {
                Manager.sharedInstance.updateCategory(type: TransactionType.expense, byAmount: Int(self.newTransactionViewModel.amount) ?? 0, desc: self.newTransactionViewModel.desc, date: self.newTransactionViewModel.dateWithDefaultTimestamp, uid: self.newTransactionViewModel.uid)
            } else if (self.newTransactionViewModel.transactionType == TransactionType.income) {
                Manager.sharedInstance.updateCategory(type: TransactionType.income, byAmount: Int(self.newTransactionViewModel.amount) ?? 0, desc: self.newTransactionViewModel.desc, date: self.newTransactionViewModel.dateWithDefaultTimestamp, uid: self.newTransactionViewModel.uid)
            }
            Manager.sharedInstance.setValuesInDB(withUUID: self.newTransactionViewModel.uid, transactionType: self.newTransactionViewModel.transactionType, date: self.newTransactionViewModel.dateWithDefaultTimestamp, amount: self.newTransactionViewModel.amount, desc: self.newTransactionViewModel.desc)
        }
        
        self.delegate.dismissVC()
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

