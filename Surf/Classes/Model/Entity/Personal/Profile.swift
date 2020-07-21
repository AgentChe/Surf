//
//  Profile.swift
//  Surf
//
//  Created by Andrey Chernyshev on 20.07.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import Foundation.NSDate

struct Profile {
    let id: Int
    let email: String
    let name: String
    let birthdate: Date
    let gender: Gender
    let lookingFor: [Gender]
    let emoji: String
    let minAge: Int?
    let maxAge: Int?
    let photos: [Photo]
}

// MARK: Model

extension Profile: Model {
    private enum Keys: String, CodingKey {
        case data = "_data"
        
        case id
        case email
        case name
        case birthdate
        case gender
        case lookingFor = "looking_for"
        case emoji
        case minAge = "min_age"
        case maxAge = "max_age"
        case photos = "photos"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)
        
        let data = try container.nestedContainer(keyedBy: Keys.self, forKey: .data)
        
        id = try data.decode(Int.self, forKey: .id)
        email = try data.decode(String.self, forKey: .email)
        name = try data.decode(String.self, forKey: .name)
    
        let birthdateStringFormat = try data.decode(String.self, forKey: .birthdate)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        guard let birthdate = dateFormatter.date(from: birthdateStringFormat) else {
            throw NSError()
        }
        self.birthdate = birthdate
        
        let genderCode = try data.decode(Int.self, forKey: .gender)
        guard let gender = GenderMapper.gender(from: genderCode) else {
            throw NSError()
        }
        self.gender = gender
        
        let lookingForCode = try data.decode(Int.self, forKey: .lookingFor)
        guard let lookingFor = GenderMapper.lookingFor(from: lookingForCode) else {
            throw NSError()
        }
        self.lookingFor = lookingFor
        
        emoji = try data.decode(String.self, forKey: .emoji)
        minAge = try? data.decode(Int.self, forKey: .minAge)
        maxAge = try? data.decode(Int.self, forKey: .maxAge)
        
        photos = try data.decode([Photo].self, forKey: .photos)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Keys.self)
        
        var data = container.nestedContainer(keyedBy: Keys.self, forKey: .data)
        
        try data.encode(id, forKey: .id)
        try data.encode(email, forKey: .email)
        try data.encode(name, forKey: .name)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        try data.encode(dateFormatter.string(from: birthdate), forKey: .birthdate)
        
        try data.encode(GenderMapper.rawCode(from: gender), forKey: .gender)
        
        guard let lookingForCode = GenderMapper.lookingForCode(from: lookingFor) else {
            throw NSError()
        }
        try data.encode(lookingForCode, forKey: .lookingFor)
        
        try data.encode(emoji, forKey: .emoji)
        
        if let minAge = self.minAge {
            try data.encode(minAge, forKey: .minAge)
        }
        
        if let maxAge = self.maxAge {
            try data.encode(maxAge, forKey: .maxAge)
        }
        
        try data.encode(photos, forKey: .photos)
    }
}
