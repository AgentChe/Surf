//
//  OnboardingNameView.swift
//  FAWN
//
//  Created by Andrey Chernyshev on 19/04/2020.
//  Copyright © 2020 Алексей Петров. All rights reserved.
//

import UIKit

final class OnboardingNameView: UIView {
    var onNext: ((String) -> Void)?
    
    lazy var titleLabel = makeTitleLabel()
    lazy var subTitleLabel = makeSubTitleLabel()
    lazy var textField = makeTextField()
    lazy var continueButton = makeContinueButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        textField.becomeFirstResponder()
    }
}

// MARK: UITextFieldDelegate

extension OnboardingNameView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard textField.text?.isEmpty == false else {
            return false
        }
        
        complete(with: textField.text ?? "")
        
        return true
    }
}

// MARK: Private

private extension OnboardingNameView {
    @objc
    private func textFieldDidChange(textField: UITextField) {
        continueButton.isEnabled = textField.text?.isEmpty == false
    }
    
    @objc
    private func buttonTapped(sender: Any) {
        complete(with: textField.text ?? "")
    }
    
    private func complete(with text: String) {
        textField.resignFirstResponder()
        onNext?(text)
    }
}

// MARK: Make constraints

private extension OnboardingNameView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 120.scale),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 36.scale),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -36.scale)
        ])
        
        NSLayoutConstraint.activate([
            subTitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 28.scale.scale),
            subTitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 36.scale),
            subTitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -36.scale)
        ])
        
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: subTitleLabel.bottomAnchor, constant: 28.scale),
            textField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 36.scale),
            textField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -36.scale),
        ])
        
        NSLayoutConstraint.activate([
            continueButton.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 40.scale),
            continueButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40.scale),
            continueButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40.scale),
            continueButton.heightAnchor.constraint(equalToConstant: 56.scale)
        ])
    }
}

// MARK: Lazy initialization

private extension OnboardingNameView {
    func makeTitleLabel() -> UILabel {
        let view = UILabel()
        view.font = Font.OpenSans.bold(size: 34.scale)
        view.textColor = .black
        view.numberOfLines = 0
        view.textAlignment = .center
        view.text = "Onboarding.EnterYourName".localized
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
        view.text = "Onboarding.EnterNameInfo".localized
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeTextField() -> PaddingTextField {
        let view = PaddingTextField()
        view.leftInset = 20.scale
        view.rightInset = 20.scale
        view.topInset = 4.scale
        view.bottomInset = 4.scale
        view.placeholder = "Onboarding.EnterYourName.Placeholder".localized
        view.backgroundColor = UIColor.white
        view.layer.cornerRadius = 9.scale
        view.textColor = .black
        view.font = Font.OpenSans.regular(size: 24.scale)
        view.autocapitalizationType = .sentences
        view.layer.shadowRadius = 9.0.scale
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 3.scale, height: 3.scale)
        view.layer.shadowOpacity = 0.2
        view.delegate = self
        view.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: .editingChanged)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeContinueButton() -> UIButton {
        let view = UIButton()
        view.isEnabled = false
        view.titleLabel?.font = Font.OpenSans.semibold(size: 17.scale)
        view.setTitleColor(.white, for: .normal)
        view.setTitle("Onboarding.Continue".localized, for: .normal)
        view.layer.cornerRadius = 28.scale
        view.backgroundColor = UIColor(red: 86 / 255, green: 86 / 255, blue: 214 / 255, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addTarget(self, action: #selector(buttonTapped(sender:)), for: .touchUpInside)
        addSubview(view)
        return view
    }
}
