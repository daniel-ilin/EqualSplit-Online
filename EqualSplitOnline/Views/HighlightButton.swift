//
//  HighlightButton.swift
//  EqualSplitOnline
//
//  Created by Daniel Ilin on 03.01.2022.
//

import UIKit

class HighlightButton: UIButton {
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
}
