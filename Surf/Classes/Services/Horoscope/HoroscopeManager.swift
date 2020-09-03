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
    
    func getHoroscopes(for sign: ZodiacSign) -> Horoscopes?
    func hasCachedHoroscopes(with sign: ZodiacSign) -> Bool
    
    // MARK: API (Rx)
    
    func rxGetHoroscopes(for sign: ZodiacSign, forceUpdate: Bool) -> Single<Horoscopes?>
    func rxHasCachedHoroscopes(with sign: ZodiacSign) -> Single<Bool>
    
    // MARK: Observer
    
    func add(observer: HoroscopeManagerDelegate)
    func remove(observer: HoroscopeManagerDelegate)
}
