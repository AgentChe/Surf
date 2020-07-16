//
//  SetRequest.swift
//  FAWN
//
//  Created by Andrey Chernyshev on 19/04/2020.
//  Copyright © 2020 Алексей Петров. All rights reserved.
//

import Alamofire

struct SetRequest: APIRequestBody {
    private let userToken: String
    private let name: String?
    private let birthdate: String?
    private let storeCountry: String?
    private let version: String?
    private let locale: String?
    private let pushNotificationsToken: String?
    private let appUUID: String?
    private let idfa: String?
    private let isAdvertisingTrackingEnabled: Bool?
    private let timezone: String?
   
    init(userToken: String,
         name: String? = nil,
         birthdate: String? = nil,
         storeCountry: String? = nil,
         version: String? = nil,
         locale: String? = nil,
         pushNotificationsToken: String? = nil,
         appUUID: String? = nil,
         idfa: String? = nil,
         isAdvertisingTrackingEnabled: Bool? = nil,
         timezone: String? = nil) {
        self.userToken = userToken
        self.name = name
        self.birthdate = birthdate
        self.storeCountry = storeCountry
        self.version = version
        self.locale = locale
        self.pushNotificationsToken = pushNotificationsToken
        self.appUUID = appUUID
        self.idfa = idfa
        self.isAdvertisingTrackingEnabled = isAdvertisingTrackingEnabled
        self.timezone = timezone
    }
    
    var url: String {
        GlobalDefinitions.Backend.domain + "/api/users/set"
    }
    
    var method: HTTPMethod {
        .post
    }
    
    var parameters: Parameters? {
        var params: Parameters = [
            "_api_key": GlobalDefinitions.Backend.apiKey,
            "_user_token": userToken
        ]
        
        if let name = self.name {
            params["name"] = name
        }
        
        if let birthdate = self.birthdate {
            params["birthdate"] = birthdate
        }
        
        if let storeCountry = self.storeCountry {
            params["store_country"] = storeCountry
        }
        
        if let version = self.version {
            params["version"] = version
        }
        
        if let locale = self.locale {
            params["locale"] = locale
        }
        
        if let pushNotificationsToken = self.pushNotificationsToken {
            params["notification_key"] = pushNotificationsToken
        }
        
        if let appUUID = self.appUUID {
            params["random_string"] = appUUID
        }
        
        if let idfa = self.idfa {
            params["idfa"] = idfa
        }
        
        if let isAdvertisingTrackingEnabled = self.isAdvertisingTrackingEnabled {
            params["ad_tracking"] = isAdvertisingTrackingEnabled
        }
        
        if let timezone = self.timezone {
            params["timezone"] = timezone
        }
        
        return params
    }
}
