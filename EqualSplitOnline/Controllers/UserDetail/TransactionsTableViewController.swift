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
    
    var activeUserCanMakeChanges = false
    
    var activeUser: User!
    
    var viewModel: Person
    
    private let currentSession: SessionViewModel
    
    private let cellReuseIdentifier = "TransactionCellReuseIdentifier"
    
    weak var delegate: TransactionsTableViewControllerDelegate?
    
    weak var viewmodelDelegate: TransactionTableViewViewModelDelegate?
    
    // MARK: - Lifecycle
    
    init(user: User, viewModel: Person, session: SessionViewModel) {
        if AuthService.activeUser?.id == viewModel.id || AuthService.activeUser?.id == session.ownerId {
            activeUserCanMakeChanges = true
        }
        self.currentSession = session
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
    
    func deleteRowHandler(forTransaction transaction: CalculatorTransaction) {
        guard let id = transaction.id else { return }
        
        
        let titleString = "Remove \(IntToCurrency.makeDollars(fromNumber: transaction.amount) ?? "error")?"
        let messageString = "from \(viewModel.name)"
        let ac = UIAlertController(title: titleString, message: messageString, preferredStyle: .alert)
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        let confirm = UIAlertAction(title: "Delete", style: .destructive) {[weak self] _ in
            self!.showLoader(true)
            TransactionService.deleteTransaction(withId: id, inSessionWithId: self!.currentSession.sessionId) { response in
                guard response.error == nil else { return }
                UserService.fetchUserData { response in
                    guard response.error == nil else { return }
                    guard response.value != nil else { return }
                    SessionViewController.sessions = response.value!.sessions
                    self!.showLoader(false)
                    self!.viewmodelDelegate?.configureViewmodel()
                }
            }
        }
        
        ac.addAction(cancel)
        ac.addAction(confirm)
        present(ac, animated: true, completion: nil)
    }
    
    func isCurrentUserSessionOwner() -> Bool {
        if AuthService.activeUser?.id == currentSession.ownerId { return true }
        else { return false }
    }
}

//  MARK: - UITableViewDataSource

extension TransactionsTableViewController {
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return SetupCellSwipeEditStyle(forPerson: viewModel, forSession: currentSession, atIndexPath: indexPath)
    }
    
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
        cell?.expandedView.delegate = self
        return cell!.cellSetup(at: indexPath, withViewModel: viewModel, forSession: currentSession)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.selectedRow()
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
        if editingStyle == .delete {
            deleteRowHandler(forTransaction: viewModel.spent[indexPath.row])
        }
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
    func selectedRow()
    func deselectedRow()    
}

// MARK: - TransactionTableViewViewModelDelegate

protocol TransactionTableViewViewModelDelegate: AnyObject {
    func configureViewmodel()
}

// MARK: - ExpandedCellViewDelegate

extension TransactionsTableViewController: ExpandedCellViewDelegate {
    func textfieldNumberTooLarge() {
        let ac = UIAlertController(title: "Error", message: "Please enter amount less than 1 billion", preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
        ac.addAction(ok)
        //self.contributionTextField.text = ""
        present(ac, animated: true)
    }
    
    func canceledHandler() {
        delegate?.deselectedRow()
        deselectAllRows(animated: true)
    }
    
    func confirmHandler(id: String, amount: Int, description: String) {
        HapticFeedbackController.shared.mainButtonTouch()
        
        self.showLoader(true)
        TransactionService.changeTransaction(id: id, withAmount: amount, description: description) { response in
            guard response.error == nil else {
                return
            }            
            UserService.fetchUserData { response in
                guard response.error == nil else { return }
                guard response.value != nil else { return }
                SessionViewController.sessions = response.value!.sessions
                self.viewmodelDelegate?.configureViewmodel()
                
                self.delegate?.deselectedRow()
                self.deselectAllRows(animated: true)
                
                self.showLoader(false)
            }
        }
    }
}

// MARK: - deselectAllRows

extension UITableViewController {
    func deselectAllRows(animated: Bool) {
        guard let selectedRows = tableView.indexPathsForSelectedRows else { return }
        for indexPath in selectedRows { tableView.deselectRow(at: indexPath, animated: animated) }
        UIView.animate(withDuration: 0.3) {
            self.tableView.performBatchUpdates(nil)
        }
    }
}


// MARK: - setupCellSwipeEditStyle

extension UITableViewController {
    
    func SetupCellSwipeEditStyle(forPerson person: Person, forSession session: SessionViewModel, atIndexPath indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        
//        guard AuthService.activeUser?.id == session.ownerId else {
//            return UITableViewCell.EditingStyle.none
//        }
        
        if person.spent.count > 0 && person.owes.count == 0 && person.needs.count == 0 {
            return UITableViewCell.EditingStyle.delete
        } else if person.spent.count == 0 && person.owes.count > 0 {
            return UITableViewCell.EditingStyle.none
        } else if person.spent.count == 0 && person.needs.count > 0 {
            return UITableViewCell.EditingStyle.none
        } else if person.spent.count > 0 && person.owes.count > 0 {
            if indexPath.section == 0 {
                return UITableViewCell.EditingStyle.delete
            } else {
                return UITableViewCell.EditingStyle.none
            }
        } else if person.spent.count > 0 && person.needs.count > 0 {
            if indexPath.section == 0 {
                return UITableViewCell.EditingStyle.delete
            } else {
                return UITableViewCell.EditingStyle.none
            }
        } else {
            return UITableViewCell.EditingStyle.none
        }
    }
    
}
