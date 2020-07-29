//
//  ChatsMenuView.swift
//  Surf
//
//  Created by Andrey Chernyshev on 29.07.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import UIKit
import Kingfisher

final class ChatsMenuView: UIView {
    lazy var backgroundView = makeBackgroundView()
    lazy var imageView = makeImageView()
    lazy var cellsContainerView = makeCellsContainerView()
    lazy var unmatchCell = makeCell()
    lazy var deleteCell = makeCell()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(chat: Chat) {
        imageView.kf.cancelDownloadTask()
        imageView.image = nil
        
        if let url = chat.interlocutorAvatarUrl {
            imageView.kf.setImage(with: url)
        }
    }
}

// MARK: Private

private extension ChatsMenuView {
    func configure() {
        unmatchCell.label.text = "Chats.Menu.Unmatch".localized
        unmatchCell.label.textColor = UIColor.black
        unmatchCell.imageView.image = UIImage(named: "Chats.Menu.Icon1")
        
        deleteCell.label.text = "Chats.Menu.Delete".localized
        deleteCell.label.textColor = UIColor(red: 1, green: 59 / 255, blue: 48 / 255, alpha: 1)
        deleteCell.imageView.image = UIImage(named: "Chats.Menu.Icon2")
    }
}

// MARK: Make constraints

private extension ChatsMenuView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            backgroundView.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: trailingAnchor),
            backgroundView.topAnchor.constraint(equalTo: topAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 136.scale),
            imageView.heightAnchor.constraint(equalToConstant: 230.scale),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: ScreenSize.isIphoneXFamily ? -62.scale : -40.scale),
            imageView.topAnchor.constraint(equalTo: topAnchor, constant: ScreenSize.isIphoneXFamily ? 207.scale : 170.scale)
        ])
        
        NSLayoutConstraint.activate([
            cellsContainerView.widthAnchor.constraint(equalToConstant: 250.scale),
            cellsContainerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: ScreenSize.isIphoneXFamily ? -62.scale : -40.scale),
            cellsContainerView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 18.scale)
        ])
        
        NSLayoutConstraint.activate([
            unmatchCell.leadingAnchor.constraint(equalTo: cellsContainerView.leadingAnchor),
            unmatchCell.trailingAnchor.constraint(equalTo: cellsContainerView.trailingAnchor),
            unmatchCell.topAnchor.constraint(equalTo: cellsContainerView.topAnchor)
        ])
        
        NSLayoutConstraint.activate([
            deleteCell.leadingAnchor.constraint(equalTo: cellsContainerView.leadingAnchor),
            deleteCell.trailingAnchor.constraint(equalTo: cellsContainerView.trailingAnchor),
            deleteCell.topAnchor.constraint(equalTo: unmatchCell.bottomAnchor),
            deleteCell.bottomAnchor.constraint(equalTo: cellsContainerView.bottomAnchor)
        ])
    }
}

// MARK: Lazy initialization

private extension ChatsMenuView {
    func makeBackgroundView() -> UIVisualEffectView {
        let view = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffect.Style.dark))
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeImageView() -> UIImageView {
        let view = UIImageView()
        view.clipsToBounds = true
        view.contentMode = .scaleAspectFill
        view.layer.cornerRadius = 26.scale
        view.layer.masksToBounds = true 
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeCellsContainerView() -> InterceptingEventsView {
        let view = InterceptingEventsView()
        view.layer.cornerRadius = 20.scale
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeCell() -> ChatsMenuCell {
        let view = ChatsMenuCell()
        view.backgroundColor = UIColor(red: 247 / 255, green: 247 / 255, blue: 252 / 255, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        cellsContainerView.addSubview(view)
        return view
    }
}
