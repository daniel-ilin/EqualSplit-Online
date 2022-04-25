//
//  ResetPasswordViewController.swift
//  EqualSplitOnline
//
//  Created by Daniel Ilin on 4/24/22.
//

import Foundation
import UIKit

class ResetPasswordViewController {
    
//    MARK: - Properties
    
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
    
    private lazy var sendCodeButton: UIButton = {
        let button = AuthButton()
        button.addTarget(self, action: #selector(handleSendLink), for: .touchUpInside )
        button.setTitle("Send Link", for: .normal)
        button.backgroundColor = .systemBlue
        button.tintColor = .white
        button.isEnabled = true
        return button
    }()
    
    
// MARK: - Actions
    
    @objc func handleSendLink() {
        
    }
}
