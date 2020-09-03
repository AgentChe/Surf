//
//  Horoscope.swift
//  Surf
//
//  Created by Andrey Chernyshev on 03.09.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

struct HoroscopeArticle {
    let header: String
    let text: String
}

// MARK: Make

extension HoroscopeArticle: Model {
    private enum Keys: String, CodingKey {
        case header
        case text
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)
        
        header = try container.decode(String.self, forKey: .header)
        text = try container.decode(String.self, forKey: .text)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Keys.self)
        
        try container.encode(header, forKey: .header)
        try container.encode(text, forKey: .text)
    }
}
