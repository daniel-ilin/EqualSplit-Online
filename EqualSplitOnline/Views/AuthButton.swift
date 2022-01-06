//
//  AuthButton.swift
//  EqualSplitOnline
//
//  Created by Daniel Ilin on 30.12.2021.
//

import Foundation
import UIKit

class AuthButton: UIButton {
    
    init() {
        super.init(frame: CGRect.zero)
        setTitleColor(.white, for: .normal)
        backgroundColor = .systemBlue.withAlphaComponent(0.4)
        layer.cornerRadius = 10
        setHeight(50)
        isEnabled = false
        titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var isHighlighted: Bool {
        didSet {
            
            animateButtonTapped(currentAnimation: .released)
            
            if isHighlighted {
                self.alpha = 0.3
            } else {
                self.alpha = 1
            }
        }
    }
    
    func animateButtonTapped(currentAnimation: AnimationCase) {
        
        UIView.animate(withDuration: 0.1, delay: 0, options: [],
                       animations: {
            switch currentAnimation {
            case .pushedDown:
                self.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            case .released:
                self.transform = .identity
            }
        })
    }
}
