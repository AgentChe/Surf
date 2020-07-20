//
//  MainViewController.swift
//  Surf
//
//  Created by Andrey Chernyshev on 19.07.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import UIKit

final class MainViewController: UIViewController {
    var mainView = MainView()
    
    override func loadView() {
        super.loadView()
        
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addPagesController()
    }
}

// MARK: Make

extension MainViewController {
    static func make() -> MainViewController {
        let vc = MainViewController()
        vc.modalPresentationStyle = .fullScreen
        return vc
    }
}

// MARK: ChatsViewControllerDelegate

extension MainViewController: ChatsViewControllerDelegate {
    func newSearchTapped() {
        mainView.tabBarView.selectSearchItem()
    }
}

extension MainViewController: MainPageViewControllerDelegate {
    func changed(page index: Int) {
        if index == 0 {
            mainView.tabBarView.selectSearchItem()
        } else if index == 1 {
            mainView.tabBarView.selectChatsItem()
            navigationController?.pushViewController(ProfileViewController.make(), animated: true)
        }
    }
}

// MARK: Private

private extension MainViewController {
    func addPagesController() {
        let searchVC = SearchViewController.make()
       
        let chatsVC = ChatsViewController.make()
        chatsVC.delegate = self
        
        let pageVC = MainPageController.make(viewControllers: [searchVC, chatsVC])
        pageVC.pageControllerDelegate = self
        addChild(pageVC)
        
        pageVC.view.translatesAutoresizingMaskIntoConstraints = false
        
        mainView.screensContainerView.addSubview(pageVC.view)
        
        NSLayoutConstraint.activate([
            pageVC.view.leadingAnchor.constraint(equalTo: mainView.screensContainerView.leadingAnchor),
            pageVC.view.trailingAnchor.constraint(equalTo: mainView.screensContainerView.trailingAnchor),
            pageVC.view.topAnchor.constraint(equalTo: mainView.screensContainerView.topAnchor),
            pageVC.view.bottomAnchor.constraint(equalTo: mainView.screensContainerView.bottomAnchor)
        ])
        
        mainView.tabBarView.delegate = pageVC
    }
}
