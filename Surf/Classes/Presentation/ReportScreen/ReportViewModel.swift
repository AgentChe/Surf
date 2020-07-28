//
//  ReportViewModel.swift
//  FAWN
//
//  Created by Andrey Chernyshev on 23/04/2020.
//  Copyright © 2020 Алексей Петров. All rights reserved.
//

import RxSwift
import RxCocoa

final class ReportViewModel {
    let activityIndicator = RxActivityIndicator()
    
    func createOnChatInterlocutor(report: Report, chatId: String, proposedInterlocutorId: Int) -> Driver<Bool> {
        ReportManager
            .createReportOnChatInterlocutor(chatId: chatId, report: report)
            .flatMap { ReportManager.createReportOnProposedInterlocutor(proposedInterlocutorId: proposedInterlocutorId, report: report) }
            .trackActivity(activityIndicator)
            .map { true }
            .asDriver(onErrorJustReturn: false)
    }
    
    func createOnProposedInterlocutor(report: Report, proposedInterlocutorId: Int) -> Driver<Bool> {
        ReportManager
            .createReportOnProposedInterlocutor(proposedInterlocutorId: proposedInterlocutorId, report: report)
            .trackActivity(activityIndicator)
            .map { true }
            .asDriver(onErrorJustReturn: false)
    }
}
