//
//  LoginController.swift
//  EqualSplitOnline
//
//  Created by Daniel Ilin on 30.12.2021.
//

import Foundation
import UIKit

class LoginController: UIViewController {
    
    
    // MARK: - Properties
    
    private var viewModel = LoginViewModel()
    weak var delegate: AuthenticationDelegate?
    
    private let emailTextField: UITextField = {
        let tf = CustomTextField(placeholder: "Email")
        
        tf.keyboardType = .emailAddress
        tf.autocapitalizationType = .none
        return tf
    }()
    
    private lazy var loginButton: UIButton = {
        let button = AuthButton()
        button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside )
        button.setTitle("Log In", for: .normal)
        button.isEnabled = false
        return button
    }()
    
    private lazy var dontHaveAccountButton: UIButton = {
        let button = UIButton(type: .system)
        button.attributedTitle(firstPart: "Don't have an account? ", secondPart: "Sign Up")
        button.addTarget(self, action: #selector(handleShowSignUp), for: .touchUpInside)
        return button
    }()
    
    private lazy var forgotPasswordButton: UIButton = {
        let button = UIButton(type: .system)
        button.attributedTitle(firstPart: "", secondPart: "Forgot password? ")
        button.addTarget(self, action: #selector(handleForgotPassword), for: .touchUpInside)
        return button
    }()
    
    private let passwordTextField: UITextField = {
        let tf = CustomTextField(placeholder: "Password")
        tf.isSecureTextEntry = true
        tf.autocapitalizationType = .none
        return tf
    }()
    
    private let loginLabel: UILabel = {
        let label = UILabel()
        let atts: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.systemBlue, .font: UIFont.boldSystemFont(ofSize: 40)]
        let attributedTitle = NSMutableAttributedString(string: "Login", attributes: atts)
        label.attributedText = attributedTitle
        return label
    }()
    
    private let welcomeLabel: UILabel = {
        let label = UILabel()
        let atts: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.secondaryLabel, .font: UIFont.systemFont(ofSize: 20)]
        let attributedTitle = NSMutableAttributedString(string: "EqualSplit", attributes: atts)
        label.attributedText = attributedTitle
        return label
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureNotificationObservers()
        hideKeyboardWhenTappedAround()
        
        
    }
    
    // MARK: - Actions
    
    @objc func handleForgotPassword() {
        print("DEBUG: Forgot Password")
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        
        var shouldMoveViewUp = false
        let bottomOfTextField = dontHaveAccountButton.convert(dontHaveAccountButton.bounds, to: self.view).maxY;
        let topOfKeyboard = self.view.frame.height - keyboardSize.height
        
        if bottomOfTextField > topOfKeyboard {
            shouldMoveViewUp = true
        }
        
        if(shouldMoveViewUp) {
            self.view.frame.origin.y = 0 - (bottomOfTextField-topOfKeyboard)
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        // move back the root view origin to zero
        self.view.frame.origin.y = 0
    }
    
    @objc func handleShowSignUp() {
        let controller = RegistrationController()
        controller.delegate = delegate
        navigationController?.pushViewController(controller, animated: true)
    }
    
    @objc func textDidChange(sender: UITextField) {
        if sender == emailTextField {
            viewModel.email = sender.text
        } else {
            viewModel.password = sender.text
        }
        
        updateForm()
    }
    
    @objc func handleLogin() {
        showLoader(true)
        
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        AuthService.loginUser(withEmail: email, password: password) { [weak self] in
            self?.showLoader(false)
            self?.delegate?.authenticationDidComplete()
        } errorHandler: { [weak self] in
            self?.showLoader(false)
        } activateUserHandler: { [weak self] in
            self?.showConfirmationCode(for: email, password: password)
        }
        
    }
    
    // MARK: - Helpers
    
    func showConfirmationCode(for email: String, password: String) {
        let confirmCodeVC = ConfirmationCodeViewController(email: email, password: password, delegate: delegate)
        confirmCodeVC.modalPresentationStyle = .popover
        self.present(confirmCodeVC, animated: true, completion: nil)
    }
    
    func configureUI() {
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.isHidden = true
        navigationController?.navigationBar.barStyle = .black
        
        let topStack = UIStackView(arrangedSubviews: [welcomeLabel, loginLabel])
        topStack.axis = .vertical
        topStack.spacing = 16
        
        view.addSubview(topStack)
        topStack.anchor(left: view.leftAnchor, right: view.rightAnchor, paddingLeft: 32, paddingRight: 32)
        
        NSLayoutConstraint.activate([
            topStack.topAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.topAnchor, constant: 150)
        ])
        
        let stack = UIStackView(arrangedSubviews: [emailTextField, passwordTextField, loginButton, forgotPasswordButton, dontHaveAccountButton])
        stack.axis = .vertical
        stack.spacing = 20
        
        view.addSubview(stack)
        stack.anchor(top: topStack.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 50, paddingLeft: 32, paddingRight: 32)
        
        NSLayoutConstraint.activate([
            stack.bottomAnchor.constraint(lessThanOrEqualTo: view.bottomAnchor, constant: -20)
        ])
        
    }
    
    func configureNotificationObservers() {
        emailTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
}

// MARK: - FormViewModel

extension LoginController: FormViewModel {
    func updateForm() {
        loginButton.backgroundColor = viewModel.buttonBackgroundColor
        loginButton.isEnabled = viewModel.formIsValid
    }
}

// MARK: - hideKeyboardWhenTappedAround

extension LoginController {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}


