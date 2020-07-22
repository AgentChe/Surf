//
//  EdiProfileTableItem.swift
//  Surf
//
//  Created by Andrey Chernyshev on 22.07.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

enum EditProfileTableItem {
    case photos(photos: [Photo])
    case delete(email: String)
    case name(name: EditProfileTableNameElement)
}
