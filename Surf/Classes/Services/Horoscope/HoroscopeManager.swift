//
//  HoroscopeManager.swift
//  Surf
//
//  Created by Andrey Chernyshev on 03.09.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import RxSwift

protocol HoroscopeManager: class {
    // MARK: API
    
    func getHoroscopes() -> Horoscopes?
    func hasCachedHoroscopes() -> Bool
    
    // MARK: API (Rx)
    
    func rxGetHoroscopes(forceUpdate: Bool) -> Single<Horoscopes?>
    func rxHasCachedHoroscopes() -> Single<Bool>
    
    // MARK: Observer
    
    func add(observer: HoroscopeManagerDelegate)
    func remove(observer: HoroscopeManagerDelegate)
}
