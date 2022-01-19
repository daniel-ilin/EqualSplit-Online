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
    
    weak var delegate: AddUserTableViewControllerDelegate?
    
    private var sessionCode: String?
    
    // MARK: - Lifecycle
    
    init(sessionCode: String) {
        super.init(style: .plain)
        self.sessionCode = sessionCode
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
    
    func addOfflineUser() {
        let titleString = "Add offline user"
        let ac = UIAlertController(title: titleString , message: "Enter username", preferredStyle: .alert)
        ac.addTextField()
        ac.textFields![0].clearButtonMode = .whileEditing
        
        let confirm = UIAlertAction(title: "Confirm", style: .default) {[weak self] _ in
            print("DEBUG: Add offline user")
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        ac.addAction(cancel)
        ac.addAction(confirm)
        present(ac, animated: true, completion: nil)
    }
    
    func setupUI() {
        tableView.backgroundColor = .systemBackground
        tableView.isUserInteractionEnabled = true
        
        self.clearsSelectionOnViewWillAppear = false
        view.backgroundColor = .systemBackground
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
        return 2
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let codeCell = SessionCodeCell()        
        codeCell.sessionNumber.text = " \(sessionCode!) "
        codeCell.copyToClipboardButtonAction = { [unowned self] in
            UIPasteboard.general.string = sessionCode
            UIView.animate(withDuration: 0.2) {
                let attributedString = NSMutableAttributedString(string: "Copied", attributes: [.font: UIFont.systemFont(ofSize: 18), .foregroundColor: UIColor.label])
                codeCell.copyToClipboard.setAttributedTitle(attributedString, for: .normal)
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 10.0) {
                UIView.animate(withDuration: 0.2) {
                    let attributedString = NSMutableAttributedString(string: "Copy", attributes: [.font: UIFont.boldSystemFont(ofSize: 18), .foregroundColor: UIColor.systemBlue])
                    codeCell.copyToClipboard.setAttributedTitle(attributedString, for: .normal)
                }
            }
        }
        let offlineCell = AddOfflineUserCell()        
        offlineCell.addUserButtonAction = { [unowned self] in
            addOfflineUser()
        }
        offlineCell.isUserInteractionEnabled = true
        if indexPath.row == 0 {
            return codeCell
        } else {
            return offlineCell
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
    }
    
    override func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }

}

// MARK: - ViewForHeaderInSection

extension AddUserTableViewController {
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView()
        let addUserLabel = UILabel()
        addUserLabel.text = "How would you like to add users?"
        addUserLabel.font = UIFont(name: "Avenir Next Medium", size: 18)
        addUserLabel.textColor = .secondaryLabel
        addUserLabel.textAlignment = .center
        addUserLabel.adjustsFontSizeToFitWidth = true
        header.backgroundColor = .systemBackground
        header.addSubview(addUserLabel)
        addUserLabel.anchor(top: header.topAnchor, left: header.leftAnchor, bottom: header.bottomAnchor, right: header.rightAnchor, paddingLeft: 40, paddingBottom: 12, paddingRight: 40)
        return header
    }
}

//extension AddUserTableViewController: UISearchResultsUpdating {
//  func updateSearchResults(for searchController: UISearchController) {
//    // TODO
//  }
//}


protocol AddUserTableViewControllerDelegate: AnyObject {
    func delegateAddUserAction()
}
