//
//  ZodiacManager.swift
//  Surf
//
//  Created by Andrey Chernyshev on 16.07.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import Foundation

final class ZodiacManager {
    static let shared = ZodiacManager()
    
    private init() {}
}

// MARK: Get

extension ZodiacManager {
    func zodiac(at date: Date) -> Zodiac? {
        let selectedMonth = Calendar.current.component(.month, from: date)
        let selectedDay = Calendar.current.component(.day, from: date)
    
        for zodiac in zodiacs {
            if zodiac.fromMonth == selectedMonth && selectedDay >= zodiac.fromDay {
                return zodiac
            } else if zodiac.beforeMonth == selectedMonth && selectedDay <= zodiac.beforeDay {
                return zodiac
            }
        }

        return nil
    }
}

// MARK: Zodiac storage

extension ZodiacManager {
    var zodiacs: [Zodiac] {
        [
            Zodiac(sign: .aquarius, fromMonth: 1, fromDay: 20, beforeMonth: 2, beforeDay: 18),
            Zodiac(sign: .pisces, fromMonth: 2, fromDay: 19, beforeMonth: 3, beforeDay: 20),
            Zodiac(sign: .aries, fromMonth: 3, fromDay: 21, beforeMonth: 4, beforeDay: 19),
            Zodiac(sign: .taurus, fromMonth: 4, fromDay: 20, beforeMonth: 5, beforeDay: 20),
            Zodiac(sign: .gemini, fromMonth: 5, fromDay: 21, beforeMonth: 6, beforeDay: 20),
            Zodiac(sign: .cancer, fromMonth: 6, fromDay: 21, beforeMonth: 7, beforeDay: 22),
            Zodiac(sign: .leo, fromMonth: 7, fromDay: 23, beforeMonth: 8, beforeDay: 22),
            Zodiac(sign: .virgo, fromMonth: 8, fromDay: 23, beforeMonth: 9, beforeDay: 22),
            Zodiac(sign: .libra, fromMonth: 9, fromDay: 23, beforeMonth: 10, beforeDay: 22),
            Zodiac(sign: .scorpio, fromMonth: 10, fromDay: 23, beforeMonth: 11, beforeDay: 21),
            Zodiac(sign: .sagittarius, fromMonth: 11, fromDay: 22, beforeMonth: 12, beforeDay: 21),
            Zodiac(sign: .capricorn, fromMonth: 12, fromDay: 22, beforeMonth: 1, beforeDay: 19)
        ]
    }
}
