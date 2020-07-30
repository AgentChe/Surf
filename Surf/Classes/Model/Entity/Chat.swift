//
//  Chat.swift
//  FAWN
//
//  Created by Andrey Chernyshev on 06/06/2020.
//

import Foundation.NSURL

struct Chat {
    let id: String
    private(set) var unreadMessageCount: Int
    let interlocutor: ProposedInterlocutor
}

// MARK: Mutating

extension Chat {
    mutating func change(unreadMessageCount: Int) {
        self.unreadMessageCount = unreadMessageCount
    }
}

extension Chat: Model {
    private enum Keys: String, CodingKey {
        case id = "room"
        case interlocutor = "partner"
    }
    
    private enum InterlocutorKeys: String, CodingKey {
        case unreadMessageCount = "unread"
        case id = "user_id"
        case name
        case photos
        case emoji
        case birthdate
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)
        
        id = try container.decode(String.self, forKey: .id)
        
        let interlocutorJSON = try container.nestedContainer(keyedBy: InterlocutorKeys.self, forKey: .interlocutor)
        
        unreadMessageCount = (try? interlocutorJSON.decode(Int.self, forKey: .unreadMessageCount)) ?? 0
        
        let interlocutorId = try interlocutorJSON.decode(Int.self, forKey: .id)
        let interlocutorName = try interlocutorJSON.decode(String.self, forKey: .name)
        let interlocutorPhotos = try interlocutorJSON.decode([Photo].self, forKey: .photos)
        let interlocutorEmoji = try interlocutorJSON.decode(String.self, forKey: .emoji)
        
        let birthdateStringFormat = try interlocutorJSON.decode(String.self, forKey: .birthdate)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        guard let birthdate = dateFormatter.date(from: birthdateStringFormat) else {
            throw NSError()
        }
        
        interlocutor = ProposedInterlocutor(id: interlocutorId,
                                            name: interlocutorName,
                                            photos: interlocutorPhotos,
                                            emoji: interlocutorEmoji,
                                            birthdate: birthdate)
    }
}
