//
//  ReadMoreViewAttributes.swift
//  Surf
//
//  Created by Andrey Chernyshev on 05.09.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import UIKit

struct ReadMoreViewAttributes {
    let readMoreText: String
    let readMoreColor: UIColor
    let readMoreFont: UIFont
    let readMoreLineHeight: CGFloat
    let readMoreLetterSpacing: CGFloat
    
    let gradientWidth: CGFloat
    let gradientColors: [CGColor]
    
    let textColor: UIColor
    let textFont: UIFont
    let textLineHeight: CGFloat
    let textLetterSpacing: CGFloat
}

// MARK: Make

extension ReadMoreViewAttributes {
    init(_ readMoreText: String,
         readMoreColor: UIColor = UIColor.black,
         readMoreFont: UIFont = UIFont.systemFont(ofSize: 15.scale, weight: .bold),
         readMoreLineHeight: CGFloat = 20.scale,
         readMoreLetterSpacing: CGFloat = -0.3.scale,
         gradientWidth: CGFloat = 135.scale,
         gradientColors: [CGColor],
         textColor: UIColor = UIColor.black,
         textFont: UIFont = UIFont.systemFont(ofSize: 14.scale, weight: .regular),
         textLineHeight: CGFloat = 24.scale,
         textLetterSpacing: CGFloat = -0.005.scale) {
        self.readMoreText = readMoreText
        self.readMoreColor = readMoreColor
        self.readMoreFont = readMoreFont
        self.readMoreLineHeight = readMoreLineHeight
        self.readMoreLetterSpacing = readMoreLetterSpacing
        self.gradientWidth = gradientWidth
        self.gradientColors = gradientColors
        self.textColor = textColor
        self.textFont = textFont
        self.textLineHeight = textLineHeight
        self.textLetterSpacing = textLetterSpacing
    }
}
