//
//  CompatibilityManager.swift
//  Surf
//
//  Created by Andrey Chernyshev on 03.09.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import RxSwift

protocol CompatibilityManager: class {
    // MARK: API
    
    func getCompatibility(whatSignHasThis: ZodiacSign, withWhatSignCompared: ZodiacSign) -> Compatibility?
    func hasCachedCompatibility() -> Bool
    
    // MARK: API (Rx)
    
    func rxGetCompatibility(whatSignHasThis: ZodiacSign, withWhatSignCompared: ZodiacSign, forceUpdate: Bool) -> Single<Compatibility?>
    func rxHasCachedCompatibility() -> Single<Bool>
    
    // MARK: Observer
    
    func add(observer: CompatibilityManagerDelegate)
    func remove(observer: CompatibilityManagerDelegate)
}
