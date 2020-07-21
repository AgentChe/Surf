//
//  ProfilePhotosActionSheet.swift
//  Surf
//
//  Created by Andrey Chernyshev on 21.07.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import UIKit

final class ProfilePhotosActionSheet {
    enum Step {
        case make
        case replace(id: Int)
        case setDefault(id: Int)
        case delete(id: Int)
    }
    
    func actionSheet(photo: Photo?, handler: @escaping ((Step) -> Void)) -> UIAlertController {
        let actionSheet = UIAlertController(title:nil, message: nil, preferredStyle: .actionSheet)
        
        if let photo = photo {
            actionSheet.addAction(UIAlertAction(title: "Profile.ProfilePhotosActionSheet.Change".localized, style: .default) { _ in
                handler(Step.replace(id: photo.id))
            })
            
            if photo.order != 1 {
                actionSheet.addAction(UIAlertAction(title: "Profile.ProfilePhotosActionSheet.MakeFirst".localized, style: .default) { _ in
                    handler(Step.setDefault(id: photo.id))
                })
            }
            
            actionSheet.addAction(UIAlertAction(title: "Profile.ProfilePhotosActionSheet.DeletePhoto".localized, style: .default) { _ in
                handler(Step.delete(id: photo.id))
            })
        } else {
            actionSheet.addAction(UIAlertAction(title: "Profile.ProfilePhotosActionSheet.Change".localized, style: .default) { _ in
                handler(Step.make)
            })
        }
        
        actionSheet.addAction(UIAlertAction(title: "Profile.ProfilePhotosActionSheet.Done".localized, style: .cancel))
        
        return actionSheet
    }
}
