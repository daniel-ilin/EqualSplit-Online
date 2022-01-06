//
//  SearchTableViewController.swift
//  EqualSplitOnline
//
//  Created by Daniel Ilin on 04.01.2022.
//

import Foundation
import UIKit

class AddUserTableViewController: UITableViewController {
    
    // MARK: - Properties
    
    weak var delegate: UsersTableViewControllerDelegate?
//    var searchBar: UISearchBar?
    
    // MARK: - Lifecycle
    
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
        tableView.isUserInteractionEnabled = true
        
        self.clearsSelectionOnViewWillAppear = false
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = 20
        didMove(toParent: self)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        definesPresentationContext = true
    }
}

//  MARK: - UITableViewDataSource

extension AddUserTableViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
    }

}

// MARK: - ViewForHeaderInSection

extension AddUserTableViewController {
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView()
        let addUserLabel = UILabel()
        addUserLabel.text = "How would you like to add users?"
        addUserLabel.font = UIFont(name: "Avenir Next Medium", size: 24)
        addUserLabel.textColor = .secondaryLabel
        addUserLabel.textAlignment = .center
        addUserLabel.adjustsFontSizeToFitWidth = true
        header.addSubview(addUserLabel)
        addUserLabel.anchor(top: header.topAnchor, left: header.leftAnchor, right: header.rightAnchor, paddingLeft: 40, paddingRight: 40)
//        header.isUserInteractionEnabled = true
//        let searchController = UISearchController(searchResultsController: nil)
//        searchController.searchBar.isUserInteractionEnabled = true
//        searchController.searchResultsUpdater = self
//        searchController.obscuresBackgroundDuringPresentation = false
//        searchController.searchBar.placeholder = "Search users"
//        searchController.searchBar.autocapitalizationType = .none
//        header.addSubview(searchController.searchBar)
//        searchController.searchBar.anchor(top: header.topAnchor, left: header.leftAnchor, bottom: header.bottomAnchor, right: header.rightAnchor)
//        searchBar = searchController.searchBar
        return header
    }
}

//extension AddUserTableViewController: UISearchResultsUpdating {
//  func updateSearchResults(for searchController: UISearchController) {
//    // TODO
//  }
//}
