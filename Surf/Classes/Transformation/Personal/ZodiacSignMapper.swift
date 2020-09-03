//
//  HoroSignMapper.swift
//  Surf
//
//  Created by Andrey Chernyshev on 19.07.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

final class ZodiacSignMapper {}

// MARK: Sign to name

extension ZodiacSignMapper {
    static func localize(zodiacSign: ZodiacSign) -> String {
        switch zodiacSign {
        case .scorpio:
            return "ZodiacSign.Scorpio".localized
        case .pisces:
            return "ZodiacSign.Pisces".localized
        case .libra:
            return "ZodiacSign.Libra".localized
        case .sagittarius:
            return "ZodiacSign.Sagittarius".localized
        case .leo:
            return "ZodiacSign.Leo".localized
        case .capricorn:
            return "ZodiacSign.Capricorn".localized
        case .aquarius:
            return "ZodiacSign.Aquarius".localized
        case .gemini:
            return "ZodiacSign.Gemini".localized
        case .aries:
            return "ZodiacSign.Aries".localized
        case .cancer:
            return "ZodiacSign.Cancer".localized
        case .taurus:
            return "ZodiacSign.Taurus".localized
        case .virgo:
            return "ZodiacSign.Virgo".localized
        }
    }
}
