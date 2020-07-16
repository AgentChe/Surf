//
//  OnboardingBirthdayView.swift
//  FAWN
//
//  Created by Andrey Chernyshev on 19/04/2020.
//  Copyright © 2020 Алексей Петров. All rights reserved.
//

import UIKit
import RxSwift

final class OnboardingBirthdayView: UIView {
    var onNext: ((Date) -> Void)?
    
    lazy var titleLabel = makeTitleLabel()
    lazy var subTitleLabel = makeSubTitleLabel()
    lazy var datePicker = makeDatePicker()
    lazy var continueButton = makeContinueButton()
    
    private let disposebag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private

private extension OnboardingBirthdayView {
    func bind() {
        continueButton.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let date = self?.datePicker.date else {
                    return
                }
                
                self?.onNext?(date)
            })
            .disposed(by: disposebag)
    }
}

// MARK: Make constraints

private extension OnboardingBirthdayView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 92.scale),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 36.scale),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -36.scale)
        ])
        
        NSLayoutConstraint.activate([
            subTitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 32.scale),
            subTitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 36.scale),
            subTitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -36.scale)
        ])
        
        NSLayoutConstraint.activate([
            datePicker.topAnchor.constraint(equalTo: subTitleLabel.bottomAnchor, constant: 40.scale),
            datePicker.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 36.scale),
            datePicker.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -36.scale),
            datePicker.heightAnchor.constraint(equalToConstant: 216.scale)
        ])
        
        NSLayoutConstraint.activate([
            continueButton.topAnchor.constraint(equalTo: datePicker.bottomAnchor, constant: 32.scale),
            continueButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40.scale),
            continueButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40.scale),
            continueButton.heightAnchor.constraint(equalToConstant: 56.scale)
        ])
    }
}

// MARK: Lazy initialization

private extension OnboardingBirthdayView {
    func makeTitleLabel() -> UILabel {
        let view = UILabel()
        view.font = Font.OpenSans.bold(size: 34.scale)
        view.textColor = .black
        view.numberOfLines = 1
        view.textAlignment = .center
        view.text = "Onboarding.IWasBornOn".localized
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
        
    func makeSubTitleLabel() -> UILabel {
        let view = UILabel()
        view.font = Font.OpenSans.regular(size: 20.scale)
        view.textColor = .black
        view.numberOfLines = 0
        view.textAlignment = .center
        view.text = "Onboarding.YouMustBe18AndOver".localized
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
        
    func makeDatePicker() -> UIDatePicker {
        let view = UIDatePicker()
        view.maximumDate = Calendar.current.date(byAdding: .year, value: -18, to: Date())
        view.minimumDate = Calendar.current.date(byAdding: .year, value: -80, to: Date())
        view.setValue(UIColor.black, forKeyPath: "textColor")
        view.datePickerMode = .countDownTimer
        view.datePickerMode = .date
        view.timeZone = NSTimeZone.local
        view.date = Calendar.current.date(byAdding: .year, value: -20, to: Date()) ?? Date()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
        
    func makeContinueButton() -> UIButton {
        let view = UIButton()
        view.titleLabel?.font = Font.OpenSans.semibold(size: 17.scale)
        view.setTitleColor(.white, for: .normal)
        view.setTitle("Onboarding.Continue".localized, for: .normal)
        view.layer.cornerRadius = 28.scale
        view.backgroundColor = UIColor(red: 86 / 255, green: 86 / 255, blue: 214 / 255, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
