//
//  ConfirmCodeView.swift
//  Surf
//
//  Created by Andrey Chernyshev on 17.07.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import UIKit

final class ConfirmCodeView: UIView {
    lazy var placeholderTitleView = makePlaceholderTitleView()
    lazy var codeIncorrectView = makeCodeIncorrectView()
    lazy var codeTextFields = [makeCodeTextField(), makeCodeTextField(), makeCodeTextField(), makeCodeTextField(), makeCodeTextField()]
    lazy var codeDotViews = [makeCodeDotView(), makeCodeDotView(), makeCodeDotView(), makeCodeDotView(), makeCodeDotView()]
    lazy var sendNewCodeButton = makeSendNewCodeButton()
    
    var weJustSentCodeLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        
        makeConstraints()
        
        codeTextFields.forEach {
            $0.addTarget(self, action: #selector(textFieldChanged(_:)), for: .editingChanged)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(email: String) {
        weJustSentCodeLabel.text = String(format: "ConfirmCode.WeJustSentTo".localized, email)
        
        codeTextFields[0].becomeFirstResponder()
    }
}

// MARK: Private

private extension ConfirmCodeView {
    @objc
    func textFieldChanged(_ sender: Any) {
        guard let textField = sender as? UITextField else {
            return
        }
        
        guard let index = codeTextFields.firstIndex(of: textField) else {
            return
        }
        
        codeDotViews[index].isHidden = textField.text?.isEmpty == false
    }
}

// MARK: Make constraints

private extension ConfirmCodeView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            placeholderTitleView.leadingAnchor.constraint(equalTo: leadingAnchor),
            placeholderTitleView.trailingAnchor.constraint(equalTo: trailingAnchor),
            placeholderTitleView.bottomAnchor.constraint(equalTo: codeTextFields[0].topAnchor, constant: -32.scale)
        ])
        
        NSLayoutConstraint.activate([
            codeIncorrectView.leadingAnchor.constraint(equalTo: leadingAnchor),
            codeIncorrectView.trailingAnchor.constraint(equalTo: trailingAnchor),
            codeIncorrectView.bottomAnchor.constraint(equalTo: codeTextFields[0].topAnchor, constant: -32.scale)
        ])
        
        codeTextFields.forEach {
            NSLayoutConstraint.activate([
                $0.widthAnchor.constraint(equalToConstant: 38.scale),
                $0.heightAnchor.constraint(equalToConstant: 38.scale),
                $0.topAnchor.constraint(equalTo: topAnchor, constant: ScreenSize.isIphoneXFamily ? 344.scale : 300.scale)
            ])
        }
        
        NSLayoutConstraint.activate([
            codeTextFields[0].trailingAnchor.constraint(equalTo: codeTextFields[1].leadingAnchor, constant: -12.scale),
            codeTextFields[1].trailingAnchor.constraint(equalTo: codeTextFields[2].leadingAnchor, constant: -12.scale),
            codeTextFields[2].centerXAnchor.constraint(equalTo: centerXAnchor),
            codeTextFields[3].leadingAnchor.constraint(equalTo: codeTextFields[2].trailingAnchor, constant: 12.scale),
            codeTextFields[4].leadingAnchor.constraint(equalTo: codeTextFields[3].trailingAnchor, constant: 12.scale)
        ])
        
        codeDotViews.enumerated().forEach {
            NSLayoutConstraint.activate([
                $0.element.widthAnchor.constraint(equalToConstant: 8.scale),
                $0.element.heightAnchor.constraint(equalToConstant: 8.scale),
                $0.element.centerXAnchor.constraint(equalTo: codeTextFields[$0.offset].centerXAnchor),
                $0.element.centerYAnchor.constraint(equalTo: codeTextFields[$0.offset].centerYAnchor)
            ])
        }
        
        NSLayoutConstraint.activate([
            sendNewCodeButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40.scale),
            sendNewCodeButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40.scale),
            sendNewCodeButton.heightAnchor.constraint(equalToConstant: 40.scale),
            sendNewCodeButton.topAnchor.constraint(equalTo: codeTextFields[0].bottomAnchor, constant: 40.scale)
        ])
    }
}

// MARK: Lazy initialization

private extension ConfirmCodeView {
    func makePlaceholderTitleView() -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        addSubview(view)
        
        let imageView = UIImageView()
        imageView.image = UIImage(named: "ConfirmCode.Icon1")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
        
        let titleLabel = UILabel()
        titleLabel.font = Font.OpenSans.bold(size: 34.scale)
        titleLabel.text = "ConfirmCode.EnterCode".localized
        titleLabel.textColor = .black
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)
        
        let subTitleLabel = UILabel()
        subTitleLabel.font = Font.OpenSans.regular(size: 20.scale)
        subTitleLabel.textColor = .black
        subTitleLabel.numberOfLines = 0
        subTitleLabel.textAlignment = .center
        subTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(subTitleLabel)
        
        weJustSentCodeLabel = subTitleLabel
        
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 85.scale),
            imageView.heightAnchor.constraint(equalToConstant: 69.scale),
            imageView.topAnchor.constraint(equalTo: view.topAnchor)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 24.scale)
        ])
        
        NSLayoutConstraint.activate([
           subTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
           subTitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
           subTitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 24.scale),
           subTitleLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        return view
    }
    
    func makeCodeIncorrectView() -> UIView {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        
        let imageView = UIImageView()
        imageView.image = UIImage(named: "ConfirmCode.Icon2")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
        
        let label = UILabel()
        label.font = Font.OpenSans.bold(size: 34.scale)
        label.textColor = .black
        label.numberOfLines = 0
        label.text = "ConfirmCode.CodeIncorrect".localized
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 95.scale),
            imageView.heightAnchor.constraint(equalToConstant: 80.scale),
            imageView.topAnchor.constraint(equalTo: view.topAnchor)
        ])
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            label.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 24.scale),
            label.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        return view
    }
    
    func makeCodeTextField() -> UITextField {
        let view = UITextField()
        view.textColor = .black
        view.tintColor = .clear
        view.keyboardType = .decimalPad
        view.textAlignment = .center
        view.textContentType = .oneTimeCode
        view.font = Font.OpenSans.semibold(size: 17.scale)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeCodeDotView() -> UIView {
        let view = UIView()
        view.backgroundColor = .black
        view.layer.cornerRadius = 4.scale
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeSendNewCodeButton() -> UIButton {
        let view = UIButton()
        view.titleLabel?.font = Font.OpenSans.regular(size: 17.scale)
        view.setTitleColor(UIColor.black, for: .normal)
        view.setTitle("ConfirmCode.SendNewCode".localized, for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
