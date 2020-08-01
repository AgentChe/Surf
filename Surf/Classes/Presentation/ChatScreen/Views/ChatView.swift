//
//  ChatView.swift
//  Surf
//
//  Created by Andrey Chernyshev on 31.07.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import UIKit
import RxSwift

final class ChatView: UIView {
    lazy var tableView = makeTableView()
    lazy var chatInputView = makeChatInputView()
    
    var chatInputViewBottomConstraint: NSLayoutConstraint!
    
    private let disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        
        makeConstraints()
        
        rx.keyboardHeight
            .subscribe(onNext: { [weak self] keyboardHeight in
                var inset = keyboardHeight
            
                if inset > 0, ScreenSize.hasBottomNotch {
                    inset -= 35
                }
                
                self?.chatInputViewBottomConstraint.constant = -inset
            
                UIView.animate(withDuration: 0.25, animations: { [weak self] in
                    self?.layoutIfNeeded()
                })
            })
            .disposed(by: disposeBag)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Make constraints

extension ChatView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: chatInputView.topAnchor)
        ])
        
        chatInputViewBottomConstraint = chatInputView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        NSLayoutConstraint.activate([
            chatInputView.leadingAnchor.constraint(equalTo: leadingAnchor),
            chatInputView.trailingAnchor.constraint(equalTo: trailingAnchor),
            chatInputViewBottomConstraint
        ])
    }
}

// MARK: Lazy initialization

extension ChatView {
    func makeTableView() -> ChatTableView {
        let view = ChatTableView()
        view.backgroundColor = .white
        view.separatorStyle = .none
        view.allowsSelection = false
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeChatInputView() -> ChatInputView {
        let view = ChatInputView()
        view.backgroundColor = UIColor(red: 248 / 255, green: 248 / 255, blue: 249 / 255, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
