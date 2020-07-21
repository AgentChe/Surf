//
//  CheckUserBannedRequest.swift
//  Surf
//
//  Created by Andrey Chernyshev on 21.07.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import Alamofire

struct CheckUserBannedRequest: APIRequestBody {
    private let userToken: String
    
    init(userToken: String) {
        self.userToken = userToken
    }
    
    var url: String {
        GlobalDefinitions.Backend.domain + "/api/users/banned"
    }
    
    var method: HTTPMethod {
        .post
    }
    
    var parameters: Parameters? {
        [
            "_api_key": GlobalDefinitions.Backend.apiKey,
            "_user_token": userToken
        ]
    }
}
