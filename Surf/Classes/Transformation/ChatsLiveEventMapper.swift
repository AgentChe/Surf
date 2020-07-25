//
//  ChatsLiveEventMapper.swift
//  Surf
//
//  Created by Andrey Chernyshev on 25.07.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import Foundation.NSJSONSerialization

final class ChatsLiveEventMapper {
    static func from(string: String) -> ChatsLiveManager.Event? {
        guard
            let jsonData = string.data(using: .utf8),
            let json = try? JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any],
            let result = json["result"] as? [String: Any],
            let action = result["action"] as? String
        else {
            return nil
        }
        
        switch action {
        case "changed":
            guard let data = result["result"] as? [String: Any], let chat = Chat.parseFromDictionary(any: data) else {
                return nil
            }
            
            return .changedChat(chat)
        case "remove":
            guard let data = result["result"] as? [String: Any], let chat = Chat.parseFromDictionary(any: data) else {
                return nil
            }
            
            return .removedChat(chat)
        case "create":
            guard let data = result["result"] as? [String: Any], let chat = Chat.parseFromDictionary(any: data) else {
                return nil
            }
            
            return .createdChat(chat)
        default:
            return nil
        }
    }
}
