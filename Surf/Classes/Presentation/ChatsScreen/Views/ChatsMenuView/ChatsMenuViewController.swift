//
//  ChatsMenuViewController.swift
//  Surf
//
//  Created by Andrey Chernyshev on 30.07.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class ChatsMenuViewController: UIViewController {
    var chatsMenuView = ChatsMenuView()
    
    weak var delegate: ChatsMenuViewControllerDelegate?
    
    fileprivate(set) var chat: Chat!
    
    private let viewModel = ChatsMenuViewModel()
    
    private let disposeBag = DisposeBag()
    
    override func loadView() {
        super.loadView()
        
        view = chatsMenuView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        chatsMenuView.setup(chat: chat)
        
        addActions()
        
        chatsMenuView
            .unmatchCell
            .tapGesture.rx.event
            .map { [unowned self] _ in self.chat }
            .flatMapLatest { [unowned self] chat in
                self.viewModel.unmatch(chat: chat)
            }
            .asDriver(onErrorJustReturn: false)
            .drive(onNext: { [weak self] success in
                guard let `self` = self else {
                    return
                }
                
                guard success else {
                    Toast.notify(with: "Chats.Menu.UnmatchFailure".localized, style: .danger)
                    
                    return
                }
                
                Toast.notify(with: "Chats.Menu.UnmatchSuccess".localized, style: .success)
                
                self.delegate?.chatsMenuViewController(unmatched: self.chat)
                
                self.dismiss(animated: false)
            })
            .disposed(by: disposeBag)
        
        chatsMenuView
            .deleteCell
            .tapGesture.rx.event
            .map { [unowned self] _ in self.chat }
            .flatMapLatest { [unowned self] chat in
                self.viewModel.unmatch(chat: chat)
            }
            .asDriver(onErrorJustReturn: false)
            .drive(onNext: { [weak self] success in
                guard let `self` = self else {
                    return
                }
                
                guard success else {
                    Toast.notify(with: "Chats.Menu.DeleteFailure".localized, style: .danger)
                    
                    return
                }
                
                Toast.notify(with: "Chats.Menu.DeleteSuccess".localized, style: .success)
                
                self.delegate?.chatsMenuViewController(deleted: self.chat)
                
                self.dismiss(animated: false)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: Make

extension ChatsMenuViewController {
    static func make(chat: Chat) -> ChatsMenuViewController {
        let vc = ChatsMenuViewController()
        vc.modalPresentationStyle = .overCurrentContext
        vc.chat = chat
        return vc
    }
}

// MARK: Private

private extension ChatsMenuViewController {
    func addActions() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hide))
        chatsMenuView.addGestureRecognizer(tapGesture)
        chatsMenuView.isUserInteractionEnabled = true
    }
    
    @objc
    func hide() {
        dismiss(animated: false)
    }
}
