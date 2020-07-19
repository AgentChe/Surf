//
//  MainPageViewControllerDelegate.swift
//  Surf
//
//  Created by Andrey Chernyshev on 19.07.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

protocol MainPageViewControllerDelegate: class {
    func changed(page index: Int)
}

extension MainPageViewControllerDelegate {
    func changed(page index: Int) {}
}
