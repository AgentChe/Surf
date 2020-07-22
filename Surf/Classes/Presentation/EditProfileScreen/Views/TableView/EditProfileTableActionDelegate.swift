//
//  EditProfileTableActionDelegate.swift
//  Surf
//
//  Created by Andrey Chernyshev on 22.07.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

protocol EditProfileTableActionDelegate: class {
    func editProfileTable(selected photo: Photo?)
    func editProfileTableDeleteTapped()
}

extension EditProfileTableActionDelegate {
    func editProfileTable(selected photo: Photo?) {}
    func editProfileTableDeleteTapped() {}
}
