//
//  ReportWhatExactlyView.swift
//  Surf
//
//  Created by Andrey Chernyshev on 28.07.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import UIKit

final class ReportWhatExactlyView: UIView {
    lazy var cancelButton = makeCancelButton()
    lazy var sendButton = makeSendButton()
    lazy var titleLabel = makeTitleLabel()
    lazy var separatorView = makeSeparatorView()
    lazy var textView = makeTextView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Make constraints

private extension ReportWhatExactlyView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            cancelButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            cancelButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            cancelButton.heightAnchor.constraint(equalToConstant: 22.scale)
        ])
        
        NSLayoutConstraint.activate([
            sendButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            sendButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            sendButton.heightAnchor.constraint(equalToConstant: 22.scale)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 12.scale)
        ])
        
        NSLayoutConstraint.activate([
            separatorView.leadingAnchor.constraint(equalTo: leadingAnchor),
            separatorView.trailingAnchor.constraint(equalTo: trailingAnchor),
            separatorView.heightAnchor.constraint(equalToConstant: 1.scale),
            separatorView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12.scale)
        ])
        
        NSLayoutConstraint.activate([
            textView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            textView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            textView.topAnchor.constraint(equalTo: separatorView.bottomAnchor, constant: 12.scale),
            textView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12.scale)
        ])
    }
}

// MARK: Lazy initialization

private extension ReportWhatExactlyView {
    func makeCancelButton() -> UIButton {
        let view = UIButton()
        view.setTitle("Cancel".localized, for: .normal)
        view.setTitleColor(UIColor(red: 0, green: 122 / 255, blue: 1, alpha: 1), for: .normal)
        view.titleLabel?.font = Font.SFProText.regular(size: 17.scale)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeSendButton() -> UIButton {
        let view = UIButton()
        view.setTitle("Send".localized, for: .normal)
        view.setTitleColor(UIColor(red: 0, green: 122 / 255, blue: 1, alpha: 1), for: .normal)
        view.titleLabel?.font = Font.SFProText.bold(size: 17.scale)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeTitleLabel() -> UILabel {
        let view = UILabel()
        view.font = Font.SFProText.semibold(size: 17.scale)
        view.textColor = .black
        view.textAlignment = .center
        view.text = "Report.WhatExactly".localized
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeSeparatorView() -> UIView {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeTextView() -> UITextView {
        let view = UITextView()
        view.backgroundColor = .clear
        view.font = Font.SFProText.regular(size: 17.scale)
        view.textColor = .black
        view.autocorrectionType = .no
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
