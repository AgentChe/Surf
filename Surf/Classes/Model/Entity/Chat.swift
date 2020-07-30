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
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)
        
        id = try container.decode(String.self, forKey: .id)
        
        let interlocutorJSON = try container.nestedContainer(keyedBy: InterlocutorKeys.self, forKey: .interlocutor)
        
        unreadMessageCount = (try? interlocutorJSON.decode(Int.self, forKey: .unreadMessageCount)) ?? 0
        
        // TODO
        interlocutor = try interlocutorJSON.decode(ProposedInterlocutor.self, forKey: .unreadMessageCount)
    }
}
