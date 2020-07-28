//
//  Report.swift
//  Surf
//
//  Created by Andrey Chernyshev on 28.07.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

struct Report {
    let type: ReportType
    let message: String?
    
    init(type: ReportType, message: String? = nil) {
        self.type = type
        self.message = message
    }
}
