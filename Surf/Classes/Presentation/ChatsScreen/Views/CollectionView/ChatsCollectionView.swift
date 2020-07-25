//
//  ChatsCollectionView.swift
//  Surf
//
//  Created by Andrey Chernyshev on 23.07.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class ChatsCollectionView: UICollectionView {
    fileprivate let selectedChat = PublishRelay<Chat>()
    fileprivate let changedElementsCount = PublishRelay<Int>()
    
    private var elements = [Chat]() {
        didSet {
            changedElementsCount.accept(elements.count)
        }
    }
    
    private let itemsQueue = DispatchQueue(label: "chats_queue")
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        
        register(ChatsCollectionCell.self, forCellWithReuseIdentifier: String(describing: ChatsCollectionCell.self))
        
        dataSource = self
        delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Data source

extension ChatsCollectionView {
    func add(chats: [Chat]) {
        itemsQueue.sync { [weak self] in
            self?.elements = chats
            
            self?.reloadData()
        }
    }
    
    func replace(chat: Chat) {
        itemsQueue.sync { [weak self] in
            guard let index = self?.elements.firstIndex(where: { $0.id == chat.id }) else {
                return
            }
            
            self?.elements[index] = chat
            
            self?.reloadItems(at: [IndexPath(row: index, section: 0)])
        }
    }
    
    func remove(chat: Chat) {
        itemsQueue.sync { [weak self] in
            guard let index = self?.elements.firstIndex(where: { $0.id == chat.id }) else {
                return
            }
            
            self?.elements.remove(at: index)
            
            self?.deleteItems(at: [IndexPath(row: index, section: 0)])
        }
    }
    
    func removeAll() {
        itemsQueue.sync { [weak self] in
            self?.elements.removeAll()
            self?.elements = []
            
            self?.reloadData()
        }
    }
    
    func insert(chat: Chat) {
        itemsQueue.sync { [weak self] in
            self?.elements.insert(chat, at: 0)
            
            self?.insertItems(at: [IndexPath(row: 0, section: 0)])
        }
    }
}

// MARK: Rx

extension Reactive where Base: ChatsCollectionView {
    var selectedChat: Signal<Chat> {
        base.selectedChat.asSignal()
    }
    
    var changedElementsCount: Signal<Int> {
        base.changedElementsCount.asSignal()
    }
}

// MARK: UICollectionViewDelegate

extension ChatsCollectionView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedChat.accept(elements[indexPath.row])
    }
}

// MARK: UICollectionViewDataSource

extension ChatsCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        elements.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = dequeueReusableCell(withReuseIdentifier: String(describing: ChatsCollectionCell.self), for: indexPath) as! ChatsCollectionCell
        cell.setup(chat: elements[indexPath.row])
        return cell
    }    
}
