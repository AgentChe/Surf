//
//  CreateReportOnChatInterlocutorRequest.swift
//  Surf
//
//  Created by Andrey Chernyshev on 28.07.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import Alamofire

struct CreateReportOnChatInterlocutorRequest: APIRequestBody {
    private let userToken: String
    private let chatId: String
    private let report: Report
    
    init(userToken: String, chatId: String, report: Report) {
        self.userToken = userToken
        self.chatId = chatId
        self.report = report
    }
    
    var url: String {
        GlobalDefinitions.ChatService.restDomain + "/api/v1/rooms/report"
    }
    
    var method: HTTPMethod {
        .post
    }
    
    var parameters: Parameters? {
        [
            "app_key": GlobalDefinitions.ChatService.appKey,
            "token": userToken,
            "room": chatId,
            "report": [
                "type": report.type.rawValue,
                "wording": report.message ?? "null"
            ]
        ]
    }
}
