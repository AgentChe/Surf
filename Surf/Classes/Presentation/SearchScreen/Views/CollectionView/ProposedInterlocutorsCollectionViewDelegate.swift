//
//  ProposedInterlocutorsCollectionViewDelegate.swift
//  Surf
//
//  Created by Andrey Chernyshev on 25.07.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

protocol ProposedInterlocutorsCollectionViewDelegate: class {
    func liked(proposedInterlocutor: ProposedInterlocutor)
    func disliked(proposedInterlocutor: ProposedInterlocutor)
    func report(on proposedInterlocutor: ProposedInterlocutor)
    func proposedInterlocutorsCollectionView(changed items: Int)
}

extension ProposedInterlocutorsCollectionViewDelegate {
    func liked(proposedInterlocutor: ProposedInterlocutor) {}
    func disliked(proposedInterlocutor: ProposedInterlocutor) {}
    func report(on proposedInterlocutor: ProposedInterlocutor) {}
    func proposedInterlocutorsCollectionView(changed items: Int) {}
}
