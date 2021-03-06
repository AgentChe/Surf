//
//  EditProfileView.swift
//  Surf
//
//  Created by Andrey Chernyshev on 22.07.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import UIKit
import RxSwift

final class EditProfileView: UIView {
    lazy var tableView = makeTableView()
    lazy var activityIndicator = makeActivityIndicator()
    
    private let disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
        
        rx.keyboardHeight
            .subscribe(onNext: { [weak self] keyboardHeight in
                self?.tableView.contentInset.bottom = keyboardHeight + (ScreenSize.isIphoneXFamily ? 10.scale : 30.scale)
            })
            .disposed(by: disposeBag)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private

private extension EditProfileView {
    @objc
    func hideKeyboard() {
        endEditing(true)
    }
}

// MARK: Make constraints

private extension EditProfileView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            activityIndicator.leadingAnchor.constraint(equalTo: leadingAnchor),
            activityIndicator.trailingAnchor.constraint(equalTo: trailingAnchor),
            activityIndicator.topAnchor.constraint(equalTo: topAnchor),
            activityIndicator.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

// MARK: Lazy initialization

private extension EditProfileView {
    func makeTableView() -> EditProfileTableView {
        let view = EditProfileTableView()
        view.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: ScreenSize.isIphoneXFamily ? 10.scale : 30.scale, right: 0)
        view.backgroundColor = UIColor(red: 240 / 255, green: 240 / 255, blue: 242 / 255, alpha: 1)
        view.separatorStyle = .none
        view.allowsSelection = false
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
        
        return view
    }
    
    func makeActivityIndicator() -> FullScreenPreloader {
        let view = FullScreenPreloader()
        view.stopAnimating()
        view.isUserInteractionEnabled = false
        view.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}

