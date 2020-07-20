//
//  ProfileViewController.swift
//  FAWN
//
//  Created by Алексей Петров on 08/04/2019.
//  Copyright © 2019 Алексей Петров. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

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
            .activityIndicator
            .drive(onNext: { [weak self] isLoading in
                isLoading ? self?.profileView.activityIndicator.startAnimating() : self?.profileView.activityIndicator.stopAnimating()
            })
            .disposed(by: disposeBag)
        
        viewModel
            .sections()
            .drive(onNext: { [weak self] sections in
                self?.profileView.tableView.setup(sections: sections)
            })
            .disposed(by: disposeBag)
        
        viewModel
            .restoredPurchases()
            .drive(onNext: {
                Toast.notify(with: $0 ? "Profile.RestorePurchases.Success".localized : "Profile.RestorePurchases.Failure".localized,
                             style: $0 ? .success : .danger)
            })
            .disposed(by: disposeBag)
        
        viewModel
            .updatedLookingFor()
            .drive(onNext: {
                guard !$0 else {
                    return
                }
                
                Toast.notify(with: "Profile.UpdateLookingFor.Failure".localized, style: .danger)
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
            viewModel.restorePurchases.accept(Void())
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
    
    func profileTable(changed lookingFor: [Gender], minAge: Int, maxAge: Int) {
        viewModel.updateLookingFor.accept((lookingFor, minAge, maxAge))
    }
}

// MARK: Private

private extension ProfileViewController {
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
