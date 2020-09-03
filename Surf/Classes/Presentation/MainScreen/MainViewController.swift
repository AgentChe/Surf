//
//  MainViewController.swift
//  Surf
//
//  Created by Andrey Chernyshev on 19.07.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import UIKit
import RxSwift

final class MainViewController: UIViewController {
    var mainView = MainView()
    
    private let viewModel = MainViewModel()
    
    private let disposeBag = DisposeBag()
    
    override func loadView() {
        super.loadView()
        
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainView.collectionView.mainCollectionDelegate = self 
        
        viewModel
            .elements()
            .drive(onNext: { [weak self] elements in
                self?.mainView.collectionView.setup(elements: elements)
            })
            .disposed(by: disposeBag)
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

// MARK: MainCollectionViewDelegate

extension MainViewController: MainCollectionViewDelegate {
    func mainCollectionViewDidDirectTapped(element: MainCollectionDirectElement) {
        switch element.direct {
        case .horoscope:
            let vc = HoroscopeViewController.make()
            navigationController?.pushViewController(vc, animated: true)
        case .search:
            let vc = SearchViewController.make()
            vc.delegate = self
            navigationController?.pushViewController(vc, animated: true)
        case .chats:
            let vc = ChatsViewController.make()
            vc.delegate = self
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

// MARK: ChatsViewControllerDelegate

extension MainViewController: ChatsViewControllerDelegate {
    func newSearchTapped() {
        navigationController?.popViewController(animated: false)
        
        let vc = SearchViewController.make()
        vc.delegate = self
        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: SearchViewControllerDelegate

extension MainViewController: SearchViewControllerDelegate {
    func searchViewControllerSendMessageTapped() {
        navigationController?.popViewController(animated: false)
        
        let vc = ChatsViewController.make()
        vc.delegate = self
        navigationController?.pushViewController(vc, animated: true)
    }
}
