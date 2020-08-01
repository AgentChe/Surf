//
//  ChatEmptyView.swift
//  Surf
//
//  Created by Andrey Chernyshev on 01.08.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import UIKit

final class ChatEmptyView: UIView {
    lazy var interlocutorImageView = makeInterlocutorPhotoView()
    lazy var titleLabel = makeTitleLabel()
    lazy var subTitleLabel = makeSubTitleLabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(interlocutor: ProposedInterlocutor) {
        if let path = interlocutor.photos.sorted(by: { $0.order < $1.order }).first?.url, let url = URL(string: path) {
            interlocutorImageView.kf.setImage(with: url)
        }
        
        titleLabel.text = String(format: "Chat.Empty.Title".localized, interlocutor.name)
    }
}

// MARK: Make constraints

private extension ChatEmptyView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            interlocutorImageView.widthAnchor.constraint(equalToConstant: 136.scale),
            interlocutorImageView.heightAnchor.constraint(equalToConstant: 160.scale),
            interlocutorImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            interlocutorImageView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -30.scale)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            titleLabel.topAnchor.constraint(equalTo: interlocutorImageView.bottomAnchor, constant: 24.scale)
        ])
        
        NSLayoutConstraint.activate([
            subTitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            subTitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            subTitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8.scale)
        ])
    }
}

// MARK: Lazy initialization

private extension ChatEmptyView {
    func makeInterlocutorPhotoView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.layer.cornerRadius = 25.scale
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeTitleLabel() -> UILabel {
        let view = UILabel()
        view.textColor = .black
        view.font = Font.OpenSans.semibold(size: 17.scale)
        view.textAlignment = .center
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeSubTitleLabel() -> UILabel {
        let view = UILabel()
        view.textColor = UIColor(red: 142 / 255, green: 142 / 255, blue: 147 / 255, alpha: 1)
        view.font = Font.OpenSans.regular(size: 15.scale)
        view.textAlignment = .center
        view.numberOfLines = 0
        view.text = "Chat.Empty.SubTitle".localized
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
