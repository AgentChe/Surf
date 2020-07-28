//
//  CreateReportOnProposedInterlocutorRequest.swift
//  Surf
//
//  Created by Andrey Chernyshev on 28.07.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import Alamofire

struct CreateReportOnProposedInterlocutorRequest: APIRequestBody {
    private let userToken: String
    private let proposedInterlocutorId: Int
    private let report: Report
    
    init(userToken: String, proposedInterlocutorId: Int, report: Report) {
        self.userToken = userToken
        self.proposedInterlocutorId = proposedInterlocutorId
        self.report = report
    }
    
    var url: String {
        GlobalDefinitions.Backend.domain + "/api/cards/report"
    }
    
    var method: HTTPMethod {
        .post
    }
    
    var parameters: Parameters? {
        var params: [String: Any] = [
            "_api_key": GlobalDefinitions.Backend.apiKey,
            "_user_token": userToken,
            "target_user_id": proposedInterlocutorId,
            "reason": report.type.rawValue
        ]
        
        if report.type == .other, let reportMessage = report.message {
            params["custom"] = reportMessage
        }
        
        return params
    }
}
