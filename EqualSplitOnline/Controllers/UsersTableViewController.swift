//
//  TableViewController.swift
//  EqualSplitOnline
//
//  Created by Daniel Ilin on 03.01.2022.
//

import Foundation
import UIKit

class UsersTableViewController: UITableViewController {
    
    // MARK: - Properties            
    
    weak var delegate: UsersTableViewControllerDelegate?        
    
    private var activeSession: Session
    private var viewModel: SessionViewModel
    
    // MARK: - Lifecycle
    
    init(session: Session, viewModel: SessionViewModel) {
        activeSession = session
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
        tableView.backgroundColor = .systemBackground
        tableView.rowHeight = 80
        
        self.clearsSelectionOnViewWillAppear = false
        view.backgroundColor = .systemBackground        
        didMove(toParent: self)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        
        tableView.register(UserTableViewCell.self, forCellReuseIdentifier: "Cell")        
    }
    
    func showModalView(forUser rowNumber: Int) {
        let mvc = UserDetailViewController(user: activeSession.users[rowNumber], viewModel: viewModel.people[rowNumber])
        self.present(mvc, animated: true, completion: nil)
    }
}

//  MARK: - UITableViewDataSource

extension UsersTableViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.people.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? UserTableViewCell
        return cellSetup(ofCell: cell!, at: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        showModalView(forUser: indexPath.row)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
    }
    
//    MARK: - CellSetup
    
    private func cellSetup(ofCell cell: UserTableViewCell, at indexPath: IndexPath)->UITableViewCell {
        let person = viewModel.people[indexPath.row]
        cell.personName.text = person.name
        let spentGenetal = IntToCurrency.makeDollars(fromNumber: person.spentGeneral)
        cell.contribution.text = "Spent total: \(spentGenetal ?? "0")"
        var plusMinus = "-"
        if person.ower == .isNeeder {
            plusMinus = "+"
        } else if person.ower == .isClean {
            plusMinus = ""
        }
        cell.debt.text = plusMinus + "\(IntToCurrency.makeDollars(fromNumber: person.totalDebtFieldText ?? 0) ?? "$0.00")"
        cell.debt.textColor = person.moneyTextColor        
        if person.id == AuthService.activeUser?.id {
            cell.userStatus.isHidden = false
            cell.userStatus.text = "Logged In"
        }
        return cell
    }
    
}

// MARK: - UsersTableViewControllerDelegate

protocol UsersTableViewControllerDelegate: AnyObject {
    func delegateAction()
}
