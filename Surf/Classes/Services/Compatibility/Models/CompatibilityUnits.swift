//
//  CompatibilityUnits.swift
//  Surf
//
//  Created by Andrey Chernyshev on 03.09.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

struct CompatibilityUnits {
    let compatibility: String
    let generalScore: Double
    let loveScore: Double
    let trustScore: Double
    let emotionsScore: Double
    let valuesScore: Double
}

// MARK: Make

extension CompatibilityUnits: Model {
    private enum Keys: String, CodingKey {
        case compatibility
        case generalScore = "general_score"
        case loveScore = "love_score"
        case trustScore = "trust_score"
        case emotionsScore = "emotions_score"
        case valuesScore = "values_score"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)
        
        compatibility = try container.decode(String.self, forKey: .compatibility)
        generalScore = try container.decode(Double.self, forKey: .generalScore)
        loveScore = try container.decode(Double.self, forKey: .loveScore)
        trustScore = try container.decode(Double.self, forKey: .trustScore)
        emotionsScore = try container.decode(Double.self, forKey: .emotionsScore)
        valuesScore = try container.decode(Double.self, forKey: .valuesScore)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Keys.self)
        
        try container.encode(compatibility, forKey: .compatibility)
        try container.encode(generalScore, forKey: .generalScore)
        try container.encode(loveScore, forKey: .loveScore)
        try container.encode(trustScore, forKey: .trustScore)
        try container.encode(emotionsScore, forKey: .emotionsScore)
        try container.encode(valuesScore, forKey: .valuesScore)
    }
}
