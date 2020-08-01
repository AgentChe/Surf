//
//  AppleLoginRequest.swift
//  Surf
//
//  Created by Andrey Chernyshev on 02.08.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import Alamofire

struct AppleLoginRequest: APIRequestBody {
    private let identificator: String
    
    init(identificator: String) {
        self.identificator = identificator
    }
    
    var url: String {
        GlobalDefinitions.Backend.domain + "/api/auth/apple"
    }
    
    var method: HTTPMethod {
        .post
    }
    
    var parameters: Parameters? {
        [
            "_api_key": GlobalDefinitions.Backend.apiKey,
            "identificator": identificator
        ]
    }
}
