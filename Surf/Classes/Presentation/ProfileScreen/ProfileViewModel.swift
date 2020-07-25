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
    let deletePhoto = PublishRelay<Int>()
    let setDefaultPhoto = PublishRelay<Int>()
    let addUserPhoto = PublishRelay<UIImage>()
    let replacePhoto = PublishRelay<(UIImage, Int)>()
    
    func sections() -> Driver<[ProfileTableSection]> {
        let cached = Driver<Profile?>
            .deferred { .just(ProfileManager.get()) }
            .map { [weak self] profile -> [ProfileTableSection] in
                guard let `self` = self, let profile = profile else {
                    return []
                }
            
                return self.prepare(profile: profile)
            }
            .asDriver(onErrorJustReturn: [])
        
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
            .merge(cached, retrieved, updated)
        
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
                ChatsManager
                    .removeAllChats()
                    .trackActivity(activityIndicator)
                    .catchErrorJustReturn(false)
            }
            .asDriver(onErrorJustReturn: false)
    }
    
    func photoDeleted() -> Driver<Bool> {
        deletePhoto
            .flatMapLatest { [activityIndicator] id -> Observable<Bool> in
                ProfileManager
                    .removePhoto(photoId: id)
                    .trackActivity(activityIndicator)
                    .catchErrorJustReturn(false)
            }
            .asDriver(onErrorJustReturn: false)
    }
    
    func photoTakenByDefault() -> Driver<Bool> {
        setDefaultPhoto
            .flatMapLatest { [activityIndicator] id -> Observable<Bool> in
                ProfileManager
                    .setDefaultPhoto(photoId: id)
                    .trackActivity(activityIndicator)
                    .catchErrorJustReturn(false)
            }
            .asDriver(onErrorJustReturn: false)
    }
    
    func userPhotoAdded() -> Driver<(Bool, String?)> {
        addUserPhoto
            .flatMapLatest { [activityIndicator] image -> Observable<(Bool, String?)> in
                ProfileManager
                    .addUserPhoto(image: image)
                    .trackActivity(activityIndicator)
                    .catchErrorJustReturn(nil)
                    .map { response -> (Bool, String?) in
                        guard let response = response else {
                            return (false, "Profile.AddUserPhoto.Failure".localized)
                        }
                        
                        return (response.photos != nil, response.error)
                    }
            }
            .asDriver(onErrorJustReturn: (false, "Profile.AddUserPhoto.Failure".localized))
    }
    
    func photoReplaced() -> Driver<(Bool, String?)> {
        replacePhoto
            .flatMapLatest { [activityIndicator] stub -> Observable<(Bool, String?)> in
                let (image, id) = stub
                
                return ProfileManager
                    .removePhoto(photoId: id)
                    .catchErrorJustReturn(false)
                    .flatMap { success -> Single<(Bool, String?)> in
                        guard success else {
                            return .deferred { .just((false, "Profile.AddUserPhoto.Failure".localized)) }
                        }
                        
                        return ProfileManager
                            .addUserPhoto(image: image)
                            .catchErrorJustReturn(nil)
                            .map { response -> (Bool, String?) in
                                guard let response = response else {
                                    return (false, "Profile.AddUserPhoto.Failure".localized)
                                }
                            
                                return (response.photos != nil, response.error)
                            }
                    }
                    .trackActivity(activityIndicator)
            }
            .asDriver(onErrorJustReturn: (false, "Profile.AddUserPhoto.Failure".localized))
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
        
        let photosItem = ProfileTableItem.photos(photos: profile.photos)
        let section2 = ProfileTableSection(items: [photosItem])
        result.append(section2)
        
        let lookingForItem = ProfileTableItem.lookingFor(genders: profile.lookingFor,
                                                         minAge: profile.minAge ?? 18,
                                                         maxAge: profile.maxAge ?? 60)
        let section3 = ProfileTableSection(items: [lookingForItem])
        result.append(section3)
        
        let clearAllHistoryItem = ProfileTableItem.direction(direction: .clearAllHistory,
                                                             title: "Profile.Direction.ClearAllHistory".localized,
                                                             withIcon: false, maskedCorners: [.layerMinXMinYCorner,
                                                                                              .layerMinXMaxYCorner,
                                                                                              .layerMaxXMinYCorner,
                                                                                              .layerMaxXMaxYCorner])
        let section4 = ProfileTableSection(items: [clearAllHistoryItem])
        result.append(section4)
        
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
        let section5 = ProfileTableSection(items: [restorePurchasesItem, shareSurfItem, contactUsItem])
        result.append(section5)
        
        let privacyPolicyItem = ProfileTableItem.direction(direction: .privacyPolicy,
                                                           title: "Profile.Direction.PrivacyPolicy".localized,
                                                           withIcon: true,
                                                           maskedCorners: [.layerMinXMinYCorner, .layerMaxXMinYCorner])
        let termsOfService = ProfileTableItem.direction(direction: .termsOfService,
                                                        title: "Profile.Direction.TermsOfService".localized,
                                                        withIcon: true,
                                                        maskedCorners: [.layerMinXMaxYCorner, .layerMaxXMaxYCorner])
        let section6 = ProfileTableSection(items: [privacyPolicyItem, termsOfService])
        result.append(section6)
        
        return result
    }
}
