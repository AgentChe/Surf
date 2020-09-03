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
            case .scorpio: return "ZodiacSign.Scorpio".localized
            case .pisces: return "ZodiacSign.Pisces".localized
            case .libra: return "ZodiacSign.Libra".localized
            case .sagittarius: return "ZodiacSign.Sagittarius".localized
            case .leo: return "ZodiacSign.Leo".localized
            case .capricorn: return "ZodiacSign.Capricorn".localized
            case .aquarius: return "ZodiacSign.Aquarius".localized
            case .gemini: return "ZodiacSign.Gemini".localized
            case .aries: return "ZodiacSign.Aries".localized
            case .cancer: return "ZodiacSign.Cancer".localized
            case .taurus: return "ZodiacSign.Taurus".localized
            case .virgo: return "ZodiacSign.Virgo".localized
        }
    }
}

// MARK: Index

extension ZodiacSignMapper {
    static func index(_ zodiacSign: ZodiacSign) -> Int {
        switch zodiacSign {
            case .scorpio: return 8
            case .pisces: return 12
            case .libra: return 7
            case .sagittarius: return 9
            case .leo: return 5
            case .capricorn: return 10
            case .aquarius: return 11
            case .gemini: return 3
            case .aries: return 1
            case .cancer: return 4
            case .taurus: return 2
            case .virgo: return 6
        }
    }
    
    static func zodiacSign(from index: Int) -> ZodiacSign? {
        switch index {
            case 8: return .scorpio
            case 12: return .pisces
            case 7: return.libra
            case 9: return .sagittarius
            case 5: return .leo
            case 10: return .capricorn
            case 11: return .aquarius
            case 3: return .gemini
            case 1: return .aries
            case 4: return .cancer
            case 2: return .taurus
            case 6: return .virgo
            default: return nil 
        }
    }
}
