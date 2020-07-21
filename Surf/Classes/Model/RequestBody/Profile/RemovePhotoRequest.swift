//
//  RemovePhotoRequest.swift
//  Surf
//
//  Created by Andrey Chernyshev on 21.07.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import Alamofire

struct RemovePhotoRequest: APIRequestBody {
    private let userToken: String
    private let photoId: Int
    
    init(userToken: String, photoId: Int) {
        self.userToken = userToken
        self.photoId = photoId
    }
    
    var url: String {
        GlobalDefinitions.Backend.domain + "/api/users/remove_photo"
    }
    
    var method: HTTPMethod {
        .post
    }
    
    var parameters: Parameters? {
        [
            "_api_key": GlobalDefinitions.Backend.apiKey,
            "_user_token": userToken,
            "image_id": photoId
        ]
    }
}
