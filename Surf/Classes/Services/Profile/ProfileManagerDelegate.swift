//
//  ProfileManagerDelegate.swift
//  Surf
//
//  Created by Andrey Chernyshev on 21.07.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

protocol ProfileManagerDelegate: class {
    func profileManager(retrieved profile: Profile)
    func profileMagager(updated profile: Profile)
}

extension ProfileManagerDelegate {
    func profileManager(retrieved profile: Profile) {}
    func profileMagager(updated profile: Profile) {}
}
