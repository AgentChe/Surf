//
//  ProfilePhotosMakerDelegate.swift
//  Surf
//
//  Created by Andrey Chernyshev on 22.07.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import UIKit

protocol ProfilePhotosMakerDelegate: class {
    func photosMakerForMake(image: UIImage)
    func photosMakerForReplace(image: UIImage, id: Int)
}
