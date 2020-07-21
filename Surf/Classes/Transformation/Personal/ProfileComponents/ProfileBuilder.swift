//
//  ProfileComponentsBuilder.swift
//  Surf
//
//  Created by Andrey Chernyshev on 21.07.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import Foundation

final class ProfileBuilder {
    private var components: ProfileComponents!
    
    func initial(profile: Profile) -> ProfileBuilder {
        components = ProfileComponents(profile: profile)
        return self
    }
    
    func email(_ email: String) -> ProfileBuilder {
        components.email = email
        return self
    }
    
    func name(_ name: String) -> ProfileBuilder {
        components.name = name
        return self
    }
    
    func birthdate(_ birthdate: Date) -> ProfileBuilder {
        components.birthdate = birthdate
        return self
    }
    
    func gender(_ gender: Gender) -> ProfileBuilder {
        components.gender = gender
        return self
    }
    
    func lookingFor(_ lookingFor: [Gender]) -> ProfileBuilder {
        components.lookingFor = lookingFor
        return self
    }
    
    func emoji(_ emoji: String) -> ProfileBuilder {
        components.emoji = emoji
        return self
    }
    
    func minAge(_ minAge: Int?) -> ProfileBuilder {
        components.minAge = minAge
        return self
    }
    
    func maxAge(_ maxAge: Int?) -> ProfileBuilder {
        components.maxAge = maxAge
        return self
    }
    
    func photos(_ photos: [Photo]) -> ProfileBuilder {
        components.photos = photos
        return self
    }
    
    func build() -> Profile {
        Profile(id: components.id,
                email: components.email,
                name: components.name,
                birthdate: components.birthdate,
                gender: components.gender,
                lookingFor: components.lookingFor,
                emoji: components.emoji,
                minAge: components.minAge,
                maxAge: components.maxAge,
                photos: components.photos)
    }
}
