//
//  OnboardingViewModel.swift
//  FAWN
//
//  Created by Andrey Chernyshev on 18/04/2020.
//  Copyright © 2020 Алексей Петров. All rights reserved.
//

import RxSwift
import RxCocoa

final class OnboardingViewModel {
    enum Step {
        case main
    }
    
    let myGender = BehaviorRelay<Gender?>(value: nil)
    let showMeToGenders = BehaviorRelay<[Gender]?>(value: nil)
    let name = BehaviorRelay<String?>(value: nil)
    let birthdate = BehaviorRelay<Date?>(value: nil)
    let photoUrls = BehaviorRelay<[String]?>(value: nil)
    let pushNotificationsToken = BehaviorRelay<String?>(value: nil)
    
    let onboardingPassed = PublishRelay<Void>()
    
    func step() -> Driver<Step?> {
        let fillProfile = Observable
            .zip(myGender.skip(1),
                 showMeToGenders.skip(1),
                 birthdate.skip(1),
                 name.skip(1),
                 pushNotificationsToken.skip(1))
            .flatMap { myGender, showMeToGenders, birthdate, name, pushNotificationsToken -> Single<Bool> in
                guard
                    let myGender = myGender,
                    let showMeToGenders = showMeToGenders,
                    let birthdate = birthdate,
                    let name = name
                else {
                    return .deferred { .just(false) }
                }
                
                return ProfileManager.fillProfile(myGender: myGender,
                                                  showMeToGenders: showMeToGenders,
                                                  birthdate: birthdate,
                                                  name: name,
                                                  pushNotificationsToken: pushNotificationsToken)
                
            }
        
        let passed = onboardingPassed.map { true }
        
        return Observable
            .zip(fillProfile, passed) { $0 && $1 }
            .map { $0 ? Step.main : nil }
            .asDriver(onErrorJustReturn: nil)
    }
}
