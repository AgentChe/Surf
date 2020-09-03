//
//  HoroscopeList.swift
//  Surf
//
//  Created by Andrey Chernyshev on 03.09.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

struct Horoscope {
    let on: HoroscopeOn
    let articles: [HoroscopeArticle]
}

// MARK: Make

extension Horoscope: Model {
    private enum Keys: String, CodingKey {
        case on
        case articles
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)
        
        on = try container.decode(HoroscopeOn.self, forKey: .on)
        articles = try container.decode([HoroscopeArticle].self, forKey: .articles)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Keys.self)
        
        try container.encode(on, forKey: .on)
        try container.encode(articles, forKey: .articles)
    }
}
