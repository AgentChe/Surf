//
//  CompatibilityManagerDelegate.swift
//  Surf
//
//  Created by Andrey Chernyshev on 03.09.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

protocol CompatibilityManagerDelegate: class {
    func compatibilityManagerDidUpdate(compatibilities: Compatibilities)
}

extension CompatibilityManagerDelegate {
    func compatibilityManagerDidUpdate(compatibilities: Compatibilities) {}
}
