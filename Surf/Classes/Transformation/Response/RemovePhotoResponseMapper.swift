//
//  RemovePhotoResponseMapper.swift
//  Surf
//
//  Created by Andrey Chernyshev on 21.07.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

final class RemovePhotoResponseMapper {
    static func from(response: Any) -> [Photo]? {
        guard
            let json = response as? [String: Any],
            let data = json["_data"] as? [String: Any],
            let photos = data["photos"] as? [[String: Any]]
        else {
            return nil
        }
        
        return Photo.parseFromArray(any: photos)
    }
}
