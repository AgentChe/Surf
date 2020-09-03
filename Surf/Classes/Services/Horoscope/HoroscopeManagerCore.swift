//
//  HoroscopeManagerCore.swift
//  Surf
//
//  Created by Andrey Chernyshev on 03.09.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import RxSwift
import RxCocoa

final class HoroscopeManagerCore: HoroscopeManager {
    private var delegates = [Weak<HoroscopeManagerDelegate>]()
    
    private struct Constants {
        static let horoscopesCacheKey = "horoscope_manager_horoscopes_cache_key"
    }
    
    fileprivate let didUpdateHoroscopesTrigger = PublishRelay<Horoscopes>()
}

// MARK: API

extension HoroscopeManagerCore {
    func getHoroscopes(for sign: ZodiacSign) -> Horoscopes? {
        guard
            let data = UserDefaults.standard.data(forKey: Constants.horoscopesCacheKey),
            let horoscopes = try? Horoscopes.parse(from: data),
            horoscopes[sign] != nil
        else {
            return nil
        }
        
        return horoscopes
    }
    
    func hasCachedHoroscopes(with sign: ZodiacSign) -> Bool {
        getHoroscopes(for: sign) != nil
    }
}

// MARK: API (Rx)

extension HoroscopeManagerCore {
    func rxGetHoroscopes(for sign: ZodiacSign, forceUpdate: Bool = false) -> Single<Horoscopes?> {
        if forceUpdate {
            return retrieveHoroscopes(sign: sign)
        }
        
        if let horoscopes = getHoroscopes(for: sign) {
            return .deferred { .just(horoscopes) }
        } else {
            return retrieveHoroscopes(sign: sign)
        }
    }
    
    func rxHasCachedHoroscopes(with sign: ZodiacSign) -> Single<Bool> {
        .deferred { [weak self] in return .just(self?.hasCachedHoroscopes(with: sign) ?? false) }
    }
}

// MARK: Observer

extension HoroscopeManagerCore {
    func add(observer: HoroscopeManagerDelegate) {
        let weakly = observer as AnyObject
        delegates.append(Weak<HoroscopeManagerDelegate>(weakly))
        delegates = delegates.filter { $0.weak != nil }
    }
    
    func remove(observer: HoroscopeManagerDelegate) {
        if let index = delegates.firstIndex(where: { $0.weak === observer }) {
            delegates.remove(at: index)
        }
    }
}

// MARK: RX

extension HoroscopeManagerCore: ReactiveCompatible {}

extension Reactive where Base: HoroscopeManagerCore {
    var didUpdateHoroscopes: Signal<Horoscopes> {
        base.didUpdateHoroscopesTrigger.asSignal()
    }
}

// MARK: Private

private extension HoroscopeManagerCore {
    func retrieveHoroscopes(sign: ZodiacSign) -> Single<Horoscopes?> {
        RestAPITransport()
            .callServerApi(requestBody: GetHoroscopesRequest(zodiacSign: ZodiacSignMapper.index(sign),
                                                             locale: "en"))
            .map { GetHoroscopesResponseMapper.map(response: $0,
                                                   zodiacSign: sign) }
            .catchErrorJustReturn(nil)
            .do(onSuccess: { [weak self] horoscopes in
                guard let value = horoscopes, let data = try? Horoscopes.encode(object: value) else {
                    return
                }
                
                UserDefaults.standard.set(data, forKey: Constants.horoscopesCacheKey)
                
                self?.delegates.forEach { $0.weak?.horoscopeManagerDidUpdate(horoscopes: value) }
                
                self?.didUpdateHoroscopesTrigger.accept(value)
            })
    }
}
