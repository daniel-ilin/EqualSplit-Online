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
    
    var dvc: UserDetailViewController?
    
    weak var delegate: UsersTableViewControllerDelegate?        
    
    weak var viewmodelDelegate: TransactionTableViewViewModelDelegate?
    
    private var activeSession: Session
    var viewModel: SessionViewModel {
        didSet {
            for person in viewModel.people {
                if person.id == dvc?.viewModel.id {
                    dvc?.viewModel = person
                }
            }
            view.pushTransition(0.2)
            tableView.reloadData()
        }
    }
    
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
        configureRefreshControl()
    }
    
    override func viewDidAppear(_ animated: Bool) {
                
    }
    
    //    MARK: - Actions
    
    @objc func handleRefreshControl() {
        UserService.fetchUserData { response in
            guard response.error == nil else { return }
            SessionViewController.sessions = response.value!
            self.viewmodelDelegate?.configureViewmodel()
            DispatchQueue.main.async {
                self.tableView.refreshControl?.endRefreshing()
            }
        }
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
    
    func configureRefreshControl() {
       // Add the refresh control to your UIScrollView object.
       tableView.refreshControl = UIRefreshControl()
       tableView.refreshControl?.addTarget(self, action:
                                          #selector(handleRefreshControl),
                                          for: .valueChanged)
    }
    
    func showModalView(forUser rowNumber: Int) {
        self.showLoader(true)
        UserService.fetchUserData { result in
            if result.error != nil {
                return
            } else {
                self.showLoader(false)
                self.viewmodelDelegate?.configureViewmodel()
            }
        }
        
        dvc = UserDetailViewController(user: activeSession.users[rowNumber], viewModel: viewModel.people[rowNumber], inSessionWithId: viewModel.sessionId)
        dvc!.viewmodelDelegate = self.viewmodelDelegate
        self.present(dvc!, animated: true, completion: nil)
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
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return UITableViewCell.EditingStyle.none
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
        } else {
            cell.userStatus.isHidden = true
        }
        return cell
    }
    
}

// MARK: - UsersTableViewControllerDelegate

protocol UsersTableViewControllerDelegate: AnyObject {
    func delegateAction()
}
