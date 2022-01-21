//
//  RIngProgressBar.swift
//  EqualSplitOnline
//
//  Created by Daniel Ilin on 06.01.2022.
//

import Foundation
import UIKit

class RingProgressBar: UIView {
    var ringWidth: CGFloat!
    var color = UIColor.systemOrange
    var progress: CGFloat = 0 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    private let progressLayer = CAShapeLayer()
    
    override init (frame: CGRect) {
        super.init(frame: frame)
        layer.addSublayer(progressLayer)
    }
    
    required init?(coder: NSCoder) {
        super .init(coder: coder)
        layer.addSublayer(progressLayer)
    }
    
    override func draw(_ rect: CGRect) {
        let backgroundMask = CAShapeLayer()
        if progress >= 1 {
            color = UIColor(named: "ProgressGreen")!
        } else if progress < 0.3 {
            color = UIColor(named: "Red")!
        } else {
            color = UIColor(named: "Orange")!
        }
        ringWidth = 7
        
        let circlePath = UIBezierPath(ovalIn: rect.insetBy(dx: ringWidth/2, dy: ringWidth/2))
        backgroundMask.path = circlePath.cgPath
        backgroundMask.lineWidth = ringWidth
        backgroundMask.fillColor = nil
        backgroundMask.strokeColor = UIColor.black.cgColor
        
        layer.mask = backgroundMask
        layer.backgroundColor = UIColor.systemGray5.cgColor
        
        if progress < 0.05 {
            progress = 0.05
        }
        
        progressLayer.path = circlePath.cgPath
        progressLayer.strokeStart = 0
        progressLayer.strokeEnd = progress
        progressLayer.lineWidth = ringWidth
        progressLayer.fillColor = nil
        progressLayer.strokeColor = color.cgColor
        
        
        layer.addSublayer(progressLayer)
        layer.transform = CATransform3DMakeRotation(CGFloat(90*Double.pi/180), 0, 0, -1)
    }
    
}

