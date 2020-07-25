//
//  ChatsEmptyView.swift
//  FAWN
//
//  Created by Andrey Chernyshev on 07/06/2020.
//  Copyright © 2020 Алексей Петров. All rights reserved.
//

import UIKit

final class ChatsEmptyView: UIView {
    lazy var titleLabel = makeTitleLabel()
    lazy var newSearchButton = makeNewSearchButton()
    
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

private extension ChatsEmptyView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: newSearchButton.topAnchor, constant: -32.scale)
        ])
        
        NSLayoutConstraint.activate([
            newSearchButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 43.scale),
            newSearchButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -43.scale),
            newSearchButton.heightAnchor.constraint(equalToConstant: 56.scale),
            newSearchButton.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

// MARK: Lazy initialization

private extension ChatsEmptyView {
    func makeTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .font(Font.OpenSans.regular(size: 17.scale))
            .textAlignment(.center)
            .textColor(.black)
        
        let view = UILabel()
        view.numberOfLines = 0
        view.attributedText = "Chats.Empty".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    private func makeNewSearchButton() -> UIButton {
        let view = UIButton()
        view.backgroundColor = UIColor(red: 50 / 255, green: 50 / 255, blue: 52 / 255, alpha: 1)
        view.layer.cornerRadius = 28.scale
        view.titleLabel?.font = Font.OpenSans.semibold(size: 17)
        view.setTitle("Chats.NewSearch".localized, for: .normal)
        view.setTitleColor(.white, for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
