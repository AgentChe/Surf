//
//  StringExtension.swift
//  DrSmart
//
//  Created by Andrey Chernyshev on 04.07.2018.
//  Copyright © 2018 SimbirSoft. All rights reserved.
//

import UIKit.UIFont

extension String {
    static func choosePluralForm(byNumber: Int, one: String, two: String, many: String) -> String {
        var result = many
        let number = byNumber % 100
        
        if (number < 10 || number >= 20) {
            if (number % 10 == 1) {
                result = one
            }
            if (number % 10 > 1 && number % 10 < 5) {
                result = two
            }
        }
        return result
    }
    
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
    
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }

    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }

    func mobilePhoneMask() -> String {
        var characters = Array(self)

        characters.insert("+", at: 0)
        characters.insert(" ", at: 2)
        characters.insert("(", at: 3)
        characters.insert(")", at:7)
        characters.insert(" ", at: 8)
        characters.insert("-", at: 12)
        characters.insert("-", at: 15)

        return String(characters)
    }
}
