//
//  ProfileScrollView.swift
//  EqualSplitOnline
//
//  Created by Daniel Ilin on 5/2/22.
//

import UIKit

class ProfileScrollView: UIScrollView {
    
    var editingMode = false {
        didSet {
            if editingMode {
                nameTextField.fieldIsActive = true
                nameTextField.becomeFirstResponder()
            } else {
                nameTextField.fieldIsActive = false
                nameTextField.resignFirstResponder()
                changeName()
            }
        }
    }
    
    private var previousName: String?
    
    weak var actionDelegate: ProfileScrollDelegate?
    
    private var contentView = UIView()        
    
    private var nameTextField: ProfileTextField = {
        let tf = ProfileTextField(labelText: " Name ", placeholder: "Name")
        tf.isEnabled = false
        tf.keyboardType = .default
        tf.autocapitalizationType = .none
        tf.spellCheckingType = .no
        return tf
    }()
    
    private var emailTextField: ProfileTextField = {
        let tf = ProfileTextField(labelText: " Email ", placeholder: "Email")
        tf.isEnabled = false
        tf.keyboardType = .emailAddress
        tf.autocapitalizationType = .none
        tf.spellCheckingType = .no
        return tf
    }()
    
    private let welcomeLabel: UILabel = {
        let label = UILabel()
        let atts: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.secondaryLabel, .font: UIFont.systemFont(ofSize: 20)]
        let attributedTitle = NSMutableAttributedString(string: "EqualSplit", attributes: atts)
        label.attributedText = attributedTitle
        return label
    }()
    
    private lazy var resetPasswordButton: UIButton = {
        let button = UIButton(type: .system)
        button.attributedTitle(firstPart: "", secondPart: "Reset password ")
        button.addTarget(self, action: #selector(handleResetPassword), for: .touchUpInside)
        return button
    }()
    
    private lazy var logoutButton: UIButton = {
        let button = UIButton(type: .system)
        button.attributedTitle(firstPart: "", secondPart: "Logout ")
        button.addTarget(self, action: #selector(handleLogout), for: .touchUpInside)
        return button
    }()
    
    private lazy var deleteAccountButton: UIButton = {
        let button = UIButton(type: .system)
        let atts: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.systemRed, .font: UIFont.systemFont(ofSize: 16)]
        let attributedTitle = NSMutableAttributedString(string: "Delete account", attributes: atts)
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.addTarget(self, action: #selector(handleDeleteAccount), for: .touchUpInside)
        return button
    }()
        
    init(frame: CGRect, delegate: UIScrollViewDelegate, actionDelegate: ProfileScrollDelegate) {
        super.init(frame: frame)
        self.delegate = delegate
        self.actionDelegate = actionDelegate
        
                
        setupUi()
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    MARK: - Actions
    
    @objc func handleResetPassword() {
        guard let email = emailTextField.text else { return }
        actionDelegate?.handleResetPassword(email: email)
    }
    
    @objc func handleLogout() {
        actionDelegate?.handleLogout()
    }
    
    @objc func handleDeleteAccount() {
        actionDelegate?.handleDeleteAccount()
    }
    
    private func changeName() {
        guard nameTextField.text != previousName, nameTextField.text != nil, nameTextField.text!.count >= 1 else {            
            nameTextField.text = previousName
            return
        }
        let newname = nameTextField.text!
        previousName = newname
        UserService.changeUserName(to: newname) {
            print("Changed name!")
        }
    }
    
    private func setupUi() {
        
        
//        addSubview(welcomeLabel)
//        welcomeLabel.anchor(top: safeAreaLayoutGuide.topAnchor, left: frameLayoutGuide.leftAnchor, paddingTop: 40, paddingLeft: 32)
        
        addSubview(nameTextField)
        nameTextField.anchor(top: safeAreaLayoutGuide.topAnchor, left: frameLayoutGuide.leftAnchor, right: frameLayoutGuide.rightAnchor, paddingTop: 50, paddingLeft: 32, paddingRight: 32)
        
        addSubview(emailTextField)
        emailTextField.anchor(top: nameTextField.bottomAnchor, left: frameLayoutGuide.leftAnchor, right: frameLayoutGuide.rightAnchor, paddingTop: 32, paddingLeft: 32, paddingRight: 32)
        
        let topStack = UIStackView(arrangedSubviews: [resetPasswordButton, logoutButton])
        topStack.axis = .vertical
        topStack.spacing = 16
        
        addSubview(topStack)
        topStack.anchor(top: emailTextField.bottomAnchor, left: frameLayoutGuide.leftAnchor, right: frameLayoutGuide.rightAnchor, paddingTop: 32, paddingLeft: 32, paddingRight: 32)
        
        addSubview(deleteAccountButton)
        deleteAccountButton.anchor(left: frameLayoutGuide.leftAnchor, bottom: frameLayoutGuide.bottomAnchor, right: frameLayoutGuide.rightAnchor, paddingLeft: 32, paddingBottom: 32, paddingRight: 32)
                
        
    }
    
    func configureView() {
        nameTextField.displayedText = AuthService.activeUser?.name ?? "Error"
        previousName = nameTextField.displayedText
        emailTextField.displayedText = AuthService.activeUser?.email ?? "Error"
    }
    
}


protocol ProfileScrollDelegate: UIScrollViewDelegate {
    func handleLogout()
    func handleResetPassword(email: String)
    func handleDeleteAccount()
}
