//
//  ViewController.swift
//  EqualSplitOnline
//
//  Created by Daniel Ilin on 30.12.2021.
//

import UIKit

class SessionViewController: UITableViewController {
    
    //    MARK: - Properties
    
    private var editMode = false {
        didSet {
            topRightButton?.title = editMode ? "Done" : "Edit"            
            tableView.reloadData()
        }
    }
    
    static var sessions = [Session]() {
        didSet {
            let currentUserId = AuthService.activeUser?.id
            for (index, session) in sessions.enumerated() {
                if session.ownerid == currentUserId {
                    sessions.move(from: index, to: 0)                    
                }                
            }
        }
    }
    
    private lazy var addSessionButton: UIButton = {
        let button = HighlightButton()
        button.setTitle("Add session", for: .normal)
        button.addTarget(self, action: #selector(addSession), for: .touchUpInside)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 22)
        button.setTitleColor(.systemBlue, for: .normal)
        return button
    }()
    
    private var topRightButton: UIBarButtonItem?
    
    private let cellReuseIdentifier = "CellReuseIdentifier"
    private let footerReuseIdenifier = "footerReuseIdentifier"
    
    //    MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        configureRefreshControl()        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = false
        self.showLoader(true)
        checkIfUserLoggedIn()
    }

    
    //    MARK: - Helpers
    
    func updateTableView() {
        tableView.reloadData()
    }
    
    func configureUI() {
        self.view.backgroundColor = .secondarySystemBackground
        self.title = "Sessions"
        
        tableView.register(SessionTableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        
        topRightButton = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(editSessions))
        
        navigationItem.rightBarButtonItem = topRightButton
    }
    
    func configureRefreshControl() {
       // Add the refresh control to your UIScrollView object.
       tableView.refreshControl = UIRefreshControl()
       tableView.refreshControl?.addTarget(self, action:
                                          #selector(handleRefreshControl),
                                          for: .valueChanged)
    }
    
    func fetchUser() {
        UserService.fetchUserData { response in
            self.showLoader(false)
            guard response.error == nil else { return }
            guard response.value != nil else { return }
            guard let value = response.value else { return }            
            SessionViewController.sessions = value.sessions
            self.tableView.reloadData()
        }
    }
    
    func checkIfUserLoggedIn() {
        if !AuthService.checkIfUserLoggedIn() {
            DispatchQueue.main.async {
                let controller = LoginController()
                controller.delegate = self
                let nav = UINavigationController(rootViewController: controller)
                nav.modalPresentationStyle = .fullScreen
                self.present(nav, animated: true, completion: nil)
            }
        } else {
            fetchUser()
        }
    }
    
