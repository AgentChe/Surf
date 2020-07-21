//
//  CheckUserBannedResponseMapper.swift
//  Surf
//
//  Created by Andrey Chernyshev on 21.07.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import Foundation

final class CheckUserBannedResponseMapper {
    static func banned(response: Any) -> Bool? {
        guard
            let json = response as? [String: Any],
            let data = json["_data"] as? [String: Any]
        else {
            return nil
        }
        
        return data["banned"] as? Bool
    }
}
