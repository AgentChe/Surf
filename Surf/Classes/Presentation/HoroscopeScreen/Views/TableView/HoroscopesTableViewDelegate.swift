//
//  HoroscopesTableViewDelegate.swift
//  Surf
//
//  Created by Andrey Chernyshev on 04.09.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

protocol HoroscopesTableViewDelegate: class {
    func horoscopeTableDidTapped(tag: HoroscopeOnTableCell.Tag)
    func horoscopeTableDidReadMoreTapped(articleId: String)
}

extension HoroscopesTableViewDelegate {
    func horoscopeTableDidTapped(tag: HoroscopeOnTableCell.Tag) {}
    func horoscopeTableDidReadMoreTapped(articleId: String) {}
}
