//
//  ChatMessage.swift
//  FAWN
//
//  Created by Andrey Chernyshev on 06/06/2020.
//  Copyright © 2020 Алексей Петров. All rights reserved.
//

import Foundation.NSDate

enum MessageType: Int {
    case text = 0
    case image = 1
}

struct Message {
    let id: String
    let userName: String
    let isOnline: Bool
    let type: MessageType
    let body: String
    let createdAt: Date
    let isOwner: Bool
}

extension Message: Model {
    private enum Keys: String, CodingKey {
        case id = "guid"
        case userName = "user"
        case isOnline = "is_online"
        case type
        case body = "value"
        case createdAt = "created_at"
        case isOwner = "is_owner"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)

        id = try container.decode(String.self, forKey: .id)
        userName = try container.decode(String.self, forKey: .userName)
        isOnline = try container.decode(Bool.self, forKey: .isOnline)
        
        let typeRawValue = try container.decode(Int.self, forKey: .type)
        guard let type = MessageType(rawValue: typeRawValue) else {
            throw NSError()
        }
        self.type = type
        
        body = try container.decode(String.self, forKey: .body)
        
        let dateValue = try container.decode(String.self, forKey: .createdAt)
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        guard let createdAt = formatter.date(from: dateValue) else {
            throw NSError()
        }
        self.createdAt = createdAt
        
        isOwner = try container.decode(Bool.self, forKey: .isOwner)
    }
    
    func encode(to encoder: Encoder) throws {}
}
