//
//  RegistrationView.swift
//  Surf
//
//  Created by Andrey Chernyshev on 14.07.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import UIKit
import AuthenticationServices

final class WelcomeView: UIView {
    lazy var titleLabel = makeTitleLabel()
    lazy var subTitleLabel = makeSubTitleLabel()
    @available(iOS 13.0, *) lazy var appleSingInButton = makeAppleSignInButton()
    lazy var facebookButton = makeFacebookButton()
    lazy var aboutFacebookSignInInfoLabel = makeAboutFacebookSignInInfoLabel()
    lazy var emailButton = makeEmailButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor(red: 115 / 255, green: 146 / 255, blue: 255 / 255, alpha: 1)
        
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Make constraints

private extension WelcomeView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40.scale),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: ScreenSize.isIphoneXFamily ? 110.scale : 70.scale),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40.scale)
        ])
        
        NSLayoutConstraint.activate([
            subTitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40.scale),
            subTitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40.scale),
            subTitleLabel.topAnchor.constraint(equalTo: topAnchor, constant: ScreenSize.isIphoneXFamily ? 276.scale : 210.scale)
        ])
        
        if #available(iOS 13.0, *) {
            NSLayoutConstraint.activate([
                appleSingInButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40.scale),
                appleSingInButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40.scale),
                appleSingInButton.topAnchor.constraint(equalTo: subTitleLabel.bottomAnchor, constant: 16.scale),
                appleSingInButton.heightAnchor.constraint(equalToConstant: 48.scale)
            ])
        }
        
        NSLayoutConstraint.activate([
            facebookButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40.scale),
            facebookButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40.scale),
            facebookButton.topAnchor.constraint(equalTo: subTitleLabel.bottomAnchor, constant: 80.scale),
            facebookButton.heightAnchor.constraint(equalToConstant: 48.scale)
        ])
        
        NSLayoutConstraint.activate([
            aboutFacebookSignInInfoLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40.scale),
            aboutFacebookSignInInfoLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40.scale),
            aboutFacebookSignInInfoLabel.topAnchor.constraint(equalTo: facebookButton.bottomAnchor, constant: 32.scale)
        ])
        
        NSLayoutConstraint.activate([
            emailButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40.scale),
            emailButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40.scale),
            emailButton.heightAnchor.constraint(equalToConstant: 56.scale),
            emailButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: ScreenSize.isIphoneXFamily ? -50.scale : -20.scale)
        ])
    }
}

// MARK: Lazy initialization

private extension WelcomeView {
    func makeTitleLabel() -> UILabel {
        let view = UILabel()
        view.text = "Welcome.Title".localized.uppercased()
        view.font = Font.OpenSans.bold(size: 80.scale)
        view.textColor = UIColor.white
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeSubTitleLabel() -> UILabel {
        let attrs = "Welcome.SubTitle".localized
            .attributed(with: TextAttributes()
                .textColor(.white)
                .font(Font.OpenSans.bold(size: 34.scale))
                .lineHeight(41.scale))
        
        let view = UILabel()
        view.attributedText = attrs
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    @available(iOS 13.0, *)
    func makeAppleSignInButton() -> ASAuthorizationAppleIDButton {
        let view = ASAuthorizationAppleIDButton(type: .default, style: .white)
        view.cornerRadius = 24.scale
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeFacebookButton() -> UIButton {
        let view = UIButton()
        view.setTitle("Welcome.ContinueWithFacebook".localized, for: .normal)
        view.backgroundColor = UIColor(red: 86 / 255, green: 86 / 255, blue: 214 / 255, alpha: 1)
        view.titleLabel?.font = Font.OpenSans.semibold(size: 17.scale)
        view.setTitleColor(.white, for: .normal)
        view.layer.cornerRadius = 24.scale
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeAboutFacebookSignInInfoLabel() -> UILabel {
        let attrs = "Welcome.AboutFacebookSignInInfo".localized
            .attributed(with: TextAttributes()
                .textColor(UIColor(red: 235 / 255, green: 235 / 255, blue: 245 / 255, alpha: 1))
                .font(Font.SFProText.regular(size: 17.scale))
                .lineHeight(22.scale)
                .letterSpacing(-0.408.scale))
        
        let view = UILabel()
        view.attributedText = attrs
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeEmailButton() -> UIButton {
        let view = UIButton()
        view.setTitle("Welcome.ContinueWithEmail".localized, for: .normal)
        view.backgroundColor = .clear
        view.setTitleColor(UIColor(red: 235 / 255, green: 235 / 255, blue: 245 / 255, alpha: 1), for: .normal)
        view.titleLabel?.font = Font.SFProText.regular(size: 17.scale)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
