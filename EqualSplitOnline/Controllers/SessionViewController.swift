//
//  ViewController.swift
//  EqualSplitOnline
//
//  Created by Daniel Ilin on 30.12.2021.
//

import UIKit

class SessionViewController: UIViewController {

    //    MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        checkIfUserLoggedIn()        
    }

//    MARK: - Helpers
    
    func configureUI() {
        self.view.backgroundColor = .green
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
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
        }
    }
        
//    MARK: - Actions
    
    @objc func handleLogout() {
        AuthService.logout { response, error in
            if error != nil {
                print(error!)
                return
            }
            self.checkIfUserLoggedIn()
        }
    }
}

// MARK: - AuthenticationDelegate

extension ViewController: AuthenticationDelegate {
    func authenticationDidComplete() {
        self.dismiss(animated: true, completion: nil)
    }
}
