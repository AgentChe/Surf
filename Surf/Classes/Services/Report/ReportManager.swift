//
//  ReportManager.swift
//  Surf
//
//  Created by Andrey Chernyshev on 28.07.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import RxSwift

final class ReportManager {
    static let shared = ReportManager()
    
    private init() {}
    
    private var delegates = [Weak<ReportManagerDelegate>]()
}

// MARK: Report

extension ReportManager {
    static func createReportOnChatInterlocutor(chatId: String, report: Report) -> Single<Void> {
        guard let userToken = SessionService.shared.userToken else {
            return .deferred { .error(SignError.tokenNotFound) }
        }
        
        return RestAPITransport()
            .callServerApi(requestBody:  CreateReportOnChatInterlocutorRequest(userToken: userToken,
                                                                               chatId: chatId,
                                                                               report: report))
            .map { _ in Void() }
            .do(onSuccess: {
                shared.delegates.forEach {
                    $0.weak?.reportManagerReported(chatId: chatId)
                }
            })
    }
    
    static func createReportOnProposedInterlocutor(proposedInterlocutorId: Int, report: Report) -> Single<Void> {
        guard let userToken = SessionService.shared.userToken else {
            return .deferred { .error(SignError.tokenNotFound) }
        }
        
        return RestAPITransport()
            .callServerApi(requestBody: CreateReportOnProposedInterlocutorRequest(userToken: userToken,
                                                                                  proposedInterlocutorId: proposedInterlocutorId,
                                                                                  report: report))
            .map { try CheckResponseForError.throwIfError(response: $0) }
            .do(onSuccess: {
                shared.delegates.forEach {
                    $0.weak?.reportManagerReported(proposedInterlocutorId: proposedInterlocutorId)
                }
            })
    }
}


// MARK: Observer

extension ReportManager {
    func add(observer: ReportManagerDelegate) {
        let weakly = observer as AnyObject
        delegates.append(Weak<ReportManagerDelegate>(weakly))
        delegates = delegates.filter { $0.weak != nil }
    }
    
    func remove(observer: ReportManagerDelegate) {
        if let index = delegates.firstIndex(where: { $0.weak === observer }) {
            delegates.remove(at: index)
        }
    }
}
