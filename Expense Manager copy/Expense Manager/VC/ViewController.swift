//
//  ViewController.swift
//  Expense Manager
//
//  Created by aashna.narula on 03/11/21.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var expenses: UILabel!
    @IBOutlet weak var balance: UILabel!
    @IBOutlet weak var income: UILabel!
    var viewModel: ViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel = ViewModel()
        Manager.sharedInstance.fetchvaluesFromDB() { status in
            if(status) {
                self.setupUI()
                self.setProgress()
            }
        }
    }
    
    func setupUI() {
        self.expenses.text = String(Manager.sharedInstance.expenseCategory.totalInString)
        self.income.text = String(Manager.sharedInstance.incomeCategory.totalInString)
        self.balance.text = String(Manager.sharedInstance.balanceCategory.totalInString)
        self.progressBar.trackTintColor = UIColor.systemGreen
        self.progressBar.progressTintColor = UIColor.systemRed
    }
    
    func setProgress() {
        if (Manager.sharedInstance.incomeCategory.total == 0 && Manager.sharedInstance.expenseCategory.total == 0) {
            self.progressBar.trackTintColor = UIColor.gray
            progressBar.progress = 0.0
            return
        }
        var processValue = Float(Manager.sharedInstance.expenseCategory.total)/Float(Manager.sharedInstance.incomeCategory.total)
        if(processValue < 0) {
            processValue *= -1
        }
        progressBar.progress = Float(processValue)
    }
    
    @IBAction func addNewRow(_ sender: Any) {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        if let viewController = mainStoryboard.instantiateViewController(withIdentifier: "NewTransactionView") as? NewTransactionView {
            viewController.delegate = self
            self.present(viewController, animated: true, completion: nil)
        }
    }
    
    func reloadTable() {
        DispatchQueue.main.async {
            self.setupUI()
            self.setProgress()
            self.tableView.reloadData()
        }
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        self.viewModel.assembleData()
        return self.viewModel.objectArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.objectArray[section].sectionObjects.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionDetailCell") as? TransactionDetailCell else {
            return UITableViewCell()
        }
        cell.setupCell(detail: self.viewModel.objectArray[indexPath.section].sectionObjects[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.viewModel.objectArray[section].sectionName.localizedDescription
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
}

extension ViewController: SaveAndDismiss {
    func dismissVC() {
        navigationController?.popViewController(animated: true)
        self.reloadTable()
    }
}

