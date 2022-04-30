//
//  HapticFeedbackController.swift
//  EqualSplitOnline
//
//  Created by Daniel Ilin on 4/26/22.
//

import Foundation
import UIKit

class HapticFeedbackController {
    static let shared = HapticFeedbackController()
    
    func mainButtonTouch() {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
    }
}
