//
//  ChatsMenuViewControllerDelegate.swift
//  Surf
//
//  Created by Andrey Chernyshev on 30.07.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

protocol ChatsMenuViewControllerDelegate: class {
    func chatsMenuViewController(unmatched: Chat)
    func chatsMenuViewController(deleted: Chat)
}

extension ChatsMenuViewControllerDelegate {
    func chatsMenuViewController(unmatched: Chat) {}
    func chatsMenuViewController(deleted: Chat) {}
}
