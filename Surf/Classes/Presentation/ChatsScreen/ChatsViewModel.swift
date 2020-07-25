//
//  ChatsViewModel.swift
//  FAWN
//
//  Created by Andrey Chernyshev on 05/06/2020.
//  Copyright © 2020 Алексей Петров. All rights reserved.
//

import RxSwift
import RxCocoa

final class ChatsViewModel {
    private let chatsLiveManager = ChatsLiveManager()
    
    func connect() {
        chatsLiveManager.connect()
    }
    
    func disconnect() {
        chatsLiveManager.disconnect()
    }
    
    var chats: Driver<[Chat]> {
        ChatsManager
            .getChats()
            .asDriver(onErrorJustReturn: [])
    }
    
    func chatEvent() -> Driver<ChatsLiveManager.Event> {
        chatsLiveManager
            .event
            .asDriver(onErrorDriveWith: .never())
    }
    
    func profile() -> Driver<Profile?> {
        let cached = Driver<Profile?>
            .deferred { .just(ProfileManager.get()) }
        
        let retrieved = ProfileManager
            .retrieve()
            .asDriver(onErrorJustReturn: nil)
        
        let updated = ProfileManager.shared.rx
            .updated
            .map { profile -> Profile? in return profile }
            .asDriver(onErrorJustReturn: nil)
        
        return Driver
            .merge(cached, retrieved, updated)
    }
}
