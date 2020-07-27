//
//  LikeProposedInterlocutorResponseMapper.swift
//  Surf
//
//  Created by Andrey Chernyshev on 27.07.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

final class LikeProposedInterlocutorResponseMapper {
    static func from(response: Any) -> Bool? {
        guard
            let json = response as? [String: Any],
            let data = json["_data"] as? [String: Any]
        else {
            return nil
        }
        
        return data["mutual"] as? Bool
    }
}
