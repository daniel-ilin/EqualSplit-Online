//
//  LineDrawer.swift
//  EqualSplitOnline
//
//  Created by Daniel Ilin on 03.01.2022.
//

import UIKit

struct LineDrawer {
    
    static func drawLineFromPoint(start : CGPoint, toPoint end:CGPoint, ofColor lineColor: UIColor, inView view:UIView, view shapeLayer: CAShapeLayer) {
        
        shapeLayer.removeFromSuperlayer()
        
        //design the path
        let path = UIBezierPath()
        path.move(to: start)
        path.addLine(to: end)
        
        //design path in layer
        shapeLayer.path = path.cgPath
        shapeLayer.strokeColor = lineColor.cgColor
        shapeLayer.lineWidth = 1.0
        shapeLayer.opacity = 0.6
        shapeLayer.zPosition = 100
        view.layer.addSublayer(shapeLayer)
    }
}

class TableLine: CAShapeLayer {    
    func changeColor(to colorName: String) {
        guard let color = UIColor(named: colorName) else { return }
        self.strokeColor = color.cgColor
    }
}
