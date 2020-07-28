//
//  ReportManagerDelegate.swift
//  Surf
//
//  Created by Andrey Chernyshev on 28.07.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

protocol ReportManagerDelegate: class {
    func reportManagerReported(chatId: String)
    func reportManagerReported(proposedInterlocutorId: Int)
}

extension ReportManagerDelegate {
    func reportManagerReported(chatId: String) {}
    func reportManagerReported(proposedInterlocutorId: Int) {}
}
