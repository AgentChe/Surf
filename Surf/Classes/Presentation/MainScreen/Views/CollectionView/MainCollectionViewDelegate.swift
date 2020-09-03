//
//  MainCollectionViewDelegate.swift
//  Surf
//
//  Created by Andrey Chernyshev on 04.09.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

protocol MainCollectionViewDelegate: class {
    func mainCollectionViewDidDirectTapped(element: MainCollectionDirectElement)
}

extension MainCollectionViewDelegate {
    func mainCollectionViewDidDirectTapped(element: MainCollectionDirectElement) {}
}
