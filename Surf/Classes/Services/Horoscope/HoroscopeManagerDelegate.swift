//
//  HoroscopeManagerDelegate.swift
//  Surf
//
//  Created by Andrey Chernyshev on 03.09.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

protocol HoroscopeManagerDelegate: class {
    func horoscopeManagerDidUpdate(horoscopes: Horoscopes)
}

extension HoroscopeManagerDelegate {
    func horoscopeManagerDidUpdate(horoscopes: Horoscopes) {}
}
