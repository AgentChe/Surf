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
    func sections() -> Driver<[ProfileTableSection]> {
        ProfileService
            .retrieve()
            .map { [weak self] profile -> [ProfileTableSection] in
                guard let `self` = self, let profile = profile else {
                    return []
                }
                
                return self.prepare(profile: profile)
            }
            .asDriver(onErrorJustReturn: [])
    }
    
    func restorePurchases() -> Driver<Bool> {
        PurchaseService.shared
            .paymentValidate()
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
        
        let clearAllHistoryItem = ProfileTableItem.direction(direction: .clearAllHistory,
                                                             title: "Profile.Direction.ClearAllHistory".localized,
                                                             withIcon: false, maskedCorners: [.layerMinXMinYCorner,
                                                                                              .layerMinXMaxYCorner,
                                                                                              .layerMaxXMinYCorner,
                                                                                              .layerMaxXMaxYCorner])
        let section2 = ProfileTableSection(items: [clearAllHistoryItem])
        result.append(section2)
        
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
        let section3 = ProfileTableSection(items: [restorePurchasesItem, shareSurfItem, contactUsItem])
        result.append(section3)
        
        let privacyPolicyItem = ProfileTableItem.direction(direction: .privacyPolicy,
                                                           title: "Profile.Direction.PrivacyPolicy".localized,
                                                           withIcon: true,
                                                           maskedCorners: [.layerMinXMinYCorner, .layerMaxXMinYCorner])
        let termsOfService = ProfileTableItem.direction(direction: .termsOfService,
                                                        title: "Profile.Direction.TermsOfService".localized,
                                                        withIcon: true,
                                                        maskedCorners: [.layerMinXMaxYCorner, .layerMaxXMaxYCorner])
        let section4 = ProfileTableSection(items: [privacyPolicyItem, termsOfService])
        result.append(section4)
        
        return result
    }
}
