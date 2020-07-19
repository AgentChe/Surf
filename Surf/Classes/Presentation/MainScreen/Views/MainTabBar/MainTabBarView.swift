//
//  MainTabBarView.swift
//  Surf
//
//  Created by Andrey Chernyshev on 19.07.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import UIKit

final class MainTabBarView: UIView {
    lazy var searchItem = makeSearchItem()
    lazy var chatsItem = makeChatsItem()
    
    weak var delegate: MainTabBarViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc
    func selectSearchItem() {
        searchItem.isSelected = true
        chatsItem.isSelected = false
        
        delegate?.searchSelected?()
    }
    
    @objc
    func selectChatsItem() {
        searchItem.isSelected = false
        chatsItem.isSelected = true
        
        delegate?.chatsSelected?()
    }
}

// MARK: Make constraints

private extension MainTabBarView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            searchItem.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 72.scale),
            searchItem.topAnchor.constraint(equalTo: topAnchor, constant: 16.scale),
            searchItem.heightAnchor.constraint(equalToConstant: 36.scale)
        ])
        
        NSLayoutConstraint.activate([
            chatsItem.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -72.scale),
            chatsItem.topAnchor.constraint(equalTo: topAnchor, constant: 16.scale),
            chatsItem.heightAnchor.constraint(equalToConstant: 36.scale)
        ])
    }
}

// MARK: Lazy initialization

private extension MainTabBarView {
    func makeSearchItem() -> MainTabBarItem {
        let view = MainTabBarItem()
        view.selectedImage = UIImage(named: "MainTabBar.Search.Selected")
        view.unselectedImage = UIImage(named: "MainTabBar.Search.Unselected")
        view.label.text = "MainTabBar.Search".localized
        view.isSelected = true
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(selectSearchItem))
        view.addGestureRecognizer(tapGesture)
        
        return view
    }
    
    func makeChatsItem() -> MainTabBarItem {
        let view = MainTabBarItem()
        view.selectedImage = UIImage(named: "MainTabBar.Chats.Selected")
        view.unselectedImage = UIImage(named: "MainTabBar.Chats.Unselected")
        view.label.text = "MainTabBar.Chats".localized
        view.isSelected = false
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(selectChatsItem))
        view.addGestureRecognizer(tapGesture)
        
        return view
    }
}
