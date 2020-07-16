//
//  OnboardingMyGenderView.swift
//  Surf
//
//  Created by Andrey Chernyshev on 14.07.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import UIKit
import RxSwift

final class OnboardingMyGenderView: UIView {
    var onNext: ((Gender) -> Void)?
    
    lazy var label = makeLabel()
    lazy var maleButton = makeMaleButton()
    lazy var femaleButton = makeFemaleButton()
    
    private let disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Make constraints

private extension OnboardingMyGenderView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: centerXAnchor),
            label.topAnchor.constraint(equalTo: topAnchor, constant: ScreenSize.isIphoneXFamily ? 309.scale : 209.scale)
        ])
        
        NSLayoutConstraint.activate([
            maleButton.widthAnchor.constraint(equalToConstant: 120.scale),
            maleButton.heightAnchor.constraint(equalToConstant: 120.scale),
            maleButton.trailingAnchor.constraint(equalTo: centerXAnchor, constant: -12.scale),
            maleButton.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 32.scale)
        ])
        
        NSLayoutConstraint.activate([
            femaleButton.widthAnchor.constraint(equalToConstant: 120.scale),
            femaleButton.heightAnchor.constraint(equalToConstant: 120.scale),
            femaleButton.leadingAnchor.constraint(equalTo: centerXAnchor, constant: 12.scale),
            femaleButton.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 32.scale)
        ])
    }
}

// MARK: Private

private extension OnboardingMyGenderView {
    func bind() {
        Observable
            .merge(maleButton.rx.tap.map { Gender.male },
                   femaleButton.rx.tap.map { Gender.female })
            .take(1)
            .subscribe(onNext: { [weak self] gender in
                self?.onNext?(gender)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: Lazy initialization

private extension OnboardingMyGenderView {
    func makeLabel() -> UILabel {
        let view = UILabel()
        view.textColor = .black
        view.font = Font.OpenSans.bold(size: 34.scale)
        view.textAlignment = .center
        view.text = "Onboarding.I'Am".localized
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view 
    }
    
    func makeMaleButton() -> UIButton {
        let view = UIButton()
        view.backgroundColor = UIColor(red: 239 / 255, green: 239 / 255, blue: 244 / 255, alpha: 1)
        view.setImage(UIImage(named: "Onboarding.Male"), for: .normal)
        view.layer.cornerRadius = 60.scale
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeFemaleButton() -> UIButton {
        let view = UIButton()
        view.backgroundColor = UIColor(red: 239 / 255, green: 239 / 255, blue: 244 / 255, alpha: 1)
        view.setImage(UIImage(named: "Onboarding.Female"), for: .normal)
        view.layer.cornerRadius = 60.scale
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
