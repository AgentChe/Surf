//
//  ProfileCollectionItem.swift
//  Surf
//
//  Created by Andrey Chernyshev on 20.07.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import UIKit

enum ProfileTableItem {
    case personal(name: String, birthdate: Date, emoji: String)
    case direction(direction: ProfileTableDirection, title: String, withIcon: Bool, maskedCorners: CACornerMask)
    case lookingFor(genders: [Gender], minAge: Int, maxAge: Int)
    case photos(photos: [Photo])
}
