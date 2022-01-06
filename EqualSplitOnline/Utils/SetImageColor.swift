//
//  ChangeImageColor.swift
//  EqualSplitOnline
//
//  Created by Daniel Ilin on 05.01.2022.
//

import Foundation
import UIKit

extension UIImageView {
  func setImageColor(to color: UIColor) {
    let templateImage = self.image?.withRenderingMode(.alwaysTemplate)
    self.image = templateImage
    self.tintColor = color
  }
}
