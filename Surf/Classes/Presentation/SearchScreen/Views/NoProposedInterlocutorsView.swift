//
//  NoProposedInterlocutorsView.swift
//  FAWN
//
//  Created by Andrey Chernyshev on 22/04/2020.
//  Copyright © 2020 Алексей Петров. All rights reserved.
//

import UIKit

final class NoProposedInterlocutorsView: UIView {
    lazy var iconView = makeIconView()
    lazy var titleLabel = makeTitleLabel()
    lazy var settingsButton = makeSettingsButton()
    lazy var tryMoreTimeButton = makeTryMoreTimeButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Make constraints

private extension NoProposedInterlocutorsView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            iconView.centerXAnchor.constraint(equalTo: centerXAnchor),
            iconView.widthAnchor.constraint(equalToConstant: 95.scale),
            iconView.heightAnchor.constraint(equalToConstant: 80.scale),
            iconView.topAnchor.constraint(equalTo: topAnchor, constant: ScreenSize.isIphoneXFamily ? 163.scale : 110.scale)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            titleLabel.topAnchor.constraint(equalTo: iconView.bottomAnchor, constant: 24.scale)
        ])
        
        NSLayoutConstraint.activate([
            settingsButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40.scale),
            settingsButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40.scale),
            settingsButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 70.scale),
            settingsButton.heightAnchor.constraint(equalToConstant: 56.scale)
        ])
        
        NSLayoutConstraint.activate([
            tryMoreTimeButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40.scale),
            tryMoreTimeButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40.scale),
            tryMoreTimeButton.topAnchor.constraint(equalTo: settingsButton.bottomAnchor, constant: 20.scale),
            tryMoreTimeButton.heightAnchor.constraint(equalToConstant: 56.scale)
        ])
    }
}

// MARK: Lazy initialization

private extension NoProposedInterlocutorsView {
    func makeIconView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.clipsToBounds = true
        view.image = UIImage(named: "Search.NoProposedInterlocutors.Icon")
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .font(Font.OpenSans.bold(size: 34.scale))
            .textColor(.black)
            .textAlignment(.center)
            .lineHeight(36.scale)
        
        let view = UILabel()
        view.numberOfLines = 0
        view.attributedText = "Search.NoProposedInterlocutors.Title".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeSettingsButton() -> UIButton {
        let view = UIButton()
        view.backgroundColor = UIColor(red: 50 / 255, green: 50 / 255, blue: 52 / 255, alpha: 1)
        view.layer.cornerRadius = 28.scale
        view.layer.masksToBounds = true
        view.setTitle("Search.NoProposedInterlocutors.Setting".localized, for: .normal)
        view.setTitleColor(UIColor.white, for: .normal)
        view.titleLabel?.font = Font.OpenSans.semibold(size: 17.scale)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeTryMoreTimeButton() -> UIButton {
        let view = UIButton()
        view.backgroundColor = UIColor.white
        view.layer.cornerRadius = 23.scale
        view.setTitle("Search.NoProposedInterlocutors.TryMoreTime".localized, for: .normal)
        view.setTitleColor(UIColor(red: 17 / 255, green: 17 / 255, blue: 17 / 255, alpha: 1), for: .normal)
        view.titleLabel?.font = Font.OpenSans.semibold(size: 17.scale)
        view.layer.shadowRadius = 9.0.scale
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 3.scale, height: 3.scale)
        view.layer.shadowOpacity = 0.2
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
