//
//  Compatibility.swift
//  Surf
//
//  Created by Andrey Chernyshev on 03.09.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

struct Compatibility {
    let units: CompatibilityUnits
    let whatZodiacSignHasThis: ZodiacSign
    let withWhatZodiacSignThisCompared: ZodiacSign
}

// MARK: Make

extension Compatibility: Model {
    private enum Keys: String, CodingKey {
        case units
        case whatZodiacSignHasThis
        case withWhatZodiacSignThisCompared
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)
        
        units = try container.decode(CompatibilityUnits.self, forKey: .units)
        whatZodiacSignHasThis = try container.decode(ZodiacSign.self, forKey: .whatZodiacSignHasThis)
        withWhatZodiacSignThisCompared = try container.decode(ZodiacSign.self, forKey: .withWhatZodiacSignThisCompared)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Keys.self)
        
        try container.encode(units, forKey: .units)
        try container.encode(whatZodiacSignHasThis, forKey: .whatZodiacSignHasThis)
        try container.encode(withWhatZodiacSignThisCompared, forKey: .withWhatZodiacSignThisCompared)
    }
}
