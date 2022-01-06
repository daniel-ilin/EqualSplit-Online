//
//  CustomTextField.swift
//  EqualSplitOnline
//
//  Created by Daniel Ilin on 30.12.2021.
//


import Foundation
import UIKit

class CustomTextField: UITextField {
    
    init(placeholder: String) {
        super.init(frame: CGRect.zero)
        
        let spacer = UIView()
        spacer.setDimensions(height: 50, width: 12)
        leftView = spacer        
        leftViewMode = .always
        layer.borderColor = UIColor.systemBlue.withAlphaComponent(0.8).cgColor
        layer.borderWidth = 2
        layer.cornerRadius = 10
        textColor = .black
        keyboardType = .emailAddress
        backgroundColor = .systemBackground
        setHeight(50)
        attributedPlaceholder = NSAttributedString(string: placeholder,
                                                   attributes: [.foregroundColor: UIColor.lightGray])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
