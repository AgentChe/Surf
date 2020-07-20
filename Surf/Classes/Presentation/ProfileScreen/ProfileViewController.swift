//
//  ProfileViewController.swift
//  FAWN
//
//  Created by Алексей Петров on 08/04/2019.
//  Copyright © 2019 Алексей Петров. All rights reserved.
//

import UIKit
import RxSwift

final class ProfileViewController: UIViewController {
    var profileView = ProfileView()
    
    private let viewModel = ProfileViewModel()
    
    private let disposeBag = DisposeBag()
    
    override func loadView() {
        super.loadView()
        
        view = profileView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel
            .sections()
            .drive(onNext: { [weak self] sections in
                self?.profileView.tableView.setup(sections: sections)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: Make

extension ProfileViewController {
    static func make() -> ProfileViewController {
        ProfileViewController()
    }
}
