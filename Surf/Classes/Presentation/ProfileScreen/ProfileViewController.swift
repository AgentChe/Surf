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
    
    private lazy var photosMaker = ProfilePhotosMaker(presentationController: self, delegate: self)
    
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
        
        viewModel
            .removedAllChats()
            .drive(onNext: {
                Toast.notify(with: $0 ? "Profile.RemoveAllChats.Success".localized : "Profile.RemoveAllChats.Failure".localized,
                             style: $0 ? .success : .danger)
            })
            .disposed(by: disposeBag)
        
        viewModel
            .photoDeleted()
            .drive(onNext: {
                guard !$0 else {
                    return
                }
                
                Toast.notify(with: "Profile.DeletedPhoto.Failure".localized, style: .danger)
            })
            .disposed(by: disposeBag)
        
        viewModel
            .photoTakenByDefault()
            .drive(onNext: {
                guard !$0 else {
                    return
                }
                
                Toast.notify(with: "Profile.SetDefaultPhoto.Failure".localized, style: .danger)
            })
            .disposed(by: disposeBag)
        
        Driver
            .merge(viewModel.userPhotoAdded(),
                   viewModel.photoReplaced())
            .drive(onNext: { stub in
                let (success, error) = stub
                
                guard !success, let message = error else {
                    return
                }
                
                Toast.notify(with: message, style: .danger)
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
            viewModel.removeAllChats.accept(Void())
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
    
    func profileTable(selected photo: Photo?) {
        let actionSheet = ProfilePhotosActionSheet().actionSheet(photo: photo) { [unowned self] step in
            switch step {
            case .make:
                self.photosMaker.forMake()
            case .replace(let id):
                self.photosMaker.forReplace(id: id)
            case .setDefault(let id):
                self.viewModel.setDefaultPhoto.accept(id)
            case .delete(let id):
                self.viewModel.deletePhoto.accept(id)
            }
        }
        
        present(actionSheet, animated: true)
    }
}

// MARK: ProfilePhotosMakerDelegate

extension ProfileViewController: ProfilePhotosMakerDelegate {
    func photosMakerForMake(image: UIImage) {
        viewModel.addUserPhoto.accept(image)
    }
    
    func photosMakerForReplace(image: UIImage, id: Int) {
        viewModel.replacePhoto.accept((image, id))
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
