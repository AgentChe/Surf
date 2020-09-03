//
//  HoroscopeOn.swift
//  Surf
//
//  Created by Andrey Chernyshev on 03.09.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

enum HoroscopeOn: String, Codable {
    case today
    case tomorrow
    case week
    case month
}

// MARK: Identifier

extension HoroscopeOn {
    var identifier: String {
        switch self {
        case .today:
            return "today"
        case .tomorrow:
            return "tomorrow"
        case .week:
            return "week"
        case .month:
            return "month"
        }
    }
}
