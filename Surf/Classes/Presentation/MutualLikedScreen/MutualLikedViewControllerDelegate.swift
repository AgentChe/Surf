//
//  MutualLikedViewControllerDelegate.swift
//  Surf
//
//  Created by Andrey Chernyshev on 27.07.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

protocol MutualLikedViewControllerDelegate: class {
    func sendMessageTapped()
    func keepSurfingTapped()
}

extension MutualLikedViewControllerDelegate {
    func sendMessageTapped() {}
    func keepSurfingTapped() {}
}
