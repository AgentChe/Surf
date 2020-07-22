//
//  EditProfileConfirmDeletingAlert.swift
//  Surf
//
//  Created by Andrey Chernyshev on 22.07.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import UIKit

final class EditProfileConfirmDeletingAlert {
    func alert(handler: @escaping ((Bool) -> Void)) -> UIAlertController {
        let alert = UIAlertController(title: nil, message: "EditProfile.ConfirmDeleteAccount.ConfirmDeleting".localized, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "EditProfile.ConfirmDeleteAccount.Yes".localized, style: .default) { _ in
            handler(true)
        })
        
        alert.addAction(UIAlertAction(title: "EditProfile.ConfirmDeleteAccount.No".localized, style: .default) { _ in
            handler(false)
        })
        
        return alert
    }
}
