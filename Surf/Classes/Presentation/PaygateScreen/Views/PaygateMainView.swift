//
//  PaygateMainView.swift
//  GaiaVPN
//
//  Created by Andrey Chernyshev on 29.06.2020.
//  Copyright © 2020 ENI LENGVICH. All rights reserved.
//

import UIKit

final class PaygateMainView: UIView {
    lazy var backgroundImageView = makeBackgroundImageView()
    lazy var restoreButton = makeRestoreButton()
    lazy var greetingLabel = makeGreetingLabel()
    lazy var featuresView = makeFeaturesView()
    lazy var leftOptionView = makeOptionView()
    lazy var rightOptionView = makeOptionView()
    lazy var continueButton = makeContinueButton()
    lazy var lockImageView = makeLockIconView()
    lazy var termsOfferLabel = makeTermsOfferLabel()
    lazy var purchasePreloaderView = makePreloaderView()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(paygate: PaygateMain) {
        greetingLabel.attributedText = paygate.greeting
        continueButton.setAttributedTitle(paygate.button, for: .normal)
        termsOfferLabel.attributedText = paygate.subButton
        restoreButton.setAttributedTitle(paygate.restore, for: .normal)
        
        let options = paygate.options?.prefix(2) ?? []
        
        if let leftOption = options.first {
            leftOptionView.isHidden = false
            leftOptionView.isSelected = true
            leftOptionView.setup(option: leftOption)
        } else {
            leftOptionView.isHidden = true
        }
        
        if options.count > 1, let rightOption = options.last {
            rightOptionView.isHidden = false
            rightOptionView.setup(option: rightOption)
        } else {
            rightOptionView.isHidden = true
        }
        
        featuresView.arrangedSubviews.forEach {
            featuresView.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }
        
        for (index, feature) in paygate.features.enumerated() {
            let cell = PaygateMainFeatureCell()
            
            cell.imageView.image = UIImage(named: "Paygate.Main.Icon\(index + 1)")
            cell.label.attributedText = feature
            featuresView.addArrangedSubview(cell)
        }
    }
}

// MARK: Make constraints

private extension PaygateMainView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            backgroundImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            backgroundImageView.topAnchor.constraint(equalTo: topAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            restoreButton.topAnchor.constraint(equalTo: topAnchor, constant: ScreenSize.isIphoneXFamily ? 58.scale : 45.scale),
            restoreButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32.scale),
            restoreButton.heightAnchor.constraint(equalToConstant: 30.scale)
        ])
        
        NSLayoutConstraint.activate([
            greetingLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40.scale),
            greetingLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40.scale),
            greetingLabel.bottomAnchor.constraint(equalTo: featuresView.topAnchor, constant: -8.scale)
        ])
        
        NSLayoutConstraint.activate([
            featuresView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40.scale),
            featuresView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40.scale),
            featuresView.bottomAnchor.constraint(equalTo: leftOptionView.topAnchor, constant: ScreenSize.isIphoneXFamily ? -32.scale : -16.scale)
        ])
        
        NSLayoutConstraint.activate([
            leftOptionView.widthAnchor.constraint(equalTo: rightOptionView.widthAnchor),
            leftOptionView.heightAnchor.constraint(equalToConstant: 185.scale),
            leftOptionView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20.scale),
            leftOptionView.trailingAnchor.constraint(equalTo: rightOptionView.leadingAnchor, constant: -13.scale),
            leftOptionView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: ScreenSize.isIphoneXFamily ? -233.scale : -149.scale)
        ])
        
        NSLayoutConstraint.activate([
            rightOptionView.heightAnchor.constraint(equalToConstant: 185.scale),
            rightOptionView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20.scale),
            rightOptionView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: ScreenSize.isIphoneXFamily ? -233.scale : -149.scale)
        ])
        
        NSLayoutConstraint.activate([
            continueButton.heightAnchor.constraint(equalToConstant: 56.scale),
            continueButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20.scale),
            continueButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20.scale),
            continueButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: ScreenSize.isIphoneXFamily ? -130.scale : -63.scale)
        ])
        
        NSLayoutConstraint.activate([
            lockImageView.widthAnchor.constraint(equalToConstant: 12.scale),
            lockImageView.heightAnchor.constraint(equalToConstant: 16.scale),
            lockImageView.trailingAnchor.constraint(equalTo: termsOfferLabel.leadingAnchor, constant: -10.scale),
            lockImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: ScreenSize.isIphoneXFamily ? -93.scale : -26.scale)
        ])
        
        NSLayoutConstraint.activate([
            termsOfferLabel.centerYAnchor.constraint(equalTo: lockImageView.centerYAnchor),
            termsOfferLabel.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 10.scale)
        ])
        
        NSLayoutConstraint.activate([
            purchasePreloaderView.centerYAnchor.constraint(equalTo: continueButton.centerYAnchor),
            purchasePreloaderView.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
}

// MARK: Lazy initialization

private extension PaygateMainView {
    func makeBackgroundImageView() -> UIImageView {
        let view = UIImageView()
        view.clipsToBounds = true
        view.contentMode = .scaleAspectFill
        view.image = UIImage(named: ScreenSize.isIphoneXFamily ? "Paygate.Main.Background_X" : "Paygate.Main.Background")
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeRestoreButton() -> UIButton {
        let view = UIButton()
        view.alpha = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeGreetingLabel() -> UILabel {
        let view = UILabel()
        view.alpha = 0
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeFeaturesView() -> UIStackView {
        let view = UIStackView()
        view.alpha = 0
        view.alignment = .fill
        view.distribution = .fill
        view.axis = .vertical
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeOptionView() -> PaygateOptionView {
        let view = PaygateOptionView()
        view.alpha = 0
        view.layer.cornerRadius = 8.scale
        view.layer.borderWidth = 2.scale
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeContinueButton() -> UIButton {
        let view = UIButton()
        view.isHidden = true
        view.backgroundColor = UIColor.white
        view.layer.cornerRadius = 28.scale
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeLockIconView() -> UIImageView {
        let view = UIImageView()
        view.alpha = 0
        view.clipsToBounds = true
        view.contentMode = .scaleAspectFit
        view.image = UIImage(named: "Paygate.Main.Secured")
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeTermsOfferLabel() -> UILabel {
        let view = UILabel()
        view.alpha = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makePreloaderView() -> UIActivityIndicatorView {
        let view = UIActivityIndicatorView()
        view.hidesWhenStopped = true
        view.style = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
