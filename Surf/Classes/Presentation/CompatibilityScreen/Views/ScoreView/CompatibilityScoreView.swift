//
//  CompatibilityScoreView.swift
//  Surf
//
//  Created by Andrey Chernyshev on 05.09.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import UIKit

final class CompatibilityScoreView: UIView {
    var score: Double = 0 {
        didSet {
            scoreView.score = CGFloat(score)
            
            valueLabel.attributedText = String(Int(score))
                .attributed(with: TextAttributes()
                    .textColor(UIColor.black)
                    .font(Font.Poppins.bold(size: 22.scale))
                    .textAlignment(.center))
            
            valueLabel.sizeToFit()
        }
    }
    
    var title: String = "" {
        didSet {
            titleLabel.attributedText = title
                .attributed(with: TextAttributes()
                    .textColor(UIColor(red: 199 / 255, green: 199 / 255, blue: 204 / 255, alpha: 1))
                    .font(Font.OpenSans.regular(size: 11.scale))
                    .textAlignment(.center))
            
            titleLabel.sizeToFit()
        }
    }
    
    let scoreView = CompatibilityScoreLineView()
    let valueLabel = UILabel()
    let titleLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: frameWidth(), height: 120.scale)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let scoreViewX = (frameWidth() - 20.scale) / 2
        scoreView.frame.origin = CGPoint(x: scoreViewX, y: 0)
        scoreView.frame.size = CGSize(width: 20.scale, height: frame.height - 45.scale)
        
        let titleLabelX = (frameWidth() - titleLabel.frame.width) / 2
        let titleLabelY = frame.height - titleLabel.frame.height
        titleLabel.frame.origin = CGPoint(x: titleLabelX, y: titleLabelY)
        
        let valueLabelX = (frameWidth() - valueLabel.frame.width) / 2
        let valueLabelY = titleLabelY - valueLabel.frame.height
        valueLabel.frame.origin = CGPoint(x: valueLabelX, y: valueLabelY)
    }
}

// MARK: Private

private extension CompatibilityScoreView {
    func initialize() {
        addSubview(scoreView)
        addSubview(valueLabel)
        addSubview(titleLabel)
    }
    
    func frameWidth() -> CGFloat {
        max(50.scale, titleLabel.frame.width)
    }
}
