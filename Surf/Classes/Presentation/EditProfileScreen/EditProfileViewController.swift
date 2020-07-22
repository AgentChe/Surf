//
//  EditProfileViewController.swift
//  Surf
//
//  Created by Andrey Chernyshev on 22.07.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class EditProfileViewController: UIViewController {
    var editProfileView = EditProfileView()
    
    private let viewModel = EditProfileViewModel()
    
    private let disposeBag = DisposeBag()
    
    private lazy var photosMaker = ProfilePhotosMaker(presentationController: self, delegate: self)
    
    override func loadView() {
        super.loadView()
        
        view = editProfileView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addNavigationItem()
        
        editProfileView.tableView.actionDelegate = self
        
        viewModel
            .activityIndicator
            .drive(onNext: { [weak self] isLoading in
                isLoading ? self?.editProfileView.activityIndicator.startAnimating() : self?.editProfileView.activityIndicator.stopAnimating()
            })
            .disposed(by: disposeBag)
        
        viewModel
            .sections()
            .drive(onNext: { [weak self] sections in
                self?.editProfileView.tableView.setup(sections: sections)
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
        
        viewModel
            .accountDeleted()
            .drive(onNext: { [weak self] success in
                if success {
                    self?.goToWelcomeScreen()
                } else {
                    Toast.notify(with: "EditProfile.DeleteAccount.Failure".localized, style: .danger)
                }
            })
            .disposed(by: disposeBag)
        
        viewModel
            .changedApplied()
            .drive(onNext: {
                guard !$0 else {
                    return
                }
                
                Toast.notify(with: "EditProfile.SaveChanges.Failure".localized, style: .danger)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: Make 

extension EditProfileViewController {
    static func make() -> EditProfileViewController {
        EditProfileViewController()
    }
}

// MARK: EditProfileTableActionDelegate

extension EditProfileViewController: EditProfileTableActionDelegate {
    func editProfileTable(selected photo: Photo?) {
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
    
    func editProfileTableDeleteTapped() {
        confirmDeletingAccount()
    }
}

// MARK: ProfilePhotosMakerDelegate

extension EditProfileViewController: ProfilePhotosMakerDelegate {
    func photosMakerForMake(image: UIImage) {
        viewModel.addUserPhoto.accept(image)
    }
    
    func photosMakerForReplace(image: UIImage, id: Int) {
        viewModel.replacePhoto.accept((image, id))
    }
}

// MARK: Private

private extension EditProfileViewController {
    func confirmDeletingAccount() {
        let alert = EditProfileConfirmDeletingAlert().alert { [weak self] confirm in
            guard confirm else {
                return
            }
            
            self?.viewModel.deleteAccount.accept(Void())
        }
        present(alert, animated: true)
    }
    
    func addNavigationItem() {
        navigationItem.title = "EditProfile.Edit".localized
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "EditProfile.Done".localized, style: .plain, target: self, action: #selector(confirmChanges))
    }
    
    @objc
    func confirmChanges() {
        view.endEditing(true)
        
        viewModel.applyChanges.accept(Void())
    }
    
    func goToWelcomeScreen() {
        UIApplication.shared.keyWindow?.rootViewController = SurfNavigationController(rootViewController: WelcomeViewController.make())
    }
}
