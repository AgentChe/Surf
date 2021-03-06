//
//  Weak.swift
//  Horo
//
//  Created by Andrey Chernyshev on 23.06.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

final class Weak<T> {
    weak private var value: AnyObject?
    
    var weak: T? {
        return value as? T
    }
    
    init<T: AnyObject>(_ value: T) {
        self.value = value
    }
}
