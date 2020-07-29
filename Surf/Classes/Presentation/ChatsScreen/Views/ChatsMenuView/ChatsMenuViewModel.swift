//
//  ChatsMenuViewModel.swift
//  Surf
//
//  Created by Andrey Chernyshev on 30.07.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import RxSwift
import RxCocoa

final class ChatsMenuViewModel {
    func unmatch(chat: Chat) -> Driver<Bool> {
        SearchService
            .unmatch(chatId: chat.id)
            .map { true }
            .asDriver(onErrorJustReturn: false)
    }
}
