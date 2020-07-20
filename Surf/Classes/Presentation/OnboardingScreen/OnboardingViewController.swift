//
//  OnboardingViewController.swift
//  FAWN
//
//  Created by Andrey Chernyshev on 18/04/2020.
//  Copyright © 2020 Алексей Петров. All rights reserved.
//

import UIKit
import RxSwift

final class OnboardingViewController: UIViewController {
    var onboardingView = OnboardingView()
    
    private let viewModel = OnboardingViewModel()
    
    private let disposeBag = DisposeBag()
    
    override func loadView() {
        super.loadView()
        
        view = onboardingView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigate()
        
        viewModel
            .step()
            .drive(onNext: { [weak self] step in
                guard let step = step else {
                    Toast.notify(with: "NoInternetConnection".localized, style: .danger)
                    return
                }
                
                switch step {
                case .main:
                    self?.goToMainScreen()
                }
            })
            .disposed(by: disposeBag)
    }
}

// MARK: Make

extension OnboardingViewController {
    static func make() -> OnboardingViewController {
        OnboardingViewController(nibName: nil, bundle: .main)
    }
}

// MARK: Private

private extension OnboardingViewController {
    func navigate() {
        move(on: onboardingView.myGenderView)
        
        onboardingView.myGenderView.onNext = { [unowned self] gender in
            self.viewModel.myGender.accept(gender)
            
            self.move(on: self.onboardingView.showMeToGendersView, from: self.onboardingView.myGenderView)
        }
        
        onboardingView.showMeToGendersView.onNext = { [unowned self] genders in
            self.viewModel.showMeToGenders.accept(genders)
            
            self.move(on: self.onboardingView.birthdayView, from: self.onboardingView.showMeToGendersView)
        }
        
        onboardingView.birthdayView.onNext = { [unowned self] date in
            self.viewModel.birthdate.accept(date)
            
            self.move(on: self.onboardingView.photosView, from: self.onboardingView.birthdayView)
        }
        
        onboardingView.photosView.onNext = { [unowned self] urls in
            self.viewModel.photoUrls.accept(urls)
            
            self.move(on: self.onboardingView.nameView, from: self.onboardingView.photosView)
            self.onboardingView.nameView.setup()
        }
        
        onboardingView.nameView.onNext = { [unowned self] name in
            self.viewModel.name.accept(name)
            
            guard
                let name = self.viewModel.name.value,
                let birthdate = self.viewModel.birthdate.value,
                let photos = self.viewModel.photoUrls.value
            else {
                return
            }
            
            self.move(on: self.onboardingView.welcomeView, from: self.onboardingView.nameView)
            self.onboardingView.welcomeView.setup(name: name,
                                                  birthdate: birthdate,
                                                  photos: photos)
        }
        
        onboardingView.welcomeView.onNext = { [unowned self] in
            self.move(on: self.onboardingView.notificationsView, from: self.onboardingView.welcomeView)
            
            self.onboardingView.notificationsView.setup()
        }
        
        onboardingView.notificationsView.onNext = { [unowned self] token in
            self.viewModel.pushNotificationsToken.accept(token)
            self.onboardingView.notificationsView.isHidden = true
            
            self.viewModel.onboardingPassed.accept(Void())
        }
    }
    
    func move(on view: UIView, from previous: UIView? = nil) {
        previous?.isHidden = true
        view.isHidden = false
        
        NSLayoutConstraint.activate([
            view.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            view.topAnchor.constraint(equalTo: self.view.topAnchor),
            view.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
    }
    
    func goToMainScreen() {
        UIApplication.shared.keyWindow?.rootViewController = SurfNavigationController(rootViewController: MainViewController.make())
    }
}
