//
//  ProfileTableActionDelegate.swift
//  Surf
//
//  Created by Andrey Chernyshev on 20.07.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

protocol ProfileTableActionDelegate: class {
    func profileTable(selected direct: ProfileTableDirection)
    func profileTable(changed lookingFor: [Gender], minAge: Int, maxAge: Int)
    func profileTable(selected photo: Photo?)
}

extension ProfileTableActionDelegate {
    func profileTable(selected direct: ProfileTableDirection) {}
    func profileTable(changed lookingFor: [Gender], minAge: Int, maxAge: Int) {}
    func profileTable(selected photo: Photo?) {}
}
