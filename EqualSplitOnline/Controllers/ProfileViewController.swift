//
//  ProfileViewController.swift
//  EqualSplitOnline
//
//  Created by Daniel Ilin on 5/2/22.
//

import UIKit

class ProfileViewController: UIViewController {

    var scrollView: ProfileScrollView!
    
    private var editButton: UIBarButtonItem?
    
    private var editMode = false {
        didSet {
            editButton?.title = editMode ? "Done" : "Edit"
            editButton?.style = editMode ? .done : .plain
            scrollView.editingMode = editMode
        }
    }
    
    weak var delegate: ProfileViewDelegate?
    
    init(delegate: ProfileViewDelegate) {
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureUi()
    }
    
    
    private func configureUi() {
        self.title = "Account"
        
        editButton = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(editHandler))
        navigationItem.rightBarButtonItem = editButton
        
        scrollView = ProfileScrollView(frame: view.bounds, delegate: self, actionDelegate: self)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.backgroundColor = .systemBackground
        view.addSubview(scrollView)
        scrollView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor)
    }

    @objc func editHandler() {
        editMode.toggle()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension ProfileViewController: ProfileScrollDelegate {
    
    func handleResetPassword(email: String) {
        let resetPasswordVC = ResetPasswordViewController()
        resetPasswordVC.emailTextField.text = email
        resetPasswordVC.textDidChange(sender: resetPasswordVC.emailTextField)
        resetPasswordVC.modalPresentationStyle = .popover
        present(resetPasswordVC, animated: true, completion: nil)
    }
    
    func handleDeleteAccount() {
        guard let email = AuthService.activeUser?.email else { return }
        let titleString = "Delete your account?"
        let messageString = "\nType your email to confirm \n\n\(email)\n\nYour account will be deleted and all data will be lost."
        let ac = UIAlertController(title: titleString, message: messageString, preferredStyle: .alert)
        ac.addTextField()
        ac.textFields![0].clearButtonMode = .whileEditing
        ac.textFields![0].keyboardType = .emailAddress
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let confirm = UIAlertAction(title: "Delete", style: .destructive) { [weak self] _ in
            let input = ac.textFields![0].text
            guard input == email else { return }
            UserService.deleteAccount { [weak self] in
                self?.navigationController?.popViewController(animated: true)
                self?.delegate?.checkIfUserLoggedIn()
            } errorhandler: { [weak self] in                
                self?.delegate?.checkIfUserLoggedIn()
            }
        }
        
        ac.addAction(cancel)
        ac.addAction(confirm)
        
        present(ac, animated: true)

    }
    
    func handleLogout() {
        navigationController?.popViewController(animated: true)
        AuthService.logout { [weak self] response in
            self?.delegate?.checkIfUserLoggedIn()
        }
    }
}

protocol ProfileViewDelegate: AnyObject {
    func checkIfUserLoggedIn()
}

