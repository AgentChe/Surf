//
//  ChatsManagerDelegate.swift
//  Surf
//
//  Created by Andrey Chernyshev on 21.07.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

protocol ChatsManagerDelegate: class {
    func didRemovedAllChats()
}

extension ChatsManagerDelegate {
    func didRemovedAllChats() {}
}
