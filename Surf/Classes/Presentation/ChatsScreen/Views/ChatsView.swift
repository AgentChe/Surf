//
//  ChatsView.swift
//  FAWN
//
//  Created by Andrey Chernyshev on 06/06/2020.
//  Copyright © 2020 Алексей Петров. All rights reserved.
//

import UIKit

final class ChatsView: UIView {
    lazy var titleLabel = makeTitleLabel()
    lazy var photoView = makePhotoView()
    lazy var collectionView = makeCollectionView()
    lazy var emptyView = makeEmptyView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Make constraints

private extension ChatsView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40.scale),
            titleLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor)
        ])
        
        NSLayoutConstraint.activate([
            photoView.widthAnchor.constraint(equalToConstant: 40.scale),
            photoView.heightAnchor.constraint(equalToConstant: 40.scale),
            photoView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40.scale),
            photoView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor)
        ])
        
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
            collectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20.scale)
        ])
        
        NSLayoutConstraint.activate([
            emptyView.leadingAnchor.constraint(equalTo: leadingAnchor),
            emptyView.trailingAnchor.constraint(equalTo: trailingAnchor),
            emptyView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}

// MARK: Lazy initialization

private extension ChatsView {
    func makeTitleLabel() -> UILabel {
        let view = UILabel()
        view.textColor = UIColor(red: 34 / 255, green: 34 / 255, blue: 34 / 255, alpha: 1)
        view.font = Font.OpenSans.bold(size: 28.scale)
        view.textAlignment = .left
        view.text = "Chats.Title".localized
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makePhotoView() -> UIImageView {
        let view = UIImageView()
        view.layer.cornerRadius = 20.scale
        view.layer.masksToBounds = true
        view.clipsToBounds = true 
        view.contentMode = .scaleAspectFill
        view.isUserInteractionEnabled = true 
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeCollectionView() -> ChatsCollectionView {
        let view = ChatsCollectionView(frame: .zero, collectionViewLayout: ChatsCollectionViewLayout())
        view.backgroundColor = .white
        view.contentInset = UIEdgeInsets(top: 0, left: 40.scale, bottom: 20.scale, right: 40.scale)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeEmptyView() -> ChatsEmptyView {
        let view = ChatsEmptyView()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
