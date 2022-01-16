//
//  AnimatedButton.swift
//  EqualSplitOnline
//
//  Created by Daniel Ilin on 16.01.2022.
//

import Foundation
import UIKit


class AnimatedButton: UIButton {
    override var isHighlighted: Bool {
            didSet {
                animateButtonTapped(currentAnimation: .released)
            }
        }
}

extension UIButton {
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
