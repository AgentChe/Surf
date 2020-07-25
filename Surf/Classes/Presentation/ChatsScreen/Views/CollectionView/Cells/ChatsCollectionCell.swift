//
//  ChatsCollectionCell.swift
//  Surf
//
//  Created by Andrey Chernyshev on 23.07.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import UIKit

final class ChatsCollectionCell: UICollectionViewCell {
    lazy var photoView = makePhotoView()
    lazy var unreadMessagesCountLabel = makeUnreadMessagesCountLabel()
    lazy var nameLabel = makeNameLabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = .white
        
        selectedBackgroundView = UIView()
        selectedBackgroundView?.backgroundColor = .white
        
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        photoView.kf.cancelDownloadTask()
        photoView.image = nil 
    }
    
    func setup(chat: Chat) {
        if let interlocutorAvatarUrl = chat.interlocutorAvatarUrl {
            photoView.kf.setImage(with: interlocutorAvatarUrl)
        }
        
        let attrs = TextAttributes().lineHeight(20.scale)
        nameLabel.attributedText = chat.interlocutorName.attributed(with: attrs)
        
        unreadMessagesCountLabel.text = String(format: "%i", chat.unreadMessageCount)
        unreadMessagesCountLabel.isHidden = chat.unreadMessageCount == 0
    }
}

// MARK: Make constraints

private extension ChatsCollectionCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            photoView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6.scale),
            photoView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            photoView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -6.scale),
            photoView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -48.scale)
        ])
        
        NSLayoutConstraint.activate([
            unreadMessagesCountLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            unreadMessagesCountLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            unreadMessagesCountLabel.widthAnchor.constraint(equalToConstant: 26.scale),
            unreadMessagesCountLabel.heightAnchor.constraint(equalToConstant: 26.scale)
        ])
        
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 6.scale),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -6.scale),
            nameLabel.topAnchor.constraint(equalTo: photoView.bottomAnchor, constant: 8.scale)
        ])
    }
}

// MARK: Lazy initialization

private extension ChatsCollectionCell {
    func makePhotoView() -> UIImageView {
        let view = UIImageView()
        view.layer.cornerRadius = 25.scale
        view.layer.masksToBounds = true
        view.contentMode = .scaleAspectFill
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeUnreadMessagesCountLabel() -> UILabel {
        let view = UILabel()
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 13.scale
        view.font = Font.SFProText.regular(size: 14.scale)
        view.textColor = .white
        view.textAlignment = .center
        view.backgroundColor = UIColor(red: 76 / 255, green: 217 / 255, blue: 100 / 255, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeNameLabel() -> UILabel {
        let view = UILabel()
        view.textColor = UIColor(red: 50 / 255, green: 50 / 255, blue: 52 / 255, alpha: 1)
        view.font = Font.OpenSans.bold(size: 18.scale)
        view.numberOfLines = 2
        view.textAlignment = .left
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
}
