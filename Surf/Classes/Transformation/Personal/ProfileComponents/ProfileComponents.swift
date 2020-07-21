//
//  ProfileComponents.swift
//  Surf
//
//  Created by Andrey Chernyshev on 21.07.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import Foundation

final class ProfileComponents {
    var id: Int
    var email: String
    var name: String
    var birthdate: Date
    var gender: Gender
    var lookingFor: [Gender]
    var emoji: String
    var minAge: Int?
    var maxAge: Int?
    var photos: [Photo]
    
    init(profile: Profile) {
        id = profile.id
        email = profile.email
        name = profile.name
        birthdate = profile.birthdate
        gender = profile.gender
        lookingFor = profile.lookingFor
        emoji = profile.emoji
        minAge = profile.minAge
        maxAge = profile.maxAge
        photos = profile.photos
    }
}
