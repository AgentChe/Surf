//
//  HoroscopeManagerCore.swift
//  Surf
//
//  Created by Andrey Chernyshev on 03.09.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import RxSwift

final class HoroscopeManagerCore: HoroscopeManager {
    private var delegates = [Weak<HoroscopeManagerDelegate>]()
    
    private struct Constants {
        static let horoscopesCacheKey = "horoscope_manager_horoscopes_cache_key"
    }
}

// MARK: API

extension HoroscopeManagerCore {
    func getHoroscopes() -> Horoscopes? {
        guard let data = UserDefaults.standard.data(forKey: Constants.horoscopesCacheKey) else {
            return nil
        }
        
        return try? Horoscopes.parse(from: data)
    }
    
    func hasCachedHoroscopes() -> Bool {
        getHoroscopes() != nil
    }
}

// MARK: API (Rx)

extension HoroscopeManagerCore {
    func rxGetHoroscopes(forceUpdate: Bool = false) -> Single<Horoscopes?> {
        if forceUpdate {
            return retrieveHoroscopes()
        }
        
        if let horoscopes = getHoroscopes() {
            return .deferred { .just(horoscopes) }
        } else {
            return retrieveHoroscopes()
        }
    }
    
    func rxHasCachedHoroscopes() -> Single<Bool> {
        .deferred { [weak self] in return .just(self?.hasCachedHoroscopes() ?? false) }
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

// MARK: Private

private extension HoroscopeManagerCore {
    func retrieveHoroscopes() -> Single<Horoscopes?> {
        RestAPITransport()
            .callServerApi(requestBody: GetHoroscopesRequest(zodiacSign: 3,
                                                             locale: "en"))
            .map { GetHoroscopesResponseMapper.map($0) }
            .catchErrorJustReturn(nil)
            .do(onSuccess: { horoscopes in
                guard let value = horoscopes, let data = try? Horoscopes.encode(object: value) else {
                    return
                }
                
                UserDefaults.standard.set(data, forKey: Constants.horoscopesCacheKey)
            })
    }
}
