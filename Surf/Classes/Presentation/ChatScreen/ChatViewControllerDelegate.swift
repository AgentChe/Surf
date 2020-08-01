//
//  ChatViewControllerDelegate.swift
//  Surf
//
//  Created by Andrey Chernyshev on 31.07.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

protocol ChatViewControllerDelegate: class {
    func chatViewController(markedRead chat: Chat, message: Message)
    func chatViewController(unmatched: Chat)
    func chatViewController(reported: Chat)
}

extension ChatViewControllerDelegate {
    func chatViewController(markedRead chat: Chat, message: Message) {}
    func chatViewController(unmatched: Chat) {}
    func chatViewController(reported: Chat) {}
}
