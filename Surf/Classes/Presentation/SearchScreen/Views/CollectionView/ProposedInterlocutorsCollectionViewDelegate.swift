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
    func setupSettings()
    func proposedInterlocutorsCollectionView(changed items: Int)
    func compatibility(with proposedInterlocutor: ProposedInterlocutor)
}

extension ProposedInterlocutorsCollectionViewDelegate {
    func liked(proposedInterlocutor: ProposedInterlocutor) {}
    func disliked(proposedInterlocutor: ProposedInterlocutor) {}
    func report(on proposedInterlocutor: ProposedInterlocutor) {}
    func setupSettings() {}
    func proposedInterlocutorsCollectionView(changed items: Int) {}
    func compatibility(with proposedInterlocutor: ProposedInterlocutor) {}
}
