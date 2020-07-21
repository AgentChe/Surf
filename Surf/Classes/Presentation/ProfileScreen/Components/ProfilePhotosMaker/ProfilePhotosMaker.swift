//
//  ProfilePhotosMaker.swift
//  Surf
//
//  Created by Andrey Chernyshev on 22.07.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import UIKit

final class ProfilePhotosMaker {
    private var imagePicker: ImagePicker!
    
    private weak var presentationController: UIViewController?
    private weak var delegate: ProfilePhotosMakerDelegate?
    
    private var id: Int?
    
    init(presentationController: UIViewController, delegate: ProfilePhotosMakerDelegate) {
        imagePicker = ImagePicker(presentationController: presentationController, delegate: self)
        
        self.presentationController = presentationController
        self.delegate = delegate
    }
    
    func forMake() {
        id = nil
        
        if let view = presentationController?.view {
            imagePicker.present(from: view)
        }
    }
    
    func forReplace(id: Int) {
        self.id = id
        
        if let view = presentationController?.view {
            imagePicker.present(from: view)
        }
    }
}

// MARK: ImagePickerDelegate

extension ProfilePhotosMaker: ImagePickerDelegate {
    func didSelect(image: UIImage?) {
        guard let image = image else {
            return
        }
        
        if let id = self.id {
            delegate?.photosMakerForReplace(image: image, id: id)
        } else {
            delegate?.photosMakerForMake(image: image)
        }
    }
}
