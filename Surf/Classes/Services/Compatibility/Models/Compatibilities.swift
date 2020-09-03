//
//  Compatibilities.swift
//  Surf
//
//  Created by Andrey Chernyshev on 03.09.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

struct Compatibilities {
    let list: [Compatibility]
    
    subscript (whatZodiacSignHasThis: ZodiacSign, withWhatZodiacSignThisCompared: ZodiacSign) -> Compatibility? {
        list.first(where: { $0.whatZodiacSignHasThis == whatZodiacSignHasThis && $0.withWhatZodiacSignThisCompared == withWhatZodiacSignThisCompared })
    }
}

// MARK: Make

extension Compatibilities: Model {
    private enum Keys: String, CodingKey {
        case list
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)
        
        list = try container.decode([Compatibility].self, forKey: .list)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Keys.self)
        
        try container.encode(list, forKey: .list)
    }
}
