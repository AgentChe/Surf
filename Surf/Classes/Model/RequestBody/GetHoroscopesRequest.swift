//
//  GetHoroRequest.swift
//  Surf
//
//  Created by Andrey Chernyshev on 02.09.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import Alamofire

struct GetHoroscopesRequest: APIRequestBody {
    private let zodiacSign: Int
    private let locale: String
    
    init(zodiacSign: Int, locale: String) {
        self.zodiacSign = zodiacSign
        self.locale = locale
    }
    
    var url: String {
        GlobalDefinitions.Backend.domain + "/api/horoscope/all"
    }
    
    var method: HTTPMethod {
        .post
    }
    
    var parameters: Parameters? {
        [
            "_api_key": GlobalDefinitions.Backend.apiKey,
            "zodiac": zodiacSign,
            "locale": locale
        ]
    }
}
