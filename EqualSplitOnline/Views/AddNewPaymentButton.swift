//
//  AddNewPaymentButton.swift
//  EqualSplitOnline
//
//  Created by Daniel Ilin on 08.01.2022.
//

import Foundation
import UIKit

class AddNewPaymentButton: UIButton {
    init() {
        super.init(frame: CGRect.zero)
        
//        let color = UIImage.SymbolConfiguration(hierarchicalColor: .black)
        let color = UIColor(named: "ButtonBlue")
        let buttonColor = UIImage.SymbolConfiguration(paletteColors: [color!])
        let btnImage = UIImage(systemName: "plus.circle.fill", withConfiguration: buttonColor)
        setImage(btnImage, for: .normal)
        let attributedTitle = NSMutableAttributedString(string: "Add new payment ", attributes: [.font: UIFont(name: "Avenir Next Medium", size: 18)!, .foregroundColor: UIColor.secondaryLabel])
        setAttributedTitle(attributedTitle, for: .normal)
        semanticContentAttribute = .forceRightToLeft
        titleLabel?.adjustsFontSizeToFitWidth = true        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var isHighlighted: Bool {
        didSet {
            if isHighlighted {
                self.alpha = 0.3
            } else {
                self.alpha = 1
            }
        }
    }
}
