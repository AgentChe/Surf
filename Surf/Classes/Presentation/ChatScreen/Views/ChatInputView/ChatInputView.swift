//
//  ChatinputView.swift
//  RACK
//
//  Created by Andrey Chernyshev on 01/03/2020.
//  Copyright © 2020 fawn.team. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class ChatInputView: UIView {
    lazy var attachButton = makeAttachButton()
    lazy var inputTextView = makeInputTextView()
    
    private(set) lazy var attachTapped = attachButton.event.asSignal()
    private(set) lazy var sendTapped = inputTextView.tapSend
    private(set) lazy var text = inputTextView.text
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(attachState: ChatAttachButton.State) {
        attachButton.apply(state: attachState)
    }
    
    func set(text: String) {
        inputTextView.set(text: text)
    }
}

// MARK: Make constraints

private extension ChatInputView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            attachButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8.scale),
            attachButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8.scale),
            attachButton.heightAnchor.constraint(equalToConstant: 36.scale),
            attachButton.widthAnchor.constraint(equalToConstant: 36.scale)
        ])
        
        NSLayoutConstraint.activate([
            inputTextView.leadingAnchor.constraint(equalTo: attachButton.trailingAnchor, constant: 8.scale),
            inputTextView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8.scale),
            inputTextView.topAnchor.constraint(equalTo: topAnchor, constant: 8.scale),
            inputTextView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8.scale)
        ])
    }
}

// MARK: Lazy initialization

private extension ChatInputView {
    func makeAttachButton() -> ChatAttachButton {
        let view = ChatAttachButton()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeInputTextView() -> ChatInpuTextView {
        let view = ChatInpuTextView()
        view.backgroundColor = .clear
        view.layer.cornerRadius = 20.scale
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
