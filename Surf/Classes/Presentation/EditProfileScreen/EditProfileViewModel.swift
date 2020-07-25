//
//  EditProfileViewModel.swift
//  Surf
//
//  Created by Andrey Chernyshev on 22.07.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import RxSwift
import RxCocoa

final class EditProfileViewModel {
    let activityIndicator = RxActivityIndicator()
    
    let applyChanges = PublishRelay<Void>()
    let deletePhoto = PublishRelay<Int>()
    let setDefaultPhoto = PublishRelay<Int>()
    let addUserPhoto = PublishRelay<UIImage>()
    let replacePhoto = PublishRelay<(UIImage, Int)>()
    let deleteAccount = PublishRelay<Void>()
    
    let nameItem = EditProfileTableNameElement()
    
    func sections() -> Driver<[EditProfileTableSection]> {
        let cached = Driver<Profile?>
            .deferred { .just(ProfileManager.get()) }
            .map { [weak self] profile -> [EditProfileTableSection] in
                guard let `self` = self, let profile = profile else {
                    return []
                }
                
                return self.prepare(profile: profile)
            }
            .asDriver(onErrorJustReturn: [])
        
        let updated = ProfileManager.shared.rx
            .updated
            .map { [weak self] profile -> [EditProfileTableSection] in
                guard let `self` = self else {
                    return []
                }
                
                return self.prepare(profile: profile)
            }
            .asDriver(onErrorJustReturn: [])
        
        return Driver
            .merge(cached, updated)
    }
    
    func changedApplied() -> Driver<Bool> {
        applyChanges
            .flatMapLatest { [activityIndicator, nameItem] _ -> Observable<Bool> in
                guard let name = nameItem.getText?() else {
                    return .deferred { .just(false) }
                }
                
                return ProfileManager
                    .change(name: name)
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
    
    func accountDeleted() -> Driver<Bool> {
        deleteAccount
            .flatMapLatest { [activityIndicator] in
                SessionService
                    .deleteUser()
                    .trackActivity(activityIndicator)
                    .catchErrorJustReturn(false)
            }
            .asDriver(onErrorJustReturn: false)
    }
}

// MARK: Private

private extension EditProfileViewModel {
    func prepare(profile: Profile) -> [EditProfileTableSection] {
        var result = [EditProfileTableSection]()
        
        let photosItem = EditProfileTableItem.photos(photos: profile.photos)
        let section1 = EditProfileTableSection(items: [photosItem])
        result.append(section1)
        
        nameItem.setupIfNeeded(name: profile.name)
        let section2 = EditProfileTableSection(items: [EditProfileTableItem.name(name: nameItem)])
        result.append(section2)
        
        let deleteItem = EditProfileTableItem.delete(email: profile.email)
        let section3 = EditProfileTableSection(items: [deleteItem])
        result.append(section3)
        
        return result
    }
}
