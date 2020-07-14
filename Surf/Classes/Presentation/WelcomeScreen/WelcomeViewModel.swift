//
//  RegistrationViewModel.swift
//  FAWN
//
//  Created by Andrey Chernyshev on 18/04/2020.
//  Copyright © 2020 Алексей Петров. All rights reserved.
//

import RxSwift
import RxCocoa

final class WelcomeViewModel {
    let authWithFB = PublishRelay<Void>()
    
    func authWithFBComplete() -> Driver<Bool?> {
        authWithFB
            .flatMapLatest {
                SessionService
                    .facebookUser()
                    .catchErrorJustReturn(nil)
            }
            .map { $0?.isNewUser }
            .asDriver(onErrorJustReturn: nil)
    }
}
