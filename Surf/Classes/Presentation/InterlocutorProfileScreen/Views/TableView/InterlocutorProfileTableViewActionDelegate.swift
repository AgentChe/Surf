//
//  InterlocutorProfileTableViewActionDelegate.swift
//  Surf
//
//  Created by Andrey Chernyshev on 30.07.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

protocol InterlocutorProfileTableActionDelegate: class {
    func interlocutorProfileTable(selected direct: InterlocutorProfileTableDirection)
}

extension InterlocutorProfileTableActionDelegate {
    func interlocutorProfileTable(selected direct: InterlocutorProfileTableDirection) {}
}
