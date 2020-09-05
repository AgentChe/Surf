//
//  CompatibilityScoreLineView.swift
//  Surf
//
//  Created by Andrey Chernyshev on 05.09.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import UIKit

final class CompatibilityScoreLineView: UIView {
    // 0 ... 10
    var score: CGFloat = 0 {
        didSet {
            setNeedsLayout()
            layoutIfNeeded()
        }
    }
    
    let topRigthDiagonalView = UIView()
    let topLeftDiagonalView = UIView()
    let bottomRigthDiagonalView = UIView()
    let bottomLeftDiagonalView = UIView()
    let lineView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initialization()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let lineHeight = (frame.height - 10.scale) * (score / 10)
        let lineY = frame.height - 5.scale - lineHeight
        lineView.frame.size = CGSize(width: 2.scale, height: lineHeight)
        lineView.frame.origin = CGPoint(x: (frame.width - 2.scale) / 2, y: lineY)
        
        topRigthDiagonalView.center = CGPoint(x: frame.width / 2, y: lineY)
        topLeftDiagonalView.center = CGPoint(x: frame.width / 2, y: lineY)
        bottomRigthDiagonalView.center = CGPoint(x: frame.width / 2, y: frame.height - 10.scale / 2)
        bottomLeftDiagonalView.center = CGPoint(x: frame.width / 2, y: frame.height - 10.scale / 2)
    }
}

// MARK: Private

private extension CompatibilityScoreLineView {
    func initialization() {
        [
            topRigthDiagonalView,
            topLeftDiagonalView,
            bottomRigthDiagonalView,
            bottomLeftDiagonalView,
            lineView
        ]
            .forEach {
                $0.frame.size = CGSize(width: 2.scale, height: 10.scale)
                $0.backgroundColor = UIColor(red: 1, green: 75 / 255, blue: 89 / 255, alpha: 1)
                addSubview($0)
            }
        
        topRigthDiagonalView.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 4)
        topLeftDiagonalView.transform = CGAffineTransform(rotationAngle: -CGFloat.pi / 4)
        bottomRigthDiagonalView.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 4)
        bottomLeftDiagonalView.transform = CGAffineTransform(rotationAngle: -CGFloat.pi / 4)
    }
}
