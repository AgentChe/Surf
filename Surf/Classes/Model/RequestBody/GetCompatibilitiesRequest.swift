//
//  GetCompatibilityRequest.swift
//  Surf
//
//  Created by Andrey Chernyshev on 03.09.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import Alamofire

struct GetCompatibilitiesRequest: APIRequestBody {
    private let locale: String
    
    init(locale: String) {
        self.locale = locale
    }
    
    var url: String {
        GlobalDefinitions.Backend.domain + "/api/compatibility/all"
    }
    
    var method: HTTPMethod {
        .post
    }
    
    var parameters: Parameters? {
        [
            "_api_key": GlobalDefinitions.Backend.apiKey,
            "locale": locale
        ]
    }
}
