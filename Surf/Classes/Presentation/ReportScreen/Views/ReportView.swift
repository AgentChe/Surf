//
//  ReportView.swift
//  Surf
//
//  Created by Andrey Chernyshev on 28.07.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import UIKit
import RxSwift

final class ReportView: UIView {
    lazy var whatExactlyView = makeWhatExactlyView()
    lazy var preloaderView = makePreloaderView()
    lazy var gotchaView = makeGotchaView()
    
    var whatExactlyViewBottomConstraint: NSLayoutConstraint!
    
    private let disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.black.withAlphaComponent(0.3)
        
        makeConstraints()
        
        rx.keyboardHeight
            .subscribe(onNext: { [weak self] keyboardHeight in
                self?.whatExactlyViewBottomConstraint.constant = -(keyboardHeight + 20.scale)
            })
            .disposed(by: disposeBag)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Make constraints

private extension ReportView {
    func makeConstraints() {
        whatExactlyViewBottomConstraint = whatExactlyView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20.scale)
        NSLayoutConstraint.activate([
            whatExactlyView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            whatExactlyView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            whatExactlyView.heightAnchor.constraint(equalToConstant: 212.scale),
            whatExactlyViewBottomConstraint
        ])
        
        NSLayoutConstraint.activate([
            preloaderView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 38.scale),
            preloaderView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -38.scale),
            preloaderView.heightAnchor.constraint(equalToConstant: 150.scale),
            preloaderView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            gotchaView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 38.scale),
            gotchaView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -38.scale),
            gotchaView.heightAnchor.constraint(equalToConstant: 150.scale),
            gotchaView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}

// MARK: Lazy initialization

private extension ReportView {
    func makeWhatExactlyView() -> ReportWhatExactlyView {
        let view = ReportWhatExactlyView()
        view.backgroundColor = UIColor(red: 230 / 255, green: 230 / 255, blue: 230 / 255, alpha: 1)
        view.layer.cornerRadius = 16.scale
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makePreloaderView() -> ReportPreloaderView {
        let view = ReportPreloaderView()
        view.backgroundColor = UIColor(red: 230 / 255, green: 230 / 255, blue: 230 / 255, alpha: 1)
        view.layer.cornerRadius = 16.scale
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeGotchaView() -> ReportGotchaView {
        let view = ReportGotchaView()
        view.backgroundColor = UIColor(red: 230 / 255, green: 230 / 255, blue: 230 / 255, alpha: 1)
        view.layer.cornerRadius = 16.scale
        view.isHidden = true 
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
