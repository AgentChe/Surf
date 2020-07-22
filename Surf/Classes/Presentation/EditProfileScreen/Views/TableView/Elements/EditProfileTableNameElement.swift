//
//  EditProfileTableNameElement.swift
//  Surf
//
//  Created by Andrey Chernyshev on 22.07.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

final class EditProfileTableNameElement {
    var name: String?
    var getText: (() -> String)?
    
    func setupIfNeeded(name: String) {
        if self.name == nil {
            self.name = name 
        }
    }
}
