//
//  GetChatsResponseMapper.swift
//  Surf
//
//  Created by Andrey Chernyshev on 25.07.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

final class GetChatsResponseMapper {
    static func from(response: Any) -> [Chat] {
        guard let json = response as? [String: Any], let result = json["result"] as? [[String: Any]] else {
            return []
        }
        
        return result.compactMap { Chat.parseFromDictionary(any: $0) }
    }
}
