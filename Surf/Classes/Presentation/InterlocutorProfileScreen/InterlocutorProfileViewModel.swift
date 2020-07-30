//
//  InterlocutorProfileViewModel.swift
//  Surf
//
//  Created by Andrey Chernyshev on 30.07.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import RxSwift
import RxCocoa

final class InterlocutorProfileViewModel {
    let activityIndicator = RxActivityIndicator()
    
    let unmatch = PublishRelay<String>()
    
    func prepare(interlocutor: ProposedInterlocutor) -> [InterlocutorProfileTableSection] {
        var result = [InterlocutorProfileTableSection]()
        
        let personalItem = InterlocutorProfileTableItem.personal(name: interlocutor.name,
                                                                 birthdate: interlocutor.birthdate,
                                                                 emoji: interlocutor.emoji)
        let section1 = InterlocutorProfileTableSection(items: [personalItem])
        result.append(section1)
        
        let photosItem = InterlocutorProfileTableItem.photos(photos: interlocutor.photos)
        let section2 = InterlocutorProfileTableSection(items: [photosItem])
        result.append(section2)
        
        let unmatch = InterlocutorProfileTableItem.direction(direction: .unmatch,
                                                             title: "InterlocutorProfile.Unmatch".localized,
                                                             withIcon: false,
                                                             maskedCorners: [.layerMinXMinYCorner, .layerMaxXMinYCorner])
        let report = InterlocutorProfileTableItem.direction(direction: .report,
                                                            title: "InterlocutorProfile.Report".localized,
                                                            withIcon: true,
                                                            maskedCorners: [.layerMinXMaxYCorner, .layerMaxXMaxYCorner])
        let section3 = InterlocutorProfileTableSection(items: [unmatch, report])
        result.append(section3)
        
        return result
    }
    
    func unmatched() -> Driver<Bool> {
        unmatch
            .flatMapLatest { [activityIndicator] chatId in
                SearchService
                    .unmatch(chatId: chatId)
                    .trackActivity(activityIndicator)
                    .map { true }
                    .catchErrorJustReturn(false)
            }
            .asDriver(onErrorJustReturn: false)
    }
}
