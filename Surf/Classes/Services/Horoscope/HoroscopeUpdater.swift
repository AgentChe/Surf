//
//  HoroscopeUpdater.swift
//  Surf
//
//  Created by Andrey Chernyshev on 04.09.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import RxSwift

final class HoroscopeUpdater {
    static let shared = HoroscopeUpdater()
    
    private let manager = HoroscopeManagerCore()
    
    private init() {}
}

// MARK: API

extension HoroscopeUpdater {
    func updateCache(for sign: ZodiacSign) {
        _ = manager
            .rxGetHoroscopes(for: sign, forceUpdate: true)
            .subscribeOn(ConcurrentMainScheduler.instance)
            .observeOn(MainScheduler.asyncInstance)
            .subscribe()
    }
    
    func updateCacheWithCurrentProfileZodiacSign() {
        _ = getZodiacSign()
            .flatMapCompletable {
                guard let sign = $0 else {
                    return .empty()
                }
                
                return self.rxUpdateCache(for: sign)
            }
            .subscribe()
    }
}

// MARK: API (Rx)

extension HoroscopeUpdater {
    func rxUpdateCache(for sign: ZodiacSign) -> Completable {
        manager
            .rxGetHoroscopes(for: sign, forceUpdate: true)
            .subscribeOn(ConcurrentMainScheduler.instance)
            .observeOn(MainScheduler.asyncInstance)
            .asCompletable()
    }
    
    func rxUpdateCacheWithCurrentProfileZodiacSign() -> Completable {
        getZodiacSign()
            .flatMapCompletable {
                guard let sign = $0 else {
                    return .empty()
                }
            
                return self.rxUpdateCache(for: sign)
            }
    }
}

// MARK: Private

private extension HoroscopeUpdater {
    func getZodiacSign() -> Single<ZodiacSign?> {
        let profile: Single<Profile?>
        
        if let cached = ProfileManager.get() {
            profile = .deferred { .just(cached) }
        } else {
            profile = ProfileManager.retrieve()
        }
        
        return profile
            .observeOn(ConcurrentMainScheduler.instance)
            .map {
                guard let birthdate = $0?.birthdate else {
                    return nil
                }
                
                return ZodiacManager.shared.zodiac(at: birthdate)?.sign
            }
            .observeOn(MainScheduler.asyncInstance)
    }
}
