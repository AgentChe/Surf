//
//  RegistrationEmailViewController.swift
//  FAWN
//
//  Created by Andrey Chernyshev on 18/04/2020.
//  Copyright © 2020 Алексей Петров. All rights reserved.
//

import UIKit
import RxSwift

final class RegistrationEmailViewController: UIViewController {
    var registrationEmailView = RegistrationEmailView()
    
    private let viewModel = RegistrationEmailViewModel()
    
    private let disposeBag = DisposeBag()
    
    private var email: String?
    
    override func loadView() {
        super.loadView()
        
        view = registrationEmailView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        AmplitudeAnalytics.shared.log(with: .emailScr)
        
        registrationEmailView.emailTextField.delegate = self
        registrationEmailView.emailTextField.addTarget(self, action: #selector(emailDidChanged), for: .editingChanged)
        
        let registrationEmailViewTapGesture = UITapGestureRecognizer(target: self, action: #selector(tapToHideKeyboard))
        registrationEmailView.addGestureRecognizer(registrationEmailViewTapGesture)
        
        registrationEmailView
            .continueButton.rx.tap
            .subscribe(onNext: { [weak self] in
                AmplitudeAnalytics.shared.log(with: .emailTap)
                
                self?.checkEmailAndContinue()
            })
            .disposed(by: disposeBag)
        
        registrationEmailView
            .termsOfServiceButton.rx.tap
            .subscribe(onNext: {
                guard let url = URL(string: GlobalDefinitions.TermsOfService.termsUrl) else {
                    return
                }
                
                UIApplication.shared.open(url, options: [:])
            })
            .disposed(by: disposeBag)
        
        viewModel
            .loading
            .drive(onNext: { [weak self] isLoading in
                self?.registrationEmailView.continueButton.isHidden = isLoading
                self?.registrationEmailView.emailTextField.isHidden = isLoading
                isLoading ? self?.registrationEmailView.activityIndicator.startAnimating() : self?.registrationEmailView.activityIndicator.stopAnimating()
            })
            .disposed(by: disposeBag)
        
        viewModel
            .step()
            .drive(onNext: { [weak self] step in
                guard let step = step else {
                    NotificationView.notify(with: "NoInternetConnection".localized)
                    return
                }
                
                switch step {
                case .onboarding:
                    self?.goToOnboardingScreen()
                case .confirmCode(let email):
                    self?.goToConfirmCode(with: email)
                }
            })
            .disposed(by: disposeBag)
    }
}

// MARK: Make

extension RegistrationEmailViewController {
    static func make() -> RegistrationEmailViewController {
        let vc = RegistrationEmailViewController()
        vc.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        return vc
    }
}

// MARK: UITextFieldDelegate

extension RegistrationEmailViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        checkEmailAndContinue()
        
        return true
    }
}

// MARK: Private

private extension RegistrationEmailViewController {
    @objc
    func emailDidChanged() {
        registrationEmailView.emailTextField.backgroundColor = UIColor.white
        
        registrationEmailView.invalidateEmailLabel.isHidden = true
    }
    
    @objc
    func tapToHideKeyboard() {
        registrationEmailView.emailTextField.resignFirstResponder()
    }
    
    func checkEmailAndContinue() {
        guard let email = registrationEmailView.emailTextField.text else {
            return
        }
        
        if NSPredicate(format:"SELF MATCHES[c] %@",
                       "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}")
            .evaluate(with: email) {
            tapToHideKeyboard()
            
            viewModel.createUser.accept(email)
        } else {
            registrationEmailView.emailTextField.backgroundColor = UIColor.red.withAlphaComponent(0.2)
            registrationEmailView.invalidateEmailLabel.isHidden = false
        }
    }
    
    func goToOnboardingScreen() {
        UIApplication.shared.keyWindow?.rootViewController = SurfNavigationController(rootViewController: OnboardingViewController.make())
    }
    
    func goToConfirmCode(with email: String) {
        UIApplication.shared.keyWindow?.rootViewController = RegistrationConfirmCodeViewController.make(email: email)
    }
}
