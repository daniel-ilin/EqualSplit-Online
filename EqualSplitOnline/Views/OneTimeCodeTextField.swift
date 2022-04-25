//
//  OneTimeCodeTextField.swift
//  EqualSplitOnline
//
//  Created by Daniel Ilin on 4/22/22.
//

import Foundation
import UIKit

class OneTimeCodeTextField: UITextField {
    
    var didEnterLastDigit: ((String) -> Void)
    
    private var defaultCharacter = "_"
    
    private var isConfigured = false
    
    private var digitLabels = [UILabel]()
    
    private lazy var tapRecognizer: UITapGestureRecognizer = {
        let recognizer = UITapGestureRecognizer()
        recognizer.addTarget(self, action: #selector(becomeFirstResponder))
        return recognizer
    }()
    
//    MARK: - Lifecycle
    
    init(didEnterLastDigit: @escaping ((String)->Void)) {
        self.didEnterLastDigit = didEnterLastDigit
        super.init(frame: CGRect.null)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    MARK: - Helpers
    
    func configure(with slotCount: Int = 6) {
        guard !isConfigured else { return }
        isConfigured.toggle()
        
        addGestureRecognizer(tapRecognizer)
        
        configureTextField()
        
        let labelStackView = createLabelStackView(with: slotCount)
        addSubview(labelStackView)
        
        labelStackView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor)
    }
    
    private func configureTextField() {
        tintColor = .clear
        textColor = .clear
        keyboardType = .numberPad
        textContentType = .oneTimeCode
        
        addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        delegate = self
    }
    
    private func createLabelStackView(with count: Int) -> UIStackView {
        let sv = UIStackView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .horizontal
        sv.alignment = .fill
        sv.distribution = .fillEqually
        sv.spacing = 8
        
        for _ in 1...count {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.textAlignment = .center
            label.font = .systemFont(ofSize: 40)
            label.isUserInteractionEnabled = true
            label.text = defaultCharacter
            
            sv.addArrangedSubview(label)
            digitLabels.append(label)
        }
        
        return sv
    }
    
    @objc private func textDidChange() {
        
        guard let text = self.text, text.count <= digitLabels.count else { return }
        
        for i in 0..<digitLabels.count {
            let currentLabel = digitLabels[i]
            
            if i < text.count {
                let index = text.index(text.startIndex, offsetBy: i)
                currentLabel.text = String(text[index])
            } else {
                currentLabel.text = defaultCharacter
            }
        }
        
        if text.count == digitLabels.count {
            didEnterLastDigit(text)
        }
    }
    
}

extension OneTimeCodeTextField: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let characterCount = textField.text?.count else { return false }
        return characterCount < digitLabels.count || string == ""
    }
    
}
