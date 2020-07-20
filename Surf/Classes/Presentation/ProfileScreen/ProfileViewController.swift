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
        
        profileView.tableView.actionDelegate = self
        
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

// MARK: ProfileTableActionDelegate

extension ProfileViewController: ProfileTableActionDelegate {
    func profileTable(selected direct: ProfileTableDirection) {
        switch direct {
        case .clearAllHistory:
            break
        case .restorePurchases:
            restorePurchases()
        case .shareSurf:
            share()
        case .contactUs:
            openWeb(with: GlobalDefinitions.TermsOfService.contactUrl)
        case .privacyPolicy:
            openWeb(with: GlobalDefinitions.TermsOfService.policyUrl)
        case .termsOfService:
            openWeb(with: GlobalDefinitions.TermsOfService.termsUrl)
        }
    }
}

// MARK: Private

private extension ProfileViewController {
    func restorePurchases() {
        profileView.activityIndicator.startAnimating()
        
        viewModel
            .restorePurchases()
            .drive(onNext: { [weak self] success in
                self?.profileView.activityIndicator.stopAnimating()

                Toast.notify(with: success ? "Profile.RestorePurchases.Success".localized : "Profile.RestorePurchases.Failure".localized,
                             style: success ? .success : .danger)
            })
            .disposed(by: disposeBag)
    }
    
    func openWeb(with path: String) {
        guard let url = URL(string: path) else {
            return
        }
        
        UIApplication.shared.open(url, options: [:])
    }
    
    func share() {
        guard let url = URL(string: GlobalDefinitions.appStoreUrl) else {
            return
        }
        
        let activityVC = UIActivityViewController(activityItems: [url], applicationActivities: nil)
        
        present(activityVC, animated: true)
    }
}
