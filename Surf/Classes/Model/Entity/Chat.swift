//
//  Chat.swift
//  FAWN
//
//  Created by Andrey Chernyshev on 06/06/2020.
//

import Foundation.NSURL

struct Chat {
    let id: String
    let interlocutorId: Int
    let interlocutorName: String
    let interlocutorAvatarUrl: URL?
    private(set) var unreadMessageCount: Int
    let lastMessage: Message?
    let interlocutorGalleryPhotos: [URL]
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
        case interlocutorId = "user_id"
        case interlocutorName = "name"
        case interlocutorAvatarUrl = "avatar"
        case unreadMessageCount = "unread"
        case lastMessage = "message"
        case interlocutorGalleryPhotos = "photos"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)
        
        id = try container.decode(String.self, forKey: .id)
        
        let interlocutor = try container.nestedContainer(keyedBy: InterlocutorKeys.self, forKey: .interlocutor)
        
        interlocutorId = try interlocutor.decode(Int.self, forKey: .interlocutorId)
        interlocutorName = try interlocutor.decode(String.self, forKey: .interlocutorName)
        
        let interlocutorAvatarPath = try? interlocutor.decode(String.self, forKey: .interlocutorAvatarUrl).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        interlocutorAvatarUrl = URL(string: interlocutorAvatarPath ?? "")
        
        unreadMessageCount = (try? interlocutor.decode(Int.self, forKey: .unreadMessageCount)) ?? 0
        lastMessage = try? interlocutor.decode(Message.self, forKey: .lastMessage)
        
        let photos = try? interlocutor.decode([String].self, forKey: .interlocutorGalleryPhotos)
        interlocutorGalleryPhotos = photos?.compactMap { URL(string: $0) } ?? []
    }
}
