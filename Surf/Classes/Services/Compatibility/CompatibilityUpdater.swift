//
//  CompatibilityUpdater.swift
//  Surf
//
//  Created by Andrey Chernyshev on 04.09.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import RxSwift

final class CompatibilityUpdater {
    static let shared = CompatibilityUpdater()
    
    private struct Constants {
        static let lastUpdateKey = "horoscope_updater_last_update_key"
    }
    
    private let manager = CompatibilityManagerCore()
    
    private init() {}
}

// MARK: API

extension CompatibilityUpdater {
    func updateCache() {
        _ = manager
            .rxGetCompatibilities()
            .subscribeOn(ConcurrentMainScheduler.instance)
            .observeOn(MainScheduler.asyncInstance)
            .subscribe()
    }
}

// MARK: API (Rx)

extension CompatibilityUpdater {
    func rxUpdateCache() -> Completable {
        manager
            .rxGetCompatibilities()
            .asCompletable()
    }
}