    func createNewSession() {
        let titleString = "Select session name"
        let ac = UIAlertController(title: titleString , message: nil, preferredStyle: .alert)
        ac.addTextField()
        ac.textFields![0].clearButtonMode = .whileEditing
        
        let confirm = UIAlertAction(title: "Confirm", style: .default) {[weak self] _ in
            self?.showLoader(true)
            let sessionName = ac.textFields![0].text
            SessionService.addSession(withName: sessionName ?? "") { response in
                guard response.error == nil else {
                    return
                }
                self?.fetchUser()
            }
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        ac.addAction(cancel)
        ac.addAction(confirm)
        present(ac, animated: true, completion: nil)
    }
    
    func joinSession() {
        let titleString = "Enter session code"
        let ac = UIAlertController(title: titleString , message: nil, preferredStyle: .alert)
        ac.addTextField()
        ac.textFields![0].clearButtonMode = .whileEditing
        
        let confirm = UIAlertAction(title: "Confirm", style: .default) {[weak self] _ in
            
            let sessionCode = ac.textFields![0].text
            SessionService.joinSession(withCode: sessionCode ?? "") { response in                
                guard response.error == nil else {
                    return
                }
                self?.fetchUser()
            }
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        ac.addAction(cancel)
        ac.addAction(confirm)
        present(ac, animated: true, completion: nil)
    }

    
    //    MARK: - Actions
    
    @objc func handleRefreshControl() {
        fetchUser()
        DispatchQueue.main.async {
            self.tableView.refreshControl?.endRefreshing()
        }
    }
    
    @objc func handleLogout() {
        AuthService.logout { response in
            self.checkIfUserLoggedIn()
        }
    }
    
    @objc func addSession() {
        
        let sessionAlert = UIAlertController(title: "Join session with a code or create new?", message: nil, preferredStyle: .actionSheet)
        
        sessionAlert.addAction(UIAlertAction(title: "Create", style: .default, handler: { [weak self] _ in
            self!.createNewSession()
        }))
        sessionAlert.addAction(UIAlertAction(title: "Join", style: .default, handler: { [weak self] _ in
            self!.joinSession()
        }))
        sessionAlert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
        
        present(sessionAlert, animated: true, completion: nil)
                
    }
    
    @objc func editSessions() {
        editMode.toggle()
    }
}

// MARK: - AuthenticationDelegate

extension SessionViewController: AuthenticationDelegate {
    func authenticationDidComplete() {
        self.fetchUser()
        showLoader(false)
        dismiss(animated: true, completion: nil)
    } 
}

// MARK: - TableViewDataSource

extension SessionViewController {
        override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = SessionTableViewCell(style: .default, reuseIdentifier: cellReuseIdentifier)
            cell.delegate = self
            let sessions = SessionViewController.sessions
            cell.configureUI(forSession: sessions[indexPath.row], editMode: editMode)            
            return cell
        }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        SessionViewController.sessions.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = MainViewController(session: SessionViewController.sessions[indexPath.row])
        navigationController?.pushViewController(vc, animated: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.tableView.deselectRow(at: indexPath, animated: true)
        }
    }
}

// MARK: - ViewForFooterInSection

extension SessionViewController {
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footer = UIView()
        footer.backgroundColor = .secondarySystemBackground
        footer.addSubview(addSessionButton)
        addSessionButton.layer.zPosition = 5
        addSessionButton.centerX(inView: footer, topAnchor: footer.topAnchor, paddingTop: 5)
        return footer
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 50
    }
}

// MARK: - SessionCellDelegate

extension SessionViewController: SessionCellDelegate {
    
    func deleteActionHandler(forCell cell: SessionTableViewCell) {
        
        let titleString = "Delete \(cell.sessionName.text!)"
        let messageString = "Session will be deleted for all members. All session data will be lost."
        let ac = UIAlertController(title: titleString, message: messageString, preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        guard let id = cell.session?.id else { return }
        let confirm = UIAlertAction(title: "Delete", style: .destructive) {[weak self] _ in
            self!.showLoader(true)
            SessionService.deleteSession(withId: id) { response in
                guard response.error == nil else { return }
                self?.fetchUser()
            }
        }
        
        ac.addAction(cancel)
        ac.addAction(confirm)
        present(ac, animated: true, completion: nil)
    }
    
    
    func renameActionHandler(forCell cell: SessionTableViewCell) {
        
        let titleString = "Rename \(cell.sessionName.text!)"
        let messageString = "Select new name"
        let ac = UIAlertController(title: titleString, message: messageString, preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        ac.addTextField()
        ac.textFields![0].clearButtonMode = .whileEditing
        guard let id = cell.session?.id else { return }
        let confirm = UIAlertAction(title: "Confirm", style: .default) {[weak self] _ in
            guard let text = ac.textFields![0].text else { return }
            guard text != "" else { return }
            self!.showLoader(true)
            SessionService.renameSession(withId: id, toName: text) { response in
                guard response.error == nil else { return }
                self?.fetchUser()
            }
        }
        ac.addAction(cancel)
        ac.addAction(confirm)
        present(ac, animated: true, completion: nil)
    }
    
}
