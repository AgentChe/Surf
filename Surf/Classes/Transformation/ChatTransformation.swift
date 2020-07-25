//
//  ChatTransformation.swift
//  FAWN
//
//  Created by Andrey Chernyshev on 06/06/2020.
//  Copyright © 2020 Алексей Петров. All rights reserved.
//

import Foundation.NSJSONSerialization

final class ChatTransformation {
    static func from(chatWebSocket response: String) -> ChatService.Event? {
        guard
            let jsonData = response.data(using: .utf8),
            let json = try? JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any],
            let result = json["result"] as? [String: Any],
            let action = result["action"] as? String
        else {
            return nil
        }
        
        switch action {
        case "message":
            guard let data = result["result"] as? [String: Any], let message = Message.parseFromDictionary(any: data) else {
                return nil
            }
            
            return .newMessage(message)
        case "unmatch", "report":
            return .removedChat
        default:
            return nil
        }
    }
}
