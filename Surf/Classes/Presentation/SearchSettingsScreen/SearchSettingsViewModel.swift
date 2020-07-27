//
//  SearchSettingsViewModel.swift
//  Surf
//
//  Created by Andrey Chernyshev on 27.07.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import RxSwift
import RxCocoa

final class SearchSettingsViewModel {
    let updateLookingFor = PublishRelay<([Gender], Int, Int)>()
    
    func profile() -> Driver<Profile?> {
        if let cached = ProfileManager.get() {
            return Driver<Profile?>.deferred { .just(cached) }
        }
        
        return ProfileManager
            .retrieve()
            .asDriver(onErrorJustReturn: nil)
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
}
