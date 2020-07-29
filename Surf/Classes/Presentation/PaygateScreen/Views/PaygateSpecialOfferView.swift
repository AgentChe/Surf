//
//  PaygateSpecialOfferView.swift
//  GaiaVPN
//
//  Created by Andrey Chernyshev on 29.06.2020.
//  Copyright © 2020 ENI LENGVICH. All rights reserved.
//

import UIKit

final class PaygateSpecialOfferView: UIView {
    lazy var backgroundImageView = makeBackgroundImageView()
    lazy var restoreButton = makeRestoreButton()
    lazy var titleLabel = makeLabel()
    lazy var subTitleLabel = makeLabel()
    lazy var textLabel = makeLabel()
    lazy var timeLabel = makeLabel()
    lazy var priceLabel = makeLabel()
    lazy var continueButton = makeContinueButton()
    lazy var lockImageView = makeLockIconView()
    lazy var termsOfferLabel = makeLabel()
    lazy var purchasePreloaderView = makePreloaderView()
    
    var timer: Timer?
    
    private(set) var specialOffer: PaygateSpecialOffer?
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        backgroundColor = UIColor(red: 152 / 255, green: 199 / 255, blue: 225 / 255, alpha: 1)
        
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(paygate: PaygateSpecialOffer) {
        self.specialOffer = paygate
        
        titleLabel.attributedText = paygate.title
        subTitleLabel.attributedText = paygate.subTitle
        textLabel.attributedText = paygate.text
        continueButton.setAttributedTitle(paygate.button, for: .normal)
        termsOfferLabel.attributedText = paygate.subButton
        restoreButton.setAttributedTitle(paygate.restore, for: .normal)
        
        let timeComponents = paygate.time?.split(separator: ":")
        setupTime(minutes: String(timeComponents?.first ?? "0"), seconds: String(timeComponents?.last ?? "0"))
        
        setupPrice(paygate: paygate)
    }
    
    func startTimer() {
        guard timer == nil else {
            return
        }
        
        guard let originalTime = specialOffer?.time else {
            setupTime(minutes: "00", seconds: "00")
            
            return
        }
        
        let originalTimeComponents = originalTime.split(separator: ":")
        let originalMinutes = Int(String(originalTimeComponents.first ?? "0")) ?? 0
        let originalSeconds = Int(String(originalTimeComponents.last ?? "0")) ?? 0
        
        let totalSeconds = originalMinutes * 60 + originalSeconds
        
        var secondsPassed = 0
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            guard let `self` = self else {
                return
            }
            
            secondsPassed += 1
            
            let left = totalSeconds - secondsPassed
            
            let leftMinutes = (left % 3600) / 60
            let leftSeconds = (left % 3600) % 60
            
            DispatchQueue.main.async { [weak self] in
                var leftMinutesString = String(leftMinutes)
                if leftMinutesString.count == 1 {
                    leftMinutesString = "0" + leftMinutesString
                }
                
                var leftSecondsString = String(leftSeconds)
                if leftSecondsString.count == 1 {
                    leftSecondsString = "0" + leftSecondsString
                }
                
                self?.setupTime(minutes: leftMinutesString, seconds: leftSecondsString)
            }
            
            if left <= 0 {
                self.stopTimer()
                
                return
            }
        }
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
}

// MARK: Private

private extension PaygateSpecialOfferView {
    func setupTime(minutes: String, seconds: String) {
        let valueAtts = TextAttributes()
            .font(Font.Poppins.regular(size: 24.scale))
            .textColor(UIColor.black)
        
        let placeholderAttrs = TextAttributes()
            .font(Font.Poppins.regular(size: 17.scale))
            .textColor(UIColor.black.withAlphaComponent(0.3))
        
        let result = NSMutableAttributedString()
        
        result.append(minutes.attributed(with: valueAtts))
        result.append(NSAttributedString(string: " "))
        
        result.append("Paygate.Min".localized.attributed(with: placeholderAttrs))
        result.append(NSAttributedString(string: "  "))
        
        result.append(seconds.attributed(with: valueAtts))
        result.append(NSAttributedString(string: " "))
        
        result.append("Paygate.Sec".localized.attributed(with: placeholderAttrs))
        
        timeLabel.attributedText = result
    }
    
    func setupPrice(paygate: PaygateSpecialOffer) {
        let price = NSMutableAttributedString()
        
        if let oldPrice = paygate.oldPrice {
            price.append(oldPrice)
            price.append(NSAttributedString(string: " "))
        }
        
        if let currentPrice = paygate.price {
            price.append(currentPrice)
        }
        
        priceLabel.attributedText = price
    }
}

// MARK: Make constraints

private extension PaygateSpecialOfferView {
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
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: ScreenSize.isIphoneXFamily ? 167.scale : 99.scale),
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            subTitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: ScreenSize.isIphoneXFamily ? 30.scale : 20.scale),
            subTitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30.scale),
            subTitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -30.scale)
        ])
        
        NSLayoutConstraint.activate([
            timeLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            timeLabel.topAnchor.constraint(equalTo: subTitleLabel.bottomAnchor, constant: ScreenSize.isIphoneXFamily ? 30.scale : 20.scale)
        ])
        
        NSLayoutConstraint.activate([
            textLabel.topAnchor.constraint(equalTo: topAnchor, constant: ScreenSize.isIphoneXFamily ? 493.scale : 370.scale),
            textLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30.scale),
            textLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -30.scale)
        ])
        
        NSLayoutConstraint.activate([
            lockImageView.widthAnchor.constraint(equalToConstant: 12.scale),
            lockImageView.heightAnchor.constraint(equalToConstant: 16.scale),
            lockImageView.trailingAnchor.constraint(equalTo: termsOfferLabel.leadingAnchor, constant: -10.scale),
            lockImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: ScreenSize.isIphoneXFamily ? -49.scale : -49.scale)
        ])
        
        NSLayoutConstraint.activate([
            termsOfferLabel.centerYAnchor.constraint(equalTo: lockImageView.centerYAnchor),
            termsOfferLabel.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 10.scale)
        ])
        
        NSLayoutConstraint.activate([
            continueButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: ScreenSize.isIphoneXFamily ? -82.scale : -82.scale),
            continueButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32.scale),
            continueButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32.scale),
            continueButton.heightAnchor.constraint(equalToConstant: 56.scale)
        ])
        
        NSLayoutConstraint.activate([
            priceLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: ScreenSize.isIphoneXFamily ? -154.scale : -154.scale),
            priceLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            purchasePreloaderView.centerYAnchor.constraint(equalTo: continueButton.centerYAnchor),
            purchasePreloaderView.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
}

// MARK: Lazy initialization

private extension PaygateSpecialOfferView {
    func makeBackgroundImageView() -> UIImageView {
        let view = UIImageView()
        view.clipsToBounds = true
        view.contentMode = .scaleAspectFill
        view.image = UIImage(named: ScreenSize.isIphoneXFamily ? "Paygate.SpecialOffer.Background_X" : "Paygate.SpecialOffer.Background")
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeRestoreButton() -> UIButton {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeLabel() -> UILabel {
        let view = UILabel()
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeContinueButton() -> UIButton {
        let view = UIButton()
        view.backgroundColor = UIColor(red: 252 / 255, green: 221 / 255, blue: 102 / 255, alpha: 1)
        view.layer.cornerRadius = 28.scale
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeLockIconView() -> UIImageView {
        let view = UIImageView()
        view.clipsToBounds = true
        view.contentMode = .scaleAspectFit
        view.image = UIImage(named: "Paygate.SpecialOffer.Secured")
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

