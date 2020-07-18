//
//  RegistrationConfirmCodeViewController.swift
//  FAWN
//
//  Created by Andrey Chernyshev on 18/04/2020.
//  Copyright © 2020 Алексей Петров. All rights reserved.
//

import UIKit
import RxSwift

final class ConfirmCodeViewController: UIViewController {
    var confirmCodeView = ConfirmCodeView()
    
    private let viewModel = ConfirmCodeViewModel()
    
    private let disposeBag = DisposeBag()
    
    private var bundle: Bundle!
    
    private var code = ""
    private var timer: Timer?
    
    override func loadView() {
        super.loadView()
        
        view = confirmCodeView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        AmplitudeAnalytics.shared.log(with: .codeScr)
        
        confirmCodeView.codeTextFields.forEach {
            $0.delegate = self
        }
        
        blockSendNewCode(block: true)
        
        confirmCodeView.setup(email: bundle.email)
        
        confirmCodeView
            .sendNewCodeButton.rx.tap
            .subscribe(onNext: { [unowned self] in
                AmplitudeAnalytics.shared.log(with: .codeTap("send_new_code"))
                
                self.blockSendNewCode(block: true)
                
                self.viewModel.requireCode.accept(self.bundle.email)
            })
            .disposed(by: disposeBag)
        
        viewModel
            .step()
            .drive(onNext: { [weak self] step in
                guard let step = step else {
                    self?.confirmCodeView.codeIncorrectView.isHidden = false
                    self?.confirmCodeView.placeholderTitleView.isHidden = true 
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

extension ConfirmCodeViewController {
    struct Bundle {
        let email: String
    }
    
    static func make(bundle: Bundle) -> ConfirmCodeViewController {
        let vc = ConfirmCodeViewController()
        vc.bundle = bundle
        return vc
    }
}

// MARK: UITextFieldDelegate

extension ConfirmCodeViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        guard textField.text?.isEmpty == false else {
            return true
        }
        
        clearCodeFields()
        
        confirmCodeView.codeTextFields[0].becomeFirstResponder()
        
        return false
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        confirmCodeView.placeholderTitleView.isHidden = false
        confirmCodeView.codeIncorrectView.isHidden = true
        
        if textField == confirmCodeView.codeTextFields[0] {
            clearCodeFields()
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string == "" {
            clearCodeFields()
            
            confirmCodeView.codeTextFields[0].becomeFirstResponder()
            
            return false
        }
        
        textField.text = string
        textField.sendActions(for: .editingChanged)
        
        guard let currentIndex = confirmCodeView.codeTextFields.firstIndex(of: textField) else {
            return false
        }
        
        let isLast = (currentIndex + 1) == confirmCodeView.codeTextFields.count
        
        if isLast {
            confirmCodeView.codeTextFields.forEach {
                $0.resignFirstResponder()
            }
            
            confirmCode()
        } else {
            let nextTextField = confirmCodeView.codeTextFields[currentIndex + 1]
            nextTextField.becomeFirstResponder()
        }
        
        return false
    }
}

// MARK: Private

private extension ConfirmCodeViewController {
    func confirmCode() {
        let code = confirmCodeView
            .codeTextFields
            .compactMap { $0.text }
            .reduce("") { $0 + $1 }
            
        guard code.count == 5 else {
            return
        }
        
        viewModel.confirmCode.accept((bundle.email, code))
    }
    
    func clearCodeFields() {
        confirmCodeView.codeTextFields.forEach {
            $0.text = ""
            $0.sendActions(for: .editingChanged)
        }
    }
    
    func blockSendNewCode(block: Bool) {
        confirmCodeView.sendNewCodeButton.isUserInteractionEnabled = !block
        confirmCodeView.sendNewCodeButton.alpha = block ? 0.5 : 1
        
        timer?.invalidate()
        
        if block {
            timer = Timer.scheduledTimer(withTimeInterval: 25, repeats: false) { [weak self] _ in
                self?.blockSendNewCode(block: false)
            }
        }
    }
    
    func goToMainScreen() {
        UIApplication.shared.keyWindow?.rootViewController = SurfNavigationController(rootViewController: MainViewController.make())
    }
}
