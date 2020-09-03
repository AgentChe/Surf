//
//  CompatibilityManagerCore.swift
//  Surf
//
//  Created by Andrey Chernyshev on 03.09.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import RxSwift
import RxCocoa

final class CompatibilityManagerCore: CompatibilityManager {
    private var delegates = [Weak<CompatibilityManagerDelegate>]()
    
    private struct Constants {
        static let compatibilitiesCacheKey = "compatibility_manager_compatibilities_cache_key"
    }
    
    fileprivate let didUpdateCompatibilitiesTrigger = PublishRelay<Compatibilities>()
}

// MARK: API

extension CompatibilityManagerCore {
    func getCompatibility(whatSignHasThis: ZodiacSign, withWhatSignCompared: ZodiacSign) -> Compatibility? {
        guard
            let data = UserDefaults.standard.data(forKey: Constants.compatibilitiesCacheKey),
            let compatibilities = try? Compatibilities.parse(from: data)
        else {
            return nil
        }
        
        return compatibilities[whatSignHasThis, withWhatSignCompared]
    }
    
    func hasCachedCompatibility() -> Bool {
        UserDefaults.standard.data(forKey: Constants.compatibilitiesCacheKey) != nil
    }
}

// MARK: API (Rx)

extension CompatibilityManagerCore {
    func rxGetCompatibility(whatSignHasThis: ZodiacSign, withWhatSignCompared: ZodiacSign, forceUpdate: Bool = false) -> Single<Compatibility?> {
        if forceUpdate {
            return retrieveCompatibilities()
                .map { $0?[whatSignHasThis, withWhatSignCompared] }
        }
        
        if hasCachedCompatibility() {
            return .deferred { [weak self] in
                let compatibility = self?.getCompatibility(whatSignHasThis: whatSignHasThis,
                                                           withWhatSignCompared: withWhatSignCompared)
                
                return .just(compatibility)
            }
        } else {
            return retrieveCompatibilities()
                .map { $0?[whatSignHasThis, withWhatSignCompared] }
        }
    }
    
    func rxHasCachedCompatibility() -> Single<Bool> {
        .deferred { [weak self] in return .just(self?.hasCachedCompatibility() ?? false) }
    }
}

// MARK: Observer

extension CompatibilityManagerCore {
    func add(observer: CompatibilityManagerDelegate) {
        let weakly = observer as AnyObject
        delegates.append(Weak<CompatibilityManagerDelegate>(weakly))
        delegates = delegates.filter { $0.weak != nil }
    }
    
    func remove(observer: CompatibilityManagerDelegate) {
        if let index = delegates.firstIndex(where: { $0.weak === observer }) {
            delegates.remove(at: index)
        }
    }
}

// MARK: Rx

extension CompatibilityManagerCore: ReactiveCompatible {}

extension Reactive where Base: CompatibilityManagerCore {
    var didUpdateCompatibilities: Signal<Compatibilities> {
        base.didUpdateCompatibilitiesTrigger.asSignal()
    }
}
 
// MARK: Private

private extension CompatibilityManagerCore {
    func retrieveCompatibilities() -> Single<Compatibilities?> {
        RestAPITransport()
            .callServerApi(requestBody: GetCompatibilitiesRequest(locale: "en"))
            .map { GetCompatibilitiesResponseMapper.map(response: $0) }
            .catchErrorJustReturn(nil)
            .do(onSuccess: { [weak self] compatibilities in
                guard let value = compatibilities, let data = try? Compatibilities.encode(object: value) else {
                    return
                }
                
                UserDefaults.standard.set(data, forKey: Constants.compatibilitiesCacheKey)
                
                self?.delegates.forEach { $0.weak?.compatibilityManagerDidUpdate(compatibilities: value) }
                
                self?.didUpdateCompatibilitiesTrigger.accept(value)
            })
    }
}
