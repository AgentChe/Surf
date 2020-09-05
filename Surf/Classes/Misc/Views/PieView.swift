//
//  PieView.swift
//  Surf
//
//  Created by Andrey Chernyshev on 05.09.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import UIKit

class PieView: UIView {
    var pieBackgroundColor: UIColor = UIColor(red: 239 / 255, green: 239 / 255, blue: 244 / 255, alpha: 1) {
        didSet {
            setNeedsDisplay()
        }
    }
    
    var pieFilledColer: UIColor = UIColor(red: 255 / 255, green: 198 / 255, blue: 67 / 255, alpha: 1) {
        didSet {
            setNeedsDisplay()
        }
    }
    
    // min - 0, max - 10
    var progress: Double = 0.0 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    private static let angleOffset: CGFloat = -90.0
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
        
        pieBackgroundColor.set()
        context.fillEllipse(in: rect)
        
        let prgs = CGFloat(fmax(0.0, fmin(1.0, progress / 10)))
        
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = center.y
        let angle = deg2rad(360.0 * prgs + PieView.angleOffset)
        let points = [
            CGPoint(x: center.x, y: 0.0),
            center,
            CGPoint(x: center.x + radius * cos(angle), y: center.y + radius * sin(angle))
        ]
        
        pieFilledColer.set()
        if prgs > 0.0 {
            context.addLines(between: points)
            context.addArc(center: center, radius: radius, startAngle: deg2rad(PieView.angleOffset), endAngle: angle, clockwise: false)
            context.drawPath(using: .eoFill)
        }
    }
}

// MARK: Private

private extension PieView {
    func deg2rad(_ cgFloat: CGFloat) -> CGFloat {
        return cgFloat * .pi / 180
    }
}
