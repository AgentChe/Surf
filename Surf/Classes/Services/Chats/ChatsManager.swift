//
//  ChatsManager.swift
//  Surf
//
//  Created by Andrey Chernyshev on 21.07.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import RxSwift

final class ChatsManager {
    static let shared = ChatsManager()
    
    private var delegates = [Weak<ChatsManagerDelegate>]()
    
    private init() {}
}

// MARK: Retrieve

extension ChatsManager {
    func getChats() -> Single<[Chat]> {
        guard let userToken = SessionService.shared.userToken else {
            return .deferred { .just([]) }
        }
        
        return RestAPITransport()
            .callServerApi(requestBody: GetChatsRequest(userToken: userToken))
            .map { ChatTransformation.from(response: $0) }
    }
}

// NARK: Remove

extension ChatsManager {
    func removeAllChats() -> Single<Bool> {
        guard let userToken = SessionService.shared.userToken else {
            return .deferred { .just(false) }
        }
        
        return RestAPITransport()
            .callServerApi(requestBody: RemoveAllChatsRequest(userToken: userToken))
            .map { (try? !CheckResponseForError.isError(jsonResponse: $0)) ?? false }
            .do(onSuccess: { success in
                guard success else {
                    return
                }
                
                ChatsManager.shared.delegates.forEach {
                    $0.weak?.didRemovedAllChats()
                }
            })
    }
}

// MARK: Observer

extension ChatsManager {
    func add(observer: ChatsManagerDelegate) {
        let weakly = observer as AnyObject
        delegates.append(Weak<ChatsManagerDelegate>(weakly))
        delegates = delegates.filter { $0.weak != nil }
    }
    
    func remove(observer: ChatsManagerDelegate) {
        if let index = delegates.firstIndex(where: { $0.weak === observer }) {
            delegates.remove(at: index)
        }
    }
}
