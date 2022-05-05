//
//  ResetPasswordViewController.swift
//  EqualSplitOnline
//
//  Created by Daniel Ilin on 4/24/22.
//

import Foundation
import UIKit

class ResetPasswordViewController: UIViewController {
    
//    MARK: - Properties
    
    private lazy var viewModel = SendLinkViewModel(delegate: self)
    
    private var targetEmail = "your email"
    
    private var codeMessageLabel: UILabel = {
        let label = UILabel()
        let atts: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.label, .font: UIFont.systemFont(ofSize: 40)]
        let attributedTitle = NSMutableAttributedString(string: "Reset password", attributes: atts)
        label.attributedText = attributedTitle
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var promptMessageLabel: UILabel = {
        let label = UILabel()
        let atts: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.label, .font: UIFont.systemFont(ofSize: 20)]
        let attributedTitle = NSMutableAttributedString(string: "Please enter your email for a password reset link", attributes: atts)
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
    
    let emailTextField: UITextField = {
        let tf = CustomTextField(placeholder: "Email") 
        tf.keyboardType = .emailAddress
        tf.autocapitalizationType = .none
        return tf
    }()
    
    lazy var sendEmailButton: UIButton = {
        let button = AuthButton()
        button.addTarget(self, action: #selector(handleSendLink), for: .touchUpInside )
        button.setTitle("Send Link", for: .normal)        
        button.isEnabled = false
        return button
    }()
    
    private lazy var backToRegistration: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        let color = UIColor.secondaryLabel
        let buttonColor = UIImage.SymbolConfiguration(paletteColors: [color])
        let btnImage = UIImage(systemName: "chevron.down", withConfiguration: buttonColor)
        btn.addTarget(self, action: #selector(backToLogin), for: .touchUpInside)
        btn.setImage(btnImage, for: .normal)
        return btn
    }()
    
    
// MARK: - Actions
    
    @objc func handleSendLink() {
        
        HapticFeedbackController.shared.mainButtonTouch()
        
        showLoader(true)
        
        guard let email = emailTextField.text else { return }
        targetEmail = email
        viewModel.startTimer()
        
        
        ActivationService.sendResetPasswordLink(to: email) { [weak self] in
            self?.changeLabelsToCheckEmail()
            self?.showLoader(false)
            
        } errorHandler: { [weak self] in
            self?.showLoader(false)
        }
    }
    
    @objc func backToLogin() {
        dismiss(animated: true, completion: nil)
    }
    
    
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        var shouldMoveViewUp = false
        let bottomOfTextField = sendEmailButton.convert(sendEmailButton.bounds, to: self.view).maxY;
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
    
    @objc func textDidChange(sender: UITextField) {
        viewModel.email = sender.text
        updateButton()
    }
    
// MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUi()
        configureNotificationObservers()
        
        emailTextField.becomeFirstResponder()
    }
    
// MARK: - Helpers
    
    private func changeLabelsToCheckEmail() {
        let atts1: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.label, .font: UIFont.systemFont(ofSize: 40)]
        let attributedTitle1 = NSMutableAttributedString(string: "Check your email", attributes: atts1)
        
        let atts2: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.label, .font: UIFont.systemFont(ofSize: 20)]
        let attributedTitle2 = NSMutableAttributedString(string: "We sent the link to \(targetEmail)", attributes: atts2)
        
        UIView.animate(withDuration: 0.5) { [weak self] in
            self?.codeMessageLabel.alpha = 0
            self?.promptMessageLabel.alpha = 0
        } completion: { bool in
            self.codeMessageLabel.attributedText = attributedTitle1
            self.promptMessageLabel.attributedText = attributedTitle2
            UIView.animate(withDuration: 0.5) { [weak self] in
                self?.codeMessageLabel.alpha = 1
                self?.promptMessageLabel.alpha = 1
            }
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
        
        view.addSubview(emailTextField)
        emailTextField.anchor(top: promptMessageLabel.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 30, paddingLeft: 32, paddingRight: 32)
        
        view.addSubview(sendEmailButton)
        sendEmailButton.anchor(top: emailTextField.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 30, paddingLeft: 32, paddingRight: 32)
        
        view.addSubview(backToRegistration)
        backToRegistration.anchor(top: view.safeAreaLayoutGuide.topAnchor, right: view.rightAnchor, paddingTop: 20, paddingRight: 32)
        
    }
    
    func configureNotificationObservers() {
        
        emailTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    
}


extension ResetPasswordViewController: SendLinkViewModelDelegate {
    func updateButton() {
        sendEmailButton.isEnabled = viewModel.formIsValid
        sendEmailButton.backgroundColor = viewModel.buttonBackgroundColor
        sendEmailButton.tintColor = viewModel.buttonTitleColor
        if !viewModel.formIsValid && viewModel.timeLeft != 0 {
            sendEmailButton.setTitle("Resend link in \(viewModel.timeLeft)s", for: .normal)
        } else {
            sendEmailButton.setTitle("Send Link", for: .normal)
        }
    }
    
}
