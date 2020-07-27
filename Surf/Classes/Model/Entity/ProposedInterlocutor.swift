//
//  ProposedInterlocutor.swift
//  FAWN
//
//  Created by Andrey Chernyshev on 22/04/2020.
//  Copyright © 2020 Алексей Петров. All rights reserved.
//

import Foundation

struct ProposedInterlocutor {
    let id: Int
    let name: String
    let photos: [Photo]
    let emoji: String
    let birthdate: Date
}

extension ProposedInterlocutor: Model {
    private enum Keys: String, CodingKey {
        case id
        case name
        case photos = "photos"
        case emoji
        case birthdate
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)
        
        id = try container.decode(Int.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        photos = try container.decode([Photo].self, forKey: .photos)
        emoji = try container.decode(String.self, forKey: .emoji)
        
        // TODO
        let birthdateStringFormat = "1992-04-17" //try data.decode(String.self, forKey: .birthdate)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        guard let birthdate = dateFormatter.date(from: birthdateStringFormat) else {
            throw NSError()
        }
        self.birthdate = birthdate
    }
    
    func encode(to encoder: Encoder) throws {}
}
