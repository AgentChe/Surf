//
//  ChatsViewController.swift
//  FAWN
//
//  Created by Andrey Chernyshev on 05/06/2020.
//  Copyright © 2020 Алексей Петров. All rights reserved.
//

import UIKit
import RxSwift

final class ChatsViewController: UIViewController {
    var chatsView = ChatsView()
    
    weak var delegate: ChatsViewControllerDelegate?
    
    private let viewModel = ChatsViewModel()
    
    private let disposeBag = DisposeBag()
    
    deinit {
        viewModel.disconnect()
        
        ChatsManager.shared.remove(observer: self)
    }
    
    override func loadView() {
        super.loadView()
        
        view = chatsView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ChatsManager.shared.add(observer: self)
        
        AmplitudeAnalytics.shared.log(with: .chatListScr)
        
        addActions()
        
        viewModel
            .profile()
            .drive(onNext: { [weak self] profile in
                guard let mainPhoto = profile?.photos.first(where: { $0.order == 1 }) else {
                    return
                }
                
                guard let url = URL(string: mainPhoto.url) else {
                    return
                }
                
                self?.chatsView.photoView.kf.setImage(with: url)
            })
            .disposed(by: disposeBag)
        
        chatsView.collectionView.rx
            .selectedChat
            .emit(onNext: { [weak self] chat in
                AmplitudeAnalytics.shared.log(with: .chatListTap("chat"))
                
                self?.goToChatScreen(with: chat)
            })
            .disposed(by: disposeBag)
        
        chatsView.collectionView.rx
            .changedElementsCount
            .emit(onNext: { [weak self] elementsCount in
                let isEmpty = elementsCount == 0
                
                self?.chatsView.collectionView.isHidden = isEmpty
                self?.chatsView.emptyView.isHidden = !isEmpty
            })
            .disposed(by: disposeBag)
        
        chatsView.collectionView.rx
            .longPressedChat
            .emit(onNext: { [weak self] chat in
                self?.goToChatsMenuScreen(chat: chat)
            })
            .disposed(by: disposeBag)
        
        viewModel.chats
            .drive(onNext: { [weak self] chats in
                self?.chatsView.collectionView.add(chats: chats)
            })
            .disposed(by: disposeBag)
        
        viewModel.chatEvent()
            .drive(onNext: { [weak self] event in
                switch event {
                case .changedChat(let chat):
                    self?.chatsView.collectionView.replace(chat: chat)
                case .removedChat(let chat):
                    self?.chatsView.collectionView.remove(chat: chat)
                case .createdChat(let chat):
                    self?.chatsView.collectionView.insert(chat: chat)
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.connect()
    }
}

// MARK: Make

extension ChatsViewController {
    static func make() -> ChatsViewController {
        ChatsViewController(nibName: nil, bundle: nil)
    }
}

// MARK: ChatViewControllerDelegate

extension ChatsViewController: ChatViewControllerDelegate {
    func markReaded(chat: Chat, message: Message) {
        var readedChat = chat
        readedChat.change(unreadMessageCount: 0)
        
        chatsView.collectionView.replace(chat: readedChat)
    }
}

// MARK: ChatsManagerDelegate

extension ChatsViewController: ChatsManagerDelegate {
    func didRemovedAllChats() {
        chatsView.collectionView.removeAll()
    }
}

// MARK: ChatsMenuViewControllerDelegate

extension ChatsViewController: ChatsMenuViewControllerDelegate {
    func chatsMenuViewController(unmatched: Chat) {
        chatsView.collectionView.remove(chat: unmatched)
    }
    
    func chatsMenuViewController(deleted: Chat) {
        chatsView.collectionView.remove(chat: deleted)
    }
}

// MARK: Private

private extension ChatsViewController {
    func addActions() {
        chatsView
            .emptyView
            .newSearchButton
            .addTarget(self, action: #selector(newSearchTapped(sender:)), for: .touchUpInside)
        
        let photoTapGesture = UITapGestureRecognizer(target: self, action: #selector(goToProfileScreen))
        chatsView.photoView.addGestureRecognizer(photoTapGesture)
    }
    
    @objc
    func goToProfileScreen() {
        navigationController?.pushViewController(ProfileViewController.make(), animated: true)
    }
    
    func goToChatScreen(with chat: Chat) {
        let vc = ChatViewController.make(with: chat)
        vc.delegate = self 
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func goToChatsMenuScreen(chat: Chat) {
        let vc = ChatsMenuViewController.make(chat: chat)
        vc.delegate = self
        navigationController?.present(vc, animated: false)
    }
    
    @objc
    func newSearchTapped(sender: Any) {
        AmplitudeAnalytics.shared.log(with: .chatListTap("new_search"))
        
        delegate?.newSearchTapped()
    }
}
