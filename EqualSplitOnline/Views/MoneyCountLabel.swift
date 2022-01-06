//
//  MoneyCountLabel.swift
//  EqualSplitOnline
//
//  Created by Daniel Ilin on 03.01.2022.
//

import Foundation
import UIKit

class MoneyCountLabel: UILabel {
    init() {
        super.init(frame: CGRect.zero)
        
        self.text = "0"
        self.translatesAutoresizingMaskIntoConstraints = false
        self.font = UIFont(name: "Avenir Next Medium", size: 23)
        self.textColor = .white
        self.alpha = 0.95
        self.textAlignment = .right
        self.adjustsFontSizeToFitWidth = true
        self.minimumScaleFactor = 1/10
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
