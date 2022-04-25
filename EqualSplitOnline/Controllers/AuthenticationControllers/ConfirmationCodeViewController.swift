//
//  ConfirmationCodeViewController.swift
//  EqualSplitOnline
//
//  Created by Daniel Ilin on 4/22/22.
//

import UIKit

class ConfirmationCodeViewController: UIViewController {

//    MARK: - Properties
    
    private var email: String
    
    private var password: String
    
    private lazy var viewModel = SendCodeViewModel(delegate: self)
    
    private weak var delegate: AuthenticationDelegate?
    
    private var codeMessageLabel: UILabel = {
        let label = UILabel()
        let atts: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.label, .font: UIFont.systemFont(ofSize: 40)]
        let attributedTitle = NSMutableAttributedString(string: "Verify your email", attributes: atts)
        label.attributedText = attributedTitle
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var promptMessageLabel: UILabel = {
        let label = UILabel()
        let atts: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.label, .font: UIFont.systemFont(ofSize: 20)]
        let attributedTitle = NSMutableAttributedString(string: "Please enter the code we sent to \(email)", attributes: atts)
        label.attributedText = attributedTitle
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        return label
    }()
    
    private let welcomeLabel: UILabel = {
        let label = UILabel()
        let atts: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.secondaryLabel, .font: UIFont.systemFont(ofSize: 20)]
        let attributedTitle = NSMutableAttributedString(string: "EqualSplit", attributes: atts)
        label.attributedText = attributedTitle
        return label
    }()
    
    private lazy var sendCodeButton: UIButton = {
        let button = AuthButton()
        button.addTarget(self, action: #selector(handleSendCode), for: .touchUpInside )
        button.setTitle("Send Code", for: .normal)
        button.backgroundColor = .systemBlue
        button.tintColor = .white
        button.isEnabled = true
        return button
    }()
    
    private lazy var codeField = OneTimeCodeTextField { [weak self] code in
        self?.activateAccount(withCode: code)
    }
    
    private lazy var backToRegistration: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        let color = UIColor.secondaryLabel
        let buttonColor = UIImage.SymbolConfiguration(paletteColors: [color])
        let btnImage = UIImage(systemName: "chevron.down", withConfiguration: buttonColor)
        btn.addTarget(self, action: #selector(backToRegistrationHandler), for: .touchUpInside)
        btn.setImage(btnImage, for: .normal)
        return btn
    }()
    
//    MARK: - Lifecycle
    
    init(email: String, password: String, delegate: AuthenticationDelegate?) {
        self.email = email
        self.password = password
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUi()
        configureNotificationObservers()
        
        codeField.becomeFirstResponder()
        handleSendCode()
    }
        
    
//    MARK: - Helpers

    private func activateAccount(withCode code: String) {
        ActivationService.activateUser(withCode: code, withEmail: email) { [weak self] in
            self?.handleLogin()
            self?.backToRegistrationHandler()
        }
    }
    
    private func configureUi() {
        
        view.backgroundColor = .systemBackground
        
        view.addSubview(welcomeLabel)
        welcomeLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 20, paddingLeft: 32, paddingRight: 32)
        
        view.addSubview(codeMessageLabel)
        codeMessageLabel.anchor(top: welcomeLabel.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 20, paddingLeft: 32, paddingRight: 32)
        
        view.addSubview(promptMessageLabel)
        promptMessageLabel.anchor(top: codeMessageLabel.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 20, paddingLeft: 32, paddingRight: 32)
        
        view.addSubview(codeField)
        codeField.anchor(top: promptMessageLabel.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 30, paddingLeft: 32, paddingRight: 32, height: 80)
        
        codeField.configure()
        
        view.addSubview(sendCodeButton)
        sendCodeButton.anchor(top: codeField.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 30, paddingLeft: 32, paddingRight: 32)
        
        view.addSubview(backToRegistration)
        backToRegistration.anchor(top: view.safeAreaLayoutGuide.topAnchor, right: view.rightAnchor, paddingTop: 20, paddingRight: 32)
    }
    
    func configureNotificationObservers() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func handleLogin() {
        showLoader(true)
        print("DEBUG: Trying to login with \(email) & \(password)")
        
        AuthService.loginUser(withEmail: email, password: password) { [weak self] in
            self?.showLoader(false)
            self?.delegate?.authenticationDidComplete()
        } errorHandler: { [weak self] in
            self?.showLoader(false)
        } activateUserHandler: { [weak self] in
            self?.showLoader(false)
            self?.handleSendCode()
        }
        
    }
    
//    MARK: - Actions
    
    @objc func backToRegistrationHandler() {
        showLoader(false)
        dismiss(animated: true, completion: nil)
    }
    
    @objc func handleSendCode() {
        viewModel.startTimer()
        
        ActivationService.requestActivationCode(forEmail: email) {
            print("DEBUG: Code requested")
        }
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        
        var shouldMoveViewUp = false
        let bottomOfTextField = sendCodeButton.convert(sendCodeButton.bounds, to: self.view).maxY;
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
    
}


extension ConfirmationCodeViewController: SendCodeViewModelDelegate {
    
    func updateCounter(to time: Int, isFormValid valid: Bool) {
        sendCodeButton.isEnabled = valid
        sendCodeButton.backgroundColor = viewModel.buttonBackgroundColor
        sendCodeButton.tintColor = viewModel.buttonTitleColor
        if !valid {
            sendCodeButton.setTitle("Resend code in \(time)s", for: .normal)
        } else {
            sendCodeButton.setTitle("Send Code", for: .normal)
        }
    }
    
}
