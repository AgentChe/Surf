//
//  OnboardingShowMeView.swift
//  Surf
//
//  Created by Andrey Chernyshev on 15.07.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import UIKit
import RxSwift

final class OnboardingShowMeToGendersView: UIView {
    var onNext: (([Gender]) -> Void)?
    
    lazy var label = makeLabel()
    lazy var scrollView = makeScrollView()
    lazy var maleButton = makeMaleButton()
    lazy var femaleButton = makeFemaleButton()
    lazy var maleFemaleButton = makeMaleFemaleButton()
    
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

private extension OnboardingShowMeToGendersView {
    func bind() {
        Observable
            .merge(maleButton.rx.tap.map { [Gender.male] },
                   femaleButton.rx.tap.map { [Gender.female] },
                   maleFemaleButton.rx.tap.map { [Gender.male, Gender.female] })
            .subscribe(onNext: { [weak self] genders in
                self?.onNext?(genders)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: Make constraints

private extension OnboardingShowMeToGendersView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: centerXAnchor),
            label.topAnchor.constraint(equalTo: topAnchor, constant: ScreenSize.isIphoneXFamily ? 309.scale : 209.scale)
        ])
        
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.heightAnchor.constraint(equalToConstant: 120.scale),
            scrollView.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 32.scale)
        ])
        
        NSLayoutConstraint.activate([
            maleButton.widthAnchor.constraint(equalToConstant: 120.scale),
            maleButton.heightAnchor.constraint(equalToConstant: 120.scale),
            maleButton.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 40.scale),
            maleButton.topAnchor.constraint(equalTo: scrollView.topAnchor),
            maleButton.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            femaleButton.widthAnchor.constraint(equalToConstant: 120.scale),
            femaleButton.heightAnchor.constraint(equalToConstant: 120.scale),
            femaleButton.leadingAnchor.constraint(equalTo: maleButton.trailingAnchor, constant: 24.scale),
            femaleButton.topAnchor.constraint(equalTo: scrollView.topAnchor),
            femaleButton.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            maleFemaleButton.widthAnchor.constraint(equalToConstant: 221.scale),
            maleFemaleButton.heightAnchor.constraint(equalToConstant: 120.scale),
            maleFemaleButton.leadingAnchor.constraint(equalTo: femaleButton.trailingAnchor, constant: 24.scale),
            maleFemaleButton.topAnchor.constraint(equalTo: scrollView.topAnchor),
            maleFemaleButton.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            maleFemaleButton.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -40.scale)
        ])
    }
}

// MARK: Lazy initialization

private extension OnboardingShowMeToGendersView {
    func makeLabel() -> UILabel {
        let view = UILabel()
        view.textColor = .black
        view.font = Font.OpenSans.bold(size: 34.scale)
        view.textAlignment = .center
        view.text = "Onboarding.ShowMe".localized
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeScrollView() -> UIScrollView {
        let view = UIScrollView()
        view.contentSize = CGSize(width: 589.scale, height: 120.scale)
        view.showsHorizontalScrollIndicator = false
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
        scrollView.addSubview(view)
        return view
    }
    
    func makeFemaleButton() -> UIButton {
        let view = UIButton()
        view.backgroundColor = UIColor(red: 239 / 255, green: 239 / 255, blue: 244 / 255, alpha: 1)
        view.setImage(UIImage(named: "Onboarding.Female"), for: .normal)
        view.layer.cornerRadius = 60.scale
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(view)
        return view
    }
    
    func makeMaleFemaleButton() -> UIButton {
        let view = UIButton()
        view.backgroundColor = UIColor(red: 239 / 255, green: 239 / 255, blue: 244 / 255, alpha: 1)
        view.setImage(UIImage(named: "Onboarding.MaleFemale"), for: .normal)
        view.layer.cornerRadius = 60.scale
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(view)
        return view
    }
}
