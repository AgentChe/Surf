//
//  Photo.swift
//  Surf
//
//  Created by Andrey Chernyshev on 21.07.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

struct Photo {
    let id: Int
    let order: Int
    let url: String
}

extension Photo: Model {
    private enum Keys: String, CodingKey {
        case id = "image_id"
        case order
        case url
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)
        
        id = try container.decode(Int.self, forKey: .id)
        order = try container.decode(Int.self, forKey: .order)
        url = try container.decode(String.self, forKey: .url)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Keys.self)
        
        try container.encode(id, forKey: .id)
        try container.encode(order, forKey: .order)
        try container.encode(url, forKey: .url)
    }
}
