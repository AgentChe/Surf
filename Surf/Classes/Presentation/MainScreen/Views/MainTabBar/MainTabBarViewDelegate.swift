//
//  MainTabBarViewDelegate.swift
//  Surf
//
//  Created by Andrey Chernyshev on 19.07.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import Foundation

@objc protocol MainTabBarViewDelegate: class {
    @objc optional func searchSelected()
    @objc optional func chatsSelected()
}
