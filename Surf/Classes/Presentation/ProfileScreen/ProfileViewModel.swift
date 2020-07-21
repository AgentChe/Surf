//
//  ProfileViewModel.swift
//  Surf
//
//  Created by Andrey Chernyshev on 19.07.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import RxSwift
import RxCocoa

final class ProfileViewModel {
    let activityIndicator = RxActivityIndicator()
    
    let restorePurchases = PublishRelay<Void>()
    let updateLookingFor = PublishRelay<([Gender], Int, Int)>()
    let removeAllChats = PublishRelay<Void>()
    
    func sections() -> Driver<[ProfileTableSection]> {
        let retrieved = ProfileManager
            .retrieve()
            .map { [weak self] profile -> [ProfileTableSection] in
                guard let `self` = self, let profile = profile else {
                    return []
                }
                
                return self.prepare(profile: profile)
            }
            .asDriver(onErrorJustReturn: [])
        
        let updated = ProfileManager.shared.rx
            .updated.map { [weak self] profile -> [ProfileTableSection] in
                guard let `self` = self else {
                    return []
                }
                
                return self.prepare(profile: profile)
            }
            .asDriver(onErrorJustReturn: [])
        
        return Driver
            .merge(retrieved, updated)
        
    }
    
    func restoredPurchases() -> Driver<Bool> {
        restorePurchases
            .flatMapLatest { [activityIndicator] _ -> Observable<Bool> in
                PurchaseService.shared
                    .paymentValidate()
                    .trackActivity(activityIndicator)
                    .catchErrorJustReturn(false)
            }
            .asDriver(onErrorJustReturn: false)
    }
    
    func updatedLookingFor() -> Driver<Bool> {
        updateLookingFor
            .debounce(.milliseconds(300), scheduler: MainScheduler.asyncInstance)
            .flatMapLatest { bundle -> Single<Bool> in
                let (lookingFor, minAge, maxAge) = bundle
                
                return ProfileManager
                    .change(lookingFor: lookingFor, minAge: minAge, maxAge: maxAge)
                    .catchErrorJustReturn(false)
            }
            .asDriver(onErrorJustReturn: false)
    }

    func removedAllChats() -> Driver<Bool> {
        removeAllChats
            .flatMapLatest { [activityIndicator] _ -> Observable<Bool> in
                ChatsManager.shared
                    .removeAllChats()
                    .trackActivity(activityIndicator)
                    .catchErrorJustReturn(false)
            }
            .asDriver(onErrorJustReturn: false)
    }
}

// MARK: Private

private extension ProfileViewModel {
    func prepare(profile: Profile) -> [ProfileTableSection] {
        var result = [ProfileTableSection]()
        
        let personalItem = ProfileTableItem.personal(name: profile.name,
                                                     birthdate: profile.birthdate,
                                                     emoji: profile.emoji)
        let section1 = ProfileTableSection(items: [personalItem])
        result.append(section1)
        
        let lookingForItem = ProfileTableItem.lookingFor(genders: profile.lookingFor,
                                                         minAge: profile.minAge ?? 18,
                                                         maxAge: profile.maxAge ?? 60)
        let section2 = ProfileTableSection(items: [lookingForItem])
        result.append(section2)
        
        let clearAllHistoryItem = ProfileTableItem.direction(direction: .clearAllHistory,
                                                             title: "Profile.Direction.ClearAllHistory".localized,
                                                             withIcon: false, maskedCorners: [.layerMinXMinYCorner,
                                                                                              .layerMinXMaxYCorner,
                                                                                              .layerMaxXMinYCorner,
                                                                                              .layerMaxXMaxYCorner])
        let section3 = ProfileTableSection(items: [clearAllHistoryItem])
        result.append(section3)
        
        let restorePurchasesItem = ProfileTableItem.direction(direction: .restorePurchases,
                                                              title: "Profile.Direction.RestorePurchases".localized,
                                                              withIcon: true,
                                                              maskedCorners: [.layerMinXMinYCorner, .layerMaxXMinYCorner])
        let shareSurfItem = ProfileTableItem.direction(direction: .shareSurf,
                                                       title: "Profile.Direction.ShareSurf".localized,
                                                       withIcon: true,
                                                       maskedCorners: [])
        let contactUsItem = ProfileTableItem.direction(direction: .contactUs,
                                                       title: "Profile.Direction.ContactUs".localized,
                                                       withIcon: true,
                                                       maskedCorners: [.layerMinXMaxYCorner, .layerMaxXMaxYCorner])
        let section4 = ProfileTableSection(items: [restorePurchasesItem, shareSurfItem, contactUsItem])
        result.append(section4)
        
        let privacyPolicyItem = ProfileTableItem.direction(direction: .privacyPolicy,
                                                           title: "Profile.Direction.PrivacyPolicy".localized,
                                                           withIcon: true,
                                                           maskedCorners: [.layerMinXMinYCorner, .layerMaxXMinYCorner])
        let termsOfService = ProfileTableItem.direction(direction: .termsOfService,
                                                        title: "Profile.Direction.TermsOfService".localized,
                                                        withIcon: true,
                                                        maskedCorners: [.layerMinXMaxYCorner, .layerMaxXMaxYCorner])
        let section5 = ProfileTableSection(items: [privacyPolicyItem, termsOfService])
        result.append(section5)
        
        return result
    }
}
