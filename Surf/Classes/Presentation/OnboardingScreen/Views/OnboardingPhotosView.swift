//
//  OnboardingPhotosView.swift
//  FAWN
//
//  Created by Andrey Chernyshev on 19/04/2020.
//  Copyright © 2020 Алексей Петров. All rights reserved.
//

import UIKit

final class OnboardingPhotosView: UIView {
    var onNext: (([String]) -> Void)?
    
    lazy var titleLabel = makeTitleLabel()
    lazy var subTitleLabel = makeSubTitleLabel()
    lazy var imageView1 = makeImageView(tag: 1)
    lazy var imageView2 = makeImageView(tag: 2)
    lazy var imageView3 = makeImageView(tag: 3)
    lazy var continueButton = makeContinueButton()
    
    private let photosManager = OnboardingPhotosManager()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: OnboardingPhotoViewDelegate

extension OnboardingPhotosView: OnboardingPhotoViewDelegate {
    func photoUploadSuccessfully(with url: String, for tag: Int) {
        photosManager.set(url: url, for: tag)
    }
    
    func photoUploadFailure(with error: String) {
        guard let rootVC = UIApplication.shared.keyWindow?.rootViewController else {
            return
        }
        
        let alert = UIAlertController(title: nil, message: error, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK".localized, style: .cancel))
        
        rootVC.present(alert, animated: true)
    }
    
    func blockTagForSelect(tag: Int, isBlocked: Bool) {
        photosManager.blockSelect(tag: tag, isBlocked: isBlocked)
    }
}

// MARK: Private

private extension OnboardingPhotosView {
    @objc
    private func continueButtonTapped(sender: Any) {
        guard !photosManager.isEmpty() else {
            return
        }
        
        [imageView1, imageView2, imageView3].forEach { $0.cancel() }
        
        onNext?(photosManager.getUrls())
    }
}

// MARK: Make constraints

private extension OnboardingPhotosView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 92.scale),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 36.scale),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -36.scale)
        ])
        
        NSLayoutConstraint.activate([
            subTitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 35.scale),
            subTitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 36.scale),
            subTitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -36.scale)
        ])
        
        NSLayoutConstraint.activate([
            imageView1.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 43.scale),
            imageView1.topAnchor.constraint(equalTo: subTitleLabel.bottomAnchor, constant: 40.scale),
            imageView1.widthAnchor.constraint(equalTo: imageView2.widthAnchor),
            imageView1.heightAnchor.constraint(equalTo: imageView1.widthAnchor),
            imageView1.trailingAnchor.constraint(equalTo: imageView2.leadingAnchor, constant: -12.scale)
        ])
        
        NSLayoutConstraint.activate([
            imageView2.centerYAnchor.constraint(equalTo: imageView1.centerYAnchor),
            imageView2.widthAnchor.constraint(equalTo: imageView3.widthAnchor),
            imageView2.heightAnchor.constraint(equalTo: imageView2.widthAnchor),
            imageView2.trailingAnchor.constraint(equalTo: imageView3.leadingAnchor, constant: -12.scale)
        ])
        
        NSLayoutConstraint.activate([
            imageView3.centerYAnchor.constraint(equalTo: imageView1.centerYAnchor),
            imageView3.widthAnchor.constraint(equalTo: imageView1.widthAnchor),
            imageView3.heightAnchor.constraint(equalTo: imageView3.widthAnchor),
            imageView3.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -43.scale)
        ])
        
        NSLayoutConstraint.activate([
            continueButton.topAnchor.constraint(equalTo: imageView1.bottomAnchor, constant: 40.scale),
            continueButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40.scale),
            continueButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40.scale),
            continueButton.heightAnchor.constraint(equalToConstant: 56.scale)
        ])
    }
}

// MARK: Lazy initialization

private extension OnboardingPhotosView {
    func makeTitleLabel() -> UILabel {
        let view = UILabel()
        view.font = Font.OpenSans.bold(size: 34.scale)
        view.textColor = .black
        view.numberOfLines = 0
        view.textAlignment = .center
        view.text = "Onboarding.AddSomePhotos".localized
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeSubTitleLabel() -> UILabel {
        let view = UILabel()
        view.font = Font.OpenSans.regular(size: 20.scale)
        view.textColor = .black
        view.numberOfLines = 0
        view.textAlignment = .center
        view.text = "Onboarding.PhotosInfo".localized
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeImageView(tag: Int) -> OnboardingPhotoView {
        let view = OnboardingPhotoView(tag: tag)
        view.delegate = self
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeContinueButton() -> UIButton {
        let view = UIButton()
        view.titleLabel?.font = Font.OpenSans.semibold(size: 17.scale)
        view.setTitleColor(.white, for: .normal)
        view.setTitle("Onboarding.Continue".localized, for: .normal)
        view.layer.cornerRadius = 28.scale
        view.backgroundColor = UIColor(red: 86 / 255, green: 86 / 255, blue: 214 / 255, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addTarget(self, action: #selector(continueButtonTapped(sender:)), for: .touchUpInside)
        addSubview(view)
        return view
    }
}
