//
//  RegistrationController.swift
//  EqualSplitOnline
//
//  Created by Daniel Ilin on 30.12.2021.
//

import UIKit
import Alamofire

class RegistrationController: UIViewController {
    
    // MARK: - Utils
    
    deinit {
        
    }
    
    // MARK: - Properties
    
    weak var delegate: AuthenticationDelegate?
    
    private var viewModel = RegistrationViewModel()
    private var profileImage: UIImage?
    
    private lazy var signupButton: UIButton = {
        let button = AuthButton()
        button.setTitle("Sign Up", for: .normal)
        button.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        return button
    }()
    
    private let emailTextField: UITextField = {
        let tf = CustomTextField(placeholder: "Email")
        tf.keyboardType = .emailAddress
        tf.autocapitalizationType = .none
        return tf
    }()
    
    private let passwordTextField: UITextField = {
        let tf = CustomTextField(placeholder: "Password")
        tf.autocapitalizationType = .none
        tf.isSecureTextEntry = true
        return tf
    }()
    
    private let fullnameTextField: UITextField = {
        let tf = CustomTextField(placeholder: "Name")
        tf.keyboardType = .default
        return tf
    }()
    
    private lazy var alreadyHaveAccountButton: UIButton = {
        let button = UIButton(type: .system)
        button.attributedTitle(firstPart: "Already have an account? ", secondPart: "Log In")
        button.addTarget(self, action: #selector(handleShowLogin), for: .touchUpInside)
        return button
    }()
    
    private let signupLabel: UILabel = {
        let label = UILabel()
        let atts: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.systemBlue, .font: UIFont.boldSystemFont(ofSize: 40)]
        let attributedTitle = NSMutableAttributedString(string: "Sign Up", attributes: atts)
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
    
    //    MARK: - Actions
    
    @objc func keyboardWillShow(notification: NSNotification) {        
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        
        var shouldMoveViewUp = false
        let bottomOfTextField = alreadyHaveAccountButton.convert(alreadyHaveAccountButton.bounds, to: self.view).maxY;
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
    
    @objc func handleSignUp() {
        
        HapticFeedbackController.shared.mainButtonTouch()
        
        showLoader(true)
        
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        guard let name = fullnameTextField.text else { return }
        let credentials = AuthCredentials(email: email, name: name, password: password)
        
        AuthService.registerUser(withCredentials: credentials) { [weak self] response in
            self?.showConfirmationCode(for: email, password: password)
            self?.showLoader(false)
        } activateUserHandler: { [weak self] in
            self?.showConfirmationCode(for: email, password: password)
            self?.showLoader(false)
        } errorHandler: { [weak self] in
            self?.showLoader(false)
        }
    }
    
    
    @objc func handleShowLogin() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func textDidChange(sender: UITextField) {
        if sender == emailTextField {
            viewModel.email = sender.text
        } else if sender == passwordTextField {
            viewModel.password = sender.text
        } else if sender == fullnameTextField {
            viewModel.fullname = sender.text
        }
        updateForm()
    }
    
    // MARK: - Helpers
    
    func showConfirmationCode(for email: String, password: String) {
        let confirmCodeVC = ConfirmationCodeViewController(email: email, password: password, delegate: delegate)
        confirmCodeVC.modalPresentationStyle = .popover
        self.present(confirmCodeVC, animated: true, completion: nil)
    }
    
    func configureUI() {
        view.backgroundColor = .systemBackground
        
        let topStack = UIStackView(arrangedSubviews: [welcomeLabel, signupLabel])
        topStack.axis = .vertical
        topStack.spacing = 16
        
        view.addSubview(topStack)
        topStack.anchor(left: view.leftAnchor, right: view.rightAnchor, paddingLeft: 32, paddingRight: 32)
        
        NSLayoutConstraint.activate([
            topStack.topAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.topAnchor, constant: 150)
        ])
        
        let stack = UIStackView(arrangedSubviews: [fullnameTextField, emailTextField, passwordTextField, signupButton, alreadyHaveAccountButton])
        stack.axis = .vertical
        stack.spacing = 20
        
        view.addSubview(stack)
        stack.anchor(top: topStack.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 40, paddingLeft: 32, paddingRight: 32)
        
        NSLayoutConstraint.activate([
            stack.bottomAnchor.constraint(lessThanOrEqualTo: view.bottomAnchor, constant: -20)
        ])
    }
    
    func configureNotificationObservers() {
        emailTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        fullnameTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
}

// MARK: - FormViewModel

extension RegistrationController: FormViewModel {
    func updateForm() {
        signupButton.backgroundColor = viewModel.buttonBackgroundColor
        signupButton.isEnabled = viewModel.formIsValid
    }
}


// MARK: - hideKeyboardWhenTappedAround

extension RegistrationController {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
