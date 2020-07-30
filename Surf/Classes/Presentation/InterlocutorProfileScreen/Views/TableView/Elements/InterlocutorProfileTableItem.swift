//
//  InterlocutorProfileTableItem.swift
//  Surf
//
//  Created by Andrey Chernyshev on 30.07.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import UIKit

enum InterlocutorProfileTableItem {
    case personal(name: String, birthdate: Date, emoji: String)
    case photos(photos: [Photo])
    case direction(direction: InterlocutorProfileTableDirection, title: String, withIcon: Bool, maskedCorners: CACornerMask)
}
