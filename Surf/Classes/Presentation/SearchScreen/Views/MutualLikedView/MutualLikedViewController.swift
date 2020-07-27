//
//  MutualLikedViewController.swift
//  Surf
//
//  Created by Andrey Chernyshev on 27.07.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import UIKit
import RxSwift

final class MutualLikedViewController: UIViewController {
    var mutualView = MutualLikedView()
    
    weak var delegate: MutualLikedViewControllerDelegate?
    
    private let disposeBag = DisposeBag()
    
    override func loadView() {
        super.loadView()
        
        view = mutualView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mutualView
            .sendMessageButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.dismiss(animated: true) {
                    self?.delegate?.sendMessageTapped()
                }
            })
            .disposed(by: disposeBag)
        
        mutualView
            .keepSurfingButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.dismiss(animated: true) {
                    self?.delegate?.keepSurfingTapped()
                }
            })
            .disposed(by: disposeBag)
    }
}

// MARK: Make

extension MutualLikedViewController {
    static func make() -> MutualLikedViewController {
        let vc = MutualLikedViewController()
        vc.modalPresentationStyle = .overCurrentContext
        return vc
    }
}
