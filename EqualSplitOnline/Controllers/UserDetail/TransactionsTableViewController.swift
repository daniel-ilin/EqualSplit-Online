//
//  TransactionsTableViewController.swift
//  EqualSplitOnline
//
//  Created by Daniel Ilin on 06.01.2022.
//
import Foundation
import UIKit

class TransactionsTableViewController: UITableViewController {
    
    // MARK: - Properties
    
    private var activeUserCanMakeChanges = false
    
    var activeUser: User!
    
    var viewModel: Person
    
    private let cellReuseIdentifier = "TransactionCellReuseIdentifier"
    
    weak var delegate: TransactionsTableViewControllerDelegate?
    
    
    // MARK: - Lifecycle
    
    init(user: User, viewModel: Person) {
        activeUser = user
        if AuthService.activeUser?.id == activeUser.userid {
            activeUserCanMakeChanges = true
        }
        self.viewModel = viewModel
        super.init(style: .plain)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    // MARK: - Helpers
    
    func setupUI() {
        
        tableView.register(TransactionViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        
        tableView.backgroundColor = .systemBackground
//        tableView.rowHeight = 60
        
        self.clearsSelectionOnViewWillAppear = false
        view.backgroundColor = .systemBackground        
        didMove(toParent: self)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        
        tableView.register(UserTableViewCell.self, forCellReuseIdentifier: "Cell")
    }
}

//  MARK: - UITableViewDataSource

extension TransactionsTableViewController {
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = TransactionHeaderView(frame: CGRect(x: 20, y: 0, width: tableView.bounds.size.width-20, height: 80))
        header.headerLabel.text = header.getSectionHeaderTitle(atSection: section, forPerson: viewModel)
        return header
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        let person = viewModel
        if person.owes.count > 0 && person.spent.count == 0 {
            return 1
        } else if person.needs.count > 0 && person.spent.count == 0 {
            return 1
        } else if person.owes.count > 0 && person.spent.count > 0 {
            return 2
        } else if person.spent.count > 0 && person.needs.count > 0 {
            return 2
        } else {
            return 1
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rowSetup(forSection: section)
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath) as? TransactionViewCell
        return cell!.cellSetup(at: indexPath, withViewModel: viewModel)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        UIView.animate(withDuration: 0.3) {
            self.tableView.performBatchUpdates(nil)
        }
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {        
        if let cell = self.tableView.cellForRow(at: indexPath) as? TransactionViewCell {
            cell.hideDetailView()
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
    }
    
    //    MARK: - RowSetup
    
    private func rowSetup(forSection section: Int)->Int {
        let person = viewModel
        var tableSectionsData = [[CalculatorTransaction]]()
        if person.owes.count > 0 {
            tableSectionsData = [person.spent, person.owes]
        } else {
            tableSectionsData = [person.spent, person.needs]
        }
        
        if tableSectionsData[0].count > 0 && tableSectionsData[1].count == 0{
            return tableSectionsData[0].count
        } else if tableSectionsData[0].count == 0 && tableSectionsData[1].count > 0 {
            return tableSectionsData[1].count
        } else if tableSectionsData[0].count > 0 && tableSectionsData[1].count > 0 {
            return tableSectionsData[section].count
        } else if tableSectionsData[0].count == 0 && tableSectionsData[1].count == 0 {
            return 0
        } else {
            return 0
        }
    }            
    
}

// MARK: - UsersTableViewControllerDelegate

protocol TransactionsTableViewControllerDelegate: AnyObject {
    func delegateAction()
}
