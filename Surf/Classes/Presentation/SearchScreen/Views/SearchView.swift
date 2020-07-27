//
//  SearchView.swift
//  Surf
//
//  Created by Andrey Chernyshev on 26.07.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import UIKit

final class SearchView: UIView {
    lazy var collectionView = makeCollectionView()
    lazy var noProposedInterlocutorsView = makeNoProposedInterlocutorsView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Make constraints

private extension SearchView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            noProposedInterlocutorsView.leadingAnchor.constraint(equalTo: leadingAnchor),
            noProposedInterlocutorsView.trailingAnchor.constraint(equalTo: trailingAnchor),
            noProposedInterlocutorsView.topAnchor.constraint(equalTo: topAnchor),
            noProposedInterlocutorsView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

// MARK: Lazy initialization

private extension SearchView {
    func makeCollectionView() -> ProposedInterlocutorsCollectionView {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        let view = ProposedInterlocutorsCollectionView(frame: .zero, collectionViewLayout: layout)
        view.backgroundColor = UIColor(red: 240 / 255, green: 240 / 255, blue: 242 / 255, alpha: 1)
        view.isHidden = true
        view.showsVerticalScrollIndicator = false
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeNoProposedInterlocutorsView() -> NoProposedInterlocutorsView {
        let view = NoProposedInterlocutorsView()
        view.isHidden = true
        view.backgroundColor = UIColor(red: 253 / 255, green: 253 / 255, blue: 253 / 255, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
