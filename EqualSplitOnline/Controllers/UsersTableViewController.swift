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
    
    var currentSessionNum: Int!
    var currentSession: Session!
    
    weak var delegate: UsersTableViewControllerDelegate?
    
    private var activeSession: Session
    
    // MARK: - Lifecycle
    
    init(session: Session) {
        activeSession = session
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
        view.layer.cornerRadius = 20
        didMove(toParent: self)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        
        tableView.register(UserTableViewCell.self, forCellReuseIdentifier: "Cell")        
    }
}

//  MARK: - UITableViewDataSource

extension UsersTableViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return activeSession.users.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? UserTableViewCell
        return cellSetup(ofCell: cell!, at: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
    }
    
//    MARK: - CellSetup
    
    private func cellSetup(ofCell cell: UserTableViewCell, at indexPath: IndexPath)->UITableViewCell {
        cell.personName.text = activeSession.users[indexPath.row].username
//        Some conditions to style the cell
        return cell
    }
    
}

// MARK: - UsersTableViewControllerDelegate

protocol UsersTableViewControllerDelegate: AnyObject {
    func delegateAction()
}
