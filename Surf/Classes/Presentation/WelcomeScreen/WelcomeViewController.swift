//
//  RegistrationViewController.swift
//  FAWN
//
//  Created by Алексей Петров on 16/03/2019.
//  Copyright © 2019 Алексей Петров. All rights reserved.
//

import UIKit
import RxSwift

final class WelcomeViewController: UIViewController {
    var welcomeView = WelcomeView()
    
    private let viewModel = WelcomeViewModel()
    
    private let disposeBag = DisposeBag()
    
    override func loadView() {
        super.loadView()
        
        view = welcomeView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        AmplitudeAnalytics.shared.log(with: .loginScr)
        
        viewModel.authWithFBComplete()
            .drive(onNext: { [weak self] new in
                guard let isNew = new else {
                    NotificationView.notify(with: "NoInternetConnection".localized)
                    return
                }
                
                isNew ? self?.goToOnboardingScreen() : self?.goToMainScreen()
            })
            .disposed(by: disposeBag)
        
        welcomeView
            .facebookButton.rx.tap
            .subscribe(onNext: { [weak self] in
                AmplitudeAnalytics.shared.log(with: .loginTap("facebook_login"))
                
                self?.viewModel.authWithFB.accept(Void())
            })
            .disposed(by: disposeBag)
        
        welcomeView
            .emailButton.rx.tap
            .subscribe(onNext: { [weak self] in
                AmplitudeAnalytics.shared.log(with: .loginTap("email_login"))
                
                self?.goToRegistrationEmailScreen()
            })
            .disposed(by: disposeBag)
    }
}

// MARK: Make

extension WelcomeViewController {
    static func make() -> WelcomeViewController {
        WelcomeViewController(nibName: nil, bundle: nil)
    }
}

// MARK: Private

private extension WelcomeViewController {
    func goToMainScreen() {
        UIApplication.shared.keyWindow?.rootViewController = SurfNavigationController(rootViewController: MainViewController.make())
    }
    
    func goToOnboardingScreen() {
        UIApplication.shared.keyWindow?.rootViewController = SurfNavigationController(rootViewController: OnboardingViewController.make())
    }
    
    func goToRegistrationEmailScreen() {
        navigationController?.pushViewController(RegistrationEmailViewController.make(), animated: true)
    }
}