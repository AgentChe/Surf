//
//  Horoscopes.swift
//  Surf
//
//  Created by Andrey Chernyshev on 03.09.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

struct Horoscopes {
    let list: [Horoscope]
}

// MARK: API

extension Horoscopes {
    subscript (horoOn: HoroscopeOn) -> Horoscope? {
        list.first(where: { $0.on == horoOn })
    }
    
    subscript (zodiacSign: ZodiacSign) -> Horoscope? {
        list.first(where: { $0.forSign == zodiacSign })
    }
}

// MARK: Make

extension Horoscopes: Model {
    private enum Keys: String, CodingKey {
        case list
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)
        
        list = try container.decode([Horoscope].self, forKey: .list)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Keys.self)
        
        try container.encode(list, forKey: .list)
    }
}
