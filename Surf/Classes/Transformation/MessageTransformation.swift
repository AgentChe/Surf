//
//  MessageTransformation.swift
//  FAWN
//
//  Created by Andrey Chernyshev on 06/06/2020.
//  Copyright © 2020 Алексей Петров. All rights reserved.
//

final class MessageTransformation {
    static func from(response: Any) -> [Message] {
        guard let json = response as? [String: Any],
            let result = json["result"] as? [String: Any],
            let data = result["data"] as? [[String: Any]] else {
            return []
        }
        
        return data.compactMap { Message.parseFromDictionary(any: $0) }
    }
}

