//
//  MutualLikedView.swift
//  Surf
//
//  Created by Andrey Chernyshev on 27.07.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import UIKit

final class MutualLikedView: UIView {
    lazy var backgroundView = makeBackgroundView()
    lazy var iconView = makeIconView()
    lazy var titleLabel = makeTitleLabel()
    lazy var sendMessageButton = makeSendMessageButton()
    lazy var keepSurfingButton = makeKeepSurfingButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .clear
        
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Make constraints

private extension MutualLikedView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            backgroundView.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: trailingAnchor),
            backgroundView.topAnchor.constraint(equalTo: topAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            iconView.centerXAnchor.constraint(equalTo: centerXAnchor),
            iconView.widthAnchor.constraint(equalToConstant: 85.scale),
            iconView.heightAnchor.constraint(equalToConstant: 69.scale),
            iconView.topAnchor.constraint(equalTo: topAnchor, constant: ScreenSize.isIphoneXFamily ? 220.scale : 150.scale)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            titleLabel.topAnchor.constraint(equalTo: iconView.bottomAnchor, constant: 24.scale)
        ])
        
        NSLayoutConstraint.activate([
            sendMessageButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40.scale),
            sendMessageButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40.scale),
            sendMessageButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 60.scale),
            sendMessageButton.heightAnchor.constraint(equalToConstant: 56.scale)
        ])
        
        NSLayoutConstraint.activate([
            keepSurfingButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40.scale),
            keepSurfingButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40.scale),
            keepSurfingButton.topAnchor.constraint(equalTo: sendMessageButton.bottomAnchor, constant: 20.scale),
            keepSurfingButton.heightAnchor.constraint(equalToConstant: 56.scale)
        ])
    }
}

// MARK: Lazy initialization

private extension MutualLikedView {
    func makeBackgroundView() -> UIVisualEffectView {
        let view = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffect.Style.dark))
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeIconView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.clipsToBounds = true
        view.image = UIImage(named: "Search.Matched.Icon")
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .font(Font.OpenSans.bold(size: 34.scale))
            .textColor(.white)
            .textAlignment(.center)
            .lineHeight(36.scale)
        
        let view = UILabel()
        view.numberOfLines = 0
        view.attributedText = "Search.Matched.Title".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeSendMessageButton() -> UIButton {
        let view = UIButton()
        view.backgroundColor = UIColor(red: 50 / 255, green: 50 / 255, blue: 52 / 255, alpha: 1)
        view.layer.cornerRadius = 28.scale
        view.layer.masksToBounds = true
        view.setTitle("Search.Matched.SendMessage".localized, for: .normal)
        view.setTitleColor(UIColor.white, for: .normal)
        view.titleLabel?.font = Font.OpenSans.semibold(size: 17.scale)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeKeepSurfingButton() -> UIButton {
        let view = UIButton()
        view.backgroundColor = UIColor.white
        view.layer.cornerRadius = 23.scale
        view.layer.masksToBounds = true
        view.setTitle("Search.Matched.KeepSurfing".localized, for: .normal)
        view.setTitleColor(UIColor(red: 17 / 255, green: 17 / 255, blue: 17 / 255, alpha: 1), for: .normal)
        view.titleLabel?.font = Font.OpenSans.semibold(size: 17.scale)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
