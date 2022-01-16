//
//  RingPersonIcon.swift
//  EqualSplitOnline
//
//  Created by Daniel Ilin on 08.01.2022.
//

import Foundation
import UIKit

class RingPersonIcon: UIButton {
    init() {
        super.init(frame: CGRect.zero)
        let btnImage = UIImage(named: "personIcon")
        setImage(btnImage?.withRenderingMode(.alwaysTemplate), for: .normal)
        contentMode = .scaleAspectFit
        contentHorizontalAlignment = .fill
        contentVerticalAlignment = .fill
        tintColor = .systemGray5
        isUserInteractionEnabled = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func adjustColor(forPerson person: Person) {
        if person.progress >= 1 {
            pushTransition(0.2)
            tintColor = UIColor(named: "ProgressGreen")!
        } else {
            pushTransition(0.2)
            tintColor = .systemGray5
        }
    }
}
