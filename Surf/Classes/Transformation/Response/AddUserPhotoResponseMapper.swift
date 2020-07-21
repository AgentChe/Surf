//
//  AddUserPhotoResponseMapper.swift
//  Surf
//
//  Created by Andrey Chernyshev on 21.07.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

final class AddUserPhotoResponseMapper {
    struct AddUserPhotoResponse {
        let url: String?
        let photos: [Photo]?
        let error: String?
    }
    
    static func from(response: Any) -> AddUserPhotoResponse? {
        guard let json = response as? [String: Any] else {
            return nil
        }
        
        if
            let data = json["_data"] as? [String: Any],
            let url = data["url"] as? String,
            let photos = data["photos"] as? [[String: Any]] {
            return AddUserPhotoResponse(url: url, photos: Photo.parseFromArray(any: photos), error: nil)
        } else {
            return AddUserPhotoResponse(url: nil, photos: nil, error: json["_msg"] as? String)
        }
    }
}
