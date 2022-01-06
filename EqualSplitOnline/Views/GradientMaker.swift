//
//  GradientMaker.swift
//  EqualSplitOnline
//
//  Created by Daniel Ilin on 03.01.2022.
//
import UIKit

struct GradientMaker {
    static func setGradientBackground(in view: UIView, withGradient gradientLayer: CAGradientLayer) {
        gradientLayer.removeFromSuperlayer()
        let colorTop = UIColor.init(named: "BackgroundTop")?.cgColor
        let colorBottom = UIColor.init(named: "BackgroundBottom")?.cgColor
                
        gradientLayer.colors = [colorTop!, colorBottom!]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = view.bounds
        view.layer.insertSublayer(gradientLayer, at:0)
    }
}
