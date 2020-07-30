//
//  InterlocutorProfileViewControllerDelegate.swift
//  Surf
//
//  Created by Andrey Chernyshev on 30.07.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

protocol InterlocutorProfileViewControllerDelegate: class {
    func interlocutorProfileViewController(unmatched: Chat)
    func interlocutorProfileViewController(reported: Chat)
}

extension InterlocutorProfileViewControllerDelegate {
    func interlocutorProfileViewController(unmatched: Chat) {}
    func interlocutorProfileViewController(reported: Chat) {}
}
