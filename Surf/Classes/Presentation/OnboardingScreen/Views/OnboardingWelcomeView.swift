//
//  OnboardingWelcomeView.swift
//  FAWN
//
//  Created by Andrey Chernyshev on 22/04/2020.
//  Copyright © 2020 Алексей Петров. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Kingfisher

final class OnboardingWelcomeView: UIView {
    var onNext: (() -> Void)?
    
    lazy var photosSlider = makePhotosSlider()
    lazy var emojiLabel = makeEmojiLabel()
    lazy var welcomeLabel = makeWelcomeLabel()
    lazy var horoImageView = makeHoroImageView()
    lazy var activityIndicator = makeActivityIndicator()
    lazy var emojiButton = makeEmojiButton()
    lazy var continueButton = makeContinueButton()
    
    private let randomizeEmoji = PublishRelay<Void>()
    private let loading = RxActivityIndicator()
    
    private let disposeBag = DisposeBag()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(name: String, birthdate: Date, photos: [String]) {
        randomizeEmoji.accept(Void())
        
        photosSlider.setup(urls: photos.compactMap { URL(string: $0) })
        
        let age = Calendar.current.dateComponents([.year], from: birthdate, to: Date()).year ?? 0
        welcomeLabel.text = String(format: "Onboarding.WelcomeHi".localized, name, age)
        
        if let zodiacSign = ZodiacManager.shared.zodiac(at: birthdate) {
            let describingZodiacSign = String(describing: zodiacSign.sign)
            horoImageView.image = UIImage(named: String(format: "HoroSign.White.%@", describingZodiacSign))
        }
    }
}

// MARK: Private

private extension OnboardingWelcomeView {
    func bind() {
        loading
            .drive(onNext: { [weak self] isLoading in
                isLoading ? self?.activityIndicator.startAnimating() : self?.activityIndicator.stopAnimating()
                self?.continueButton.isUserInteractionEnabled = !isLoading
                self?.emojiButton.isHidden = isLoading
            })
            .disposed(by: disposeBag)
        
        emojiButton.rx.tap
            .do(onNext: {
                AmplitudeAnalytics.shared.log(with: .avatarTap("randomize"))
            })
            .bind(to: randomizeEmoji)
            .disposed(by: disposeBag)
        
        let randomize = randomizeEmoji
            .flatMapLatest { [unowned self] in
                ProfileManager
                    .randomizeEmoji()
                    .trackActivity(self.loading)
                    .catchErrorJustReturn(nil)
            }
            .share()
        
        randomize
            .subscribe(onNext: { [weak self] emoji in
                self?.emojiLabel.text = emoji
            })
            .disposed(by: disposeBag)
        
        continueButton.rx.tap
            .skipUntil(randomize)
            .subscribe(onNext: { [weak self] in
                AmplitudeAnalytics.shared.log(with: .avatarTap("continue"))
                
                self?.onNext?()
            })
            .disposed(by: disposeBag)
    }
}

// MARK: Make constraints

private extension OnboardingWelcomeView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            photosSlider.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 28.scale),
            photosSlider.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -28.scale),
            photosSlider.topAnchor.constraint(equalTo: topAnchor, constant: ScreenSize.isIphoneXFamily ? 130.scale : 100.scale),
            photosSlider.heightAnchor.constraint(equalToConstant: ScreenSize.isIphoneXFamily ? 449.scale : 350.scale)
        ])
        
        NSLayoutConstraint.activate([
            emojiLabel.leadingAnchor.constraint(equalTo: photosSlider.leadingAnchor, constant: 24.scale),
            emojiLabel.bottomAnchor.constraint(equalTo: welcomeLabel.topAnchor, constant: -8.scale)
        ])
        
        NSLayoutConstraint.activate([
            welcomeLabel.leadingAnchor.constraint(equalTo: photosSlider.leadingAnchor, constant: 24.scale),
            welcomeLabel.trailingAnchor.constraint(equalTo: photosSlider.trailingAnchor, constant: -24.scale),
            welcomeLabel.bottomAnchor.constraint(equalTo: horoImageView.topAnchor, constant: -8.scale)
        ])
        
        NSLayoutConstraint.activate([
            horoImageView.leadingAnchor.constraint(equalTo: photosSlider.leadingAnchor, constant: 24.scale),
            horoImageView.widthAnchor.constraint(equalToConstant: 36.scale),
            horoImageView.heightAnchor.constraint(equalToConstant: 36.scale),
            horoImageView.bottomAnchor.constraint(equalTo: photosSlider.bottomAnchor, constant: -28.scale)
        ])
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: emojiButton.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: emojiButton.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            emojiButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40.scale),
            emojiButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40.scale),
            emojiButton.heightAnchor.constraint(equalToConstant: 40.scale),
            emojiButton.bottomAnchor.constraint(equalTo: continueButton.topAnchor, constant: -20.scale)
        ])
        
        NSLayoutConstraint.activate([
            continueButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40.scale),
            continueButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40.scale),
            continueButton.heightAnchor.constraint(equalToConstant: 56.scale),
            continueButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: ScreenSize.isIphoneXFamily ? -67.scale : -40.scale)
        ])
    }
}

// MARK: Lazy initialization

private extension OnboardingWelcomeView {
    func makePhotosSlider() -> PhotosSlider {
        let view = PhotosSlider()
        view.backgroundColor = .clear
        view.layer.cornerRadius = 16.scale
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeEmojiLabel() -> UILabel {
        let view = UILabel()
        view.textAlignment = .center
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeHoroImageView() -> UIImageView {
        let view = UIImageView()
        view.clipsToBounds = true
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeWelcomeLabel() -> UILabel {
        let view = UILabel()
        view.numberOfLines = 0
        view.textColor = .white
        view.font = Font.OpenSans.bold(size: 34.scale)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeActivityIndicator() -> UIActivityIndicatorView {
        let view = UIActivityIndicatorView()
        view.style = .gray
        view.hidesWhenStopped = true
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeEmojiButton() -> UIButton {
        let view = UIButton()
        view.setTitle("Onboarding.RandomizeEmoji".localized, for: .normal)
        view.titleLabel?.font = Font.OpenSans.semibold(size: 17.scale)
        view.setTitleColor(.black, for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeContinueButton() -> UIButton {
        let view = UIButton()
        view.titleLabel?.font = Font.OpenSans.semibold(size: 17.scale)
        view.setTitleColor(.white, for: .normal)
        view.setTitle("Onboarding.Niccce!".localized, for: .normal)
        view.layer.cornerRadius = 28.scale
        view.backgroundColor = UIColor(red: 86 / 255, green: 86 / 255, blue: 214 / 255, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
