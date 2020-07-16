//
//  OnboardingNotificationsView.swift
//  FAWN
//
//  Created by Andrey Chernyshev on 22/04/2020.
//  Copyright © 2020 Алексей Петров. All rights reserved.
//

import UIKit

final class OnboardingNotificationsView: UIView {
    var onNext: ((String?) -> Void)?
    
    private lazy var titleLabel = makeTitleLabel()
    private lazy var footerLabel = makeFooterLabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        PushNotificationsManager.shared.add(observer: self)
        PushNotificationsManager.shared.requestAuthorization()
    }
}

// MARK: PushNotificationsManagerDelegate

extension OnboardingNotificationsView: PushNotificationsManagerDelegate {
    func retrieved(token: String?) {
        PushNotificationsManager.shared.remove(observer: self)
        
        onNext?(token)
    }
}

// MARK: Make constraints

private extension OnboardingNotificationsView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40.scale),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40.scale),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: ScreenSize.isIphoneXFamily ? 190.scale : 100.scale)
        ])
        
        NSLayoutConstraint.activate([
            footerLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40.scale),
            footerLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40.scale),
            footerLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: ScreenSize.isIphoneXFamily ? -148.scale : -80.scale)
        ])
    }
}

// MARK: Lazy initialization

private extension OnboardingNotificationsView {
    func makeTitleLabel() -> UILabel {
        let view = UILabel()
        view.textColor = .black
        view.font = Font.OpenSans.bold(size: 28.scale)
        view.textAlignment = .center
        view.numberOfLines = 0
        view.text = "Onboarding.FinalStepBeforeYouBegin".localized
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeFooterLabel() -> UILabel {
        let view = UILabel()
        view.textColor = .black
        view.font = Font.OpenSans.regular(size: 20.scale)
        view.textAlignment = .center
        view.numberOfLines = 0
        view.text = "Onboarding.PushNotificationInfo".localized
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
