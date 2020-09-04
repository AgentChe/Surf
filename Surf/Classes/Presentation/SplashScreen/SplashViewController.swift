//
//  SplashViewController.swift
//  FAWN
//
//  Created by Andrey Chernyshev on 22/04/2020.
//  Copyright © 2020 Алексей Петров. All rights reserved.
//

import UIKit
import RxSwift

final class SplashViewController: UIViewController {
    lazy var label = makeLabel()
    lazy var bannedView = makeBannedView()
    
    private let viewModel = SplashViewModel()
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(red: 20 / 255, green: 22 / 255, blue: 21 / 255, alpha: 1)
        
        makeConstraints()
        
        viewModel
            .step()
            .delay(RxTimeInterval.seconds(1))
            .drive(onNext: { [weak self] step in
                guard let step = step else {
                    Toast.notify(with: "NoInternetConnection".localized, style: .danger)
                    return
                }

                switch step {
                case .banned:
                    self?.bannedView.isHidden = false
                case .main:
                    self?.goToMainScreen()
                case .registration:
                    self?.goToWelcomeScreen()
                }
            })
            .disposed(by: disposeBag)
    }
}

// MARK: Make

extension SplashViewController {
    static func make() -> UIViewController {
        SplashViewController(nibName: nil, bundle: nil)
    }
}

// MARK: Private

private extension SplashViewController {
    func goToMainScreen() {
        UIApplication.shared.keyWindow?.rootViewController = SurfNavigationController(rootViewController: MainViewController.make())
    }
    
    func goToWelcomeScreen() {
        UIApplication.shared.keyWindow?.rootViewController = SurfNavigationController(rootViewController: WelcomeViewController.make())
    }
}

// MARK: Make constrainst

private extension SplashViewController {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16.scale),
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16.scale),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            bannedView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bannedView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bannedView.topAnchor.constraint(equalTo: view.topAnchor),
            bannedView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

// MARK: Lazy initialization

private extension SplashViewController {
    func makeLabel() -> UILabel {
        let view = UILabel()
        view.numberOfLines = 1
        view.textAlignment = .center
        view.text = "Splash.ASTRA".localized
        view.font = Font.OpenSans.bold(size: 66)
        view.textColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(view)
        return view
    }
    
    func makeBannedView() -> BannedView {
        let view = BannedView()
        view.backgroundColor = .white
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(view)
        return view
    }
}
