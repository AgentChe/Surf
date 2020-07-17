//
//  RegistrationEmailView.swift
//  Surf
//
//  Created by Andrey Chernyshev on 16.07.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import UIKit
import RxSwift

final class RegistrationEmailView: UIView {
    lazy var titleLabel = makeTitleLabel()
    lazy var subTitleLabel = makeSubTitleLabel()
    lazy var invalidateEmailLabel = makeInvalidateEmailLabel()
    lazy var emailTextField = makeEmailTextField()
    lazy var continueButton = makeContinueButton()
    lazy var activityIndicator = makeActivityIndicator()
    lazy var termsOfServiceButton = makeTermsOfServiceButton()
    
    var titleLabelTopConstraint: NSLayoutConstraint!
    var termsOfServiceBottomConstraint: NSLayoutConstraint!
    
    private let disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        
        makeConstraints()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private

private extension RegistrationEmailView {
    func bind() {
        rx.keyboardHeight
            .subscribe(onNext: { [weak self] keyboardHeight in
                self?.termsOfServiceBottomConstraint.constant = -(keyboardHeight > 0 ? (keyboardHeight + 20.scale) : 80.scale)
                
                if !ScreenSize.isIphoneXFamily {
                    self?.titleLabelTopConstraint.constant = keyboardHeight > 0 ? 30.scale : 92.scale
                }
            })
            .disposed(by: disposeBag)
    }
}

// MARK: Make constraints

private extension RegistrationEmailView {
    func makeConstraints() {
        titleLabelTopConstraint = titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 92.scale)
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40.scale),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40.scale),
            titleLabelTopConstraint
        ])
        
        NSLayoutConstraint.activate([
            subTitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40.scale),
            subTitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40.scale),
            subTitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 32.scale)
        ])
        
        NSLayoutConstraint.activate([
            invalidateEmailLabel.leadingAnchor.constraint(equalTo: emailTextField.leadingAnchor),
            invalidateEmailLabel.trailingAnchor.constraint(equalTo: emailTextField.trailingAnchor),
            invalidateEmailLabel.bottomAnchor.constraint(equalTo: emailTextField.topAnchor)
        ])
        
        NSLayoutConstraint.activate([
            emailTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40.scale),
            emailTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40.scale),
            emailTextField.topAnchor.constraint(equalTo: subTitleLabel.bottomAnchor, constant: 32.scale)
        ])
        
        NSLayoutConstraint.activate([
            continueButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40.scale),
            continueButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40.scale),
            continueButton.heightAnchor.constraint(equalToConstant: 56.scale),
            continueButton.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 32.scale)
        ])
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: continueButton.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: continueButton.centerYAnchor)
        ])
        
        termsOfServiceBottomConstraint = termsOfServiceButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -80.scale)
        NSLayoutConstraint.activate([
            termsOfServiceButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40.scale),
            termsOfServiceButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40.scale),
            termsOfServiceButton.heightAnchor.constraint(equalToConstant: 34.scale),
            termsOfServiceBottomConstraint
        ])
    }
}

// MARK: Lazy initialization

private extension RegistrationEmailView {
    func makeTitleLabel() -> UILabel {
        let view = UILabel()
        view.font = Font.OpenSans.bold(size: 34.scale)
        view.textColor = .black
        view.textAlignment = .center
        view.numberOfLines = 0
        view.text = "RegistrationEmail.TellUsYourEmail".localized
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeSubTitleLabel() -> UILabel {
        let view = UILabel()
        view.font = Font.OpenSans.regular(size: 20.scale)
        view.textColor = .black
        view.textAlignment = .center
        view.numberOfLines = 0
        view.text = "RegistrationEmail.WeWillSendYouCode".localized
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeInvalidateEmailLabel() -> UILabel {
        let view = UILabel()
        view.isHidden = true
        view.textColor = .red
        view.numberOfLines = 0
        view.font = Font.OpenSans.regular(size: 10.scale)
        view.text = "RegistrationEmail.InvalidateEmail".localized
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeEmailTextField() -> PaddingTextField {
        let view = PaddingTextField()
        view.leftInset = 20.scale
        view.rightInset = 20.scale
        view.topInset = 4.scale
        view.bottomInset = 4.scale
        view.placeholder = "inbox@gmail.com"
        view.backgroundColor = UIColor.white
        view.layer.cornerRadius = 9.scale
        view.textColor = .black
        view.autocorrectionType = .no
        view.font = Font.OpenSans.regular(size: 24.scale)
        view.layer.shadowRadius = 9.0.scale
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 3.scale, height: 3.scale)
        view.layer.shadowOpacity = 0.2
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
    
    func makeActivityIndicator() -> UIActivityIndicatorView {
        let view = UIActivityIndicatorView()
        view.hidesWhenStopped = true
        view.style = .gray
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeTermsOfServiceButton() -> UIButton {
        let attrs1 = "RegistrationEmail.TermsOfService.Part1".localized
            .attributed(with: TextAttributes()
                .font(Font.OpenSans.regular(size: 15.scale))
                .textColor(.black)
                .textAlignment(.center))
        
        let attrs2 = "RegistrationEmail.TermsOfService.Part2".localized
            .attributed(with: TextAttributes()
                .font(Font.OpenSans.bold(size: 15.scale))
                .textColor(.black)
                .textAlignment(.center))
        
        let attrs = NSMutableAttributedString()
        attrs.append(attrs1)
        attrs.append(NSAttributedString(string: "\n"))
        attrs.append(attrs2)
        
        let view = UIButton()
        view.setAttributedTitle(attrs, for: .normal)
        view.titleLabel?.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
