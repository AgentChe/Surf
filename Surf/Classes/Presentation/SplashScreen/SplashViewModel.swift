//
//  SplashViewModel.swift
//  FAWN
//
//  Created by Andrey Chernyshev on 22/04/2020.
//  Copyright © 2020 Алексей Петров. All rights reserved.
//

import RxSwift
import RxCocoa

final class SplashViewModel {
    enum Step {
        case banned, registration, main
    }
    
    func step() -> Driver<Step?> {
        guard let userToken = SessionService.shared.userToken else {
            return .deferred { .just(Step.registration) }
        }
        
        return SessionService
            .banned()
            .flatMap { banned -> Single<Step?> in
                guard let banned = banned else {
                    return .deferred { .just(nil) }
                }
                
                if banned {
                    return .deferred { .just(.banned) }
                }
                
                return SessionService
                    .check(token: userToken)
                    .map { $0 ? Step.main : Step.registration }
            }
            .asDriver(onErrorJustReturn: nil)
    }
}
