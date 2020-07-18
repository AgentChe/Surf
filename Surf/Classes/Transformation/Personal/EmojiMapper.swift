//
//  EmojiMapper.swift
//  Surf
//
//  Created by Andrey Chernyshev on 18.07.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

final class EmojiMapper {
    static func emoji(response: Any) -> String? {
        guard let json = response as? [String: Any], let data = json["_data"] as? [String: Any] else {
            return nil
        }
        
        return data["emoji"] as? String
    }
}
