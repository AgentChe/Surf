//
//  SearchSettingsView.swift
//  Surf
//
//  Created by Andrey Chernyshev on 27.07.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import UIKit
import RangeSeekSlider

final class SearchSettingsView: UIView {
    lazy var backgroundView = makeBackgroundView()
    lazy var containerView = makeContainerView()
    lazy var titleLabel = makeTitleLabel()
    lazy var lookingForChoiceView = makeLookingForChoiceView()
    lazy var separatorView = makeSeparatorView()
    lazy var ageRangeTitleLabel = makeAgeRangeTitleLabel()
    lazy var ageRangeLabel = makeAgeRangeLabel()
    lazy var ageRangeSlider = makeAgeRangeSlider()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Make constraints

private extension SearchSettingsView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            backgroundView.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: trailingAnchor),
            backgroundView.topAnchor.constraint(equalTo: topAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            containerView.topAnchor.constraint(equalTo: topAnchor, constant: ScreenSize.isIphoneXFamily ? 404.scale : 300.scale),
            containerView.heightAnchor.constraint(equalToConstant: 192.scale)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16.scale),
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16.scale)
        ])
        
        NSLayoutConstraint.activate([
            lookingForChoiceView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16.scale),
            lookingForChoiceView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16.scale),
            lookingForChoiceView.heightAnchor.constraint(equalToConstant: 32.scale),
            lookingForChoiceView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 48.scale)
        ])
        
        NSLayoutConstraint.activate([
            separatorView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            separatorView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            separatorView.heightAnchor.constraint(equalToConstant: 1.scale),
            separatorView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            ageRangeTitleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16.scale),
            ageRangeTitleLabel.topAnchor.constraint(equalTo: separatorView.bottomAnchor, constant: 16.scale)
        ])
        
        NSLayoutConstraint.activate([
            ageRangeLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16.scale),
            ageRangeLabel.topAnchor.constraint(equalTo: separatorView.bottomAnchor, constant: 16.scale)
        ])
        
        NSLayoutConstraint.activate([
            ageRangeSlider.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16.scale),
            ageRangeSlider.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16.scale),
            ageRangeSlider.heightAnchor.constraint(equalToConstant: 28.scale),
            ageRangeSlider.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -16.scale)
        ])
    }
}

// MARK: Lazy initialization

private extension SearchSettingsView {
    func makeBackgroundView() -> UIVisualEffectView {
        let view = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffect.Style.dark))
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeContainerView() -> InterceptingEventsView {
        let view = InterceptingEventsView()
        view.backgroundColor = UIColor(red: 247 / 255, green: 247 / 255, blue: 252 / 255, alpha: 1)
        view.layer.cornerRadius = 9.scale
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeTitleLabel() -> UILabel {
        let view = UILabel()
        view.textColor = UIColor(red: 35 / 255, green: 35 / 255, blue: 38 / 255, alpha: 1)
        view.font = Font.SFProText.semibold(size: 17.scale)
        view.text = "SearchSettings.Title".localized
        view.textAlignment = .left
        view.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(view)
        return view
    }
    
    func makeLookingForChoiceView() -> ProfileLookingForChoiceView {
        let view = ProfileLookingForChoiceView()
        view.backgroundColor = UIColor(red: 239 / 255, green: 239 / 255, blue: 240 / 255, alpha: 1)
        view.layer.cornerRadius = 9.scale
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(view)
        return view
    }
    
    func makeSeparatorView() -> UIView {
        let view = UIView()
        view.backgroundColor = UIColor(red: 230 / 255, green: 228 / 255, blue: 234 / 255, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(view)
        return view
    }
    
    func makeAgeRangeTitleLabel() -> UILabel {
        let view = UILabel()
        view.textColor = UIColor(red: 35 / 255, green: 35 / 255, blue: 38 / 255, alpha: 1)
        view.font = Font.SFProText.semibold(size: 17.scale)
        view.text = "SearchSettings.AgeRange".localized
        view.textAlignment = .left
        view.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(view)
        return view
    }
    
    func makeAgeRangeLabel() -> UILabel {
        let view = UILabel()
        view.textColor = UIColor(red: 60 / 255, green: 60 / 255, blue: 67 / 255, alpha: 0.6)
        view.font = Font.SFProText.regular(size: 17.scale)
        view.textAlignment = .right
        view.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(view)
        return view
    }
    
    func makeAgeRangeSlider() -> RangeSeekSlider {
        let view = RangeSeekSlider()
        view.minValue = 16
        view.maxValue = 80
        view.handleDiameter = 24.scale
        view.selectedHandleDiameterMultiplier = 1
        view.lineHeight = 2.scale
        view.tintColor = UIColor(red: 230 / 255, green: 228 / 255, blue: 234 / 255, alpha: 1)
        view.colorBetweenHandles = UIColor(red: 0, green: 122 / 255, blue: 1, alpha: 1)
        view.hideLabels = true
        view.handleImage = UIImage(named: "Profile.ThumbSlider")
        view.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(view)
        return view
    }
}
