//
//  MainViewModel.swift
//  Surf
//
//  Created by Andrey Chernyshev on 04.09.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import RxSwift
import RxCocoa

final class MainViewModel {
    func elements() -> Driver<[MainCollectionElement]> {
        .deferred {
            let horoscopeDirect = MainCollectionDirectElement(direct: .horoscope,
                                                              imageName: "Main.Emoji1",
                                                              title: "Main.HoroscopeTitle".localized,
                                                              subTitle: "Main.HoroscopeSubTitle".localized)
            
            let searchDirect = MainCollectionDirectElement(direct: .search,
                                                           imageName: "Main.Emoji2",
                                                           title: "Main.SearchTitle".localized,
                                                           subTitle: "Main.SearchSubTitle".localized)
            
            let chatsDirect = MainCollectionDirectElement(direct: .chats,
                                                          imageName: "Main.Emoji3",
                                                          title: "Main.ChatsTitle".localized,
                                                          subTitle: "Main.ChatsSubTitle".localized)
            
            let horoscopeElement = MainCollectionElement.direct(horoscopeDirect)
            let searchElement = MainCollectionElement.direct(searchDirect)
            let chatsElement = MainCollectionElement.direct(chatsDirect)
            
            let elements = [horoscopeElement, searchElement, chatsElement]
            
            return .just(elements)
        }
    }
}
