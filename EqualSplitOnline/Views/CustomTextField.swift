//
//  CustomTextField.swift
//  EqualSplitOnline
//
//  Created by Daniel Ilin on 30.12.2021.
//


import Foundation
import UIKit

class CustomTextField: UITextField {
    
    var outline: UIView = {
        let outline = UIView()
        outline.layer.borderColor = UIColor.systemBlue.withAlphaComponent(0.8).cgColor
        outline.layer.borderWidth = 2
        outline.layer.cornerRadius = 10
        outline.isUserInteractionEnabled = false        
        return outline
    }()
    
    init(placeholder: String) {
        super.init(frame: CGRect.zero)
        
        let spacer = UIView()
        spacer.setDimensions(height: 50, width: 12)
        leftView = spacer        
        leftViewMode = .always
        
        addSubview(outline)
        outline.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor)
        
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

class ProfileTextField: CustomTextField {

    private let labelTextSize: CGFloat = 16
    
    var displayedText: String {
        set(newText) {
            text = newText
        }        
        get {
            return text ?? ""
        }
    }
    
    var fieldIsActive: Bool? {
        didSet {
            guard let fieldIsActive = fieldIsActive else { return }
            
            if fieldIsActive {
                outline.layer.borderColor = UIColor.systemBlue.withAlphaComponent(0.8).cgColor
                setTextLabelColor()
                isEnabled = true
                isUserInteractionEnabled = true
            } else {
                outline.layer.borderColor = UIColor.systemGray3.cgColor
                setTextLabelColor()
                isEnabled = false
                isUserInteractionEnabled = false
            }
        }
    }
    
    lazy var textLabel: UILabel = {
        let label = UILabel()
        label.isUserInteractionEnabled = false
        label.isEnabled = false
        label.backgroundColor = .systemBackground
        let atts: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.systemGray, .font: UIFont.boldSystemFont(ofSize: self.labelTextSize)]
        let attributedTitle = NSMutableAttributedString(string: "", attributes: atts)
        label.attributedText = attributedTitle
        return label
    }()
    
    init(labelText: String, placeholder: String) {
        super.init(placeholder: placeholder)
        
        let atts: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.systemGray, .font: UIFont.boldSystemFont(ofSize: labelTextSize)]
        let attributedTitle = NSMutableAttributedString(string: labelText, attributes: atts)
        textLabel.attributedText = attributedTitle
        addTextLabel()        
    }
    
    private func addTextLabel() {
        
        self.outline.layer.zPosition = 1
        self.textLabel.layer.zPosition = 2
        addSubview(textLabel)
        fieldIsActive = false
        textLabel.anchor(top: topAnchor, left: leftAnchor, paddingTop: -9, paddingLeft: 32)
    }
    
    private func setTextLabelColor() {
        guard let fieldIsActive = fieldIsActive, let text = textLabel.text
        else { return }
        let color = fieldIsActive ? UIColor.systemBlue : UIColor.systemGray
        let atts: [NSAttributedString.Key: Any] = [.foregroundColor: color, .font: UIFont.boldSystemFont(ofSize: self.labelTextSize)]
        let attributedTitle = NSMutableAttributedString(string: text, attributes: atts)
        textLabel.attributedText = attributedTitle
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    
}
