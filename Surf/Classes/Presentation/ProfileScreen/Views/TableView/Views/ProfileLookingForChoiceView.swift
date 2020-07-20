//
//  ProfileLookingForChoiceView.swift
//  Surf
//
//  Created by Andrey Chernyshev on 20.07.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import UIKit
import RxSwift

final class ProfileLookingForChoiceView: UIView {
    var on: (([Gender]) -> Void)?
    
    var lookingFor: [Gender] = [] {
        didSet {
            moveCursor()
        }
    }
    
    lazy var girlsButton = makeButton(title: "Profile.ShowMe.Girls".localized)
    lazy var guysButton = makeButton(title: "Profile.ShowMe.Guys".localized)
    lazy var bothButton = makeButton(title: "Profile.ShowMe.Both".localized)
    lazy var leftSeparator = makeSeparatorView()
    lazy var rightSeparator = makeSeparatorView()
    lazy var cursorView = makeCursorView()
    
    var cursorLabel: UILabel?
    
    private let disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
        
        Observable
            .merge(girlsButton.rx.tap.map { [Gender.female] },
                   guysButton.rx.tap.map { [Gender.male] },
                   bothButton.rx.tap.map { [Gender.male, Gender.female] })
            .throttle(RxTimeInterval.milliseconds(500), scheduler: MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] lookingFor in
                self?.lookingFor = lookingFor
                self?.on?(lookingFor)
            })
            .disposed(by: disposeBag)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        moveCursor()
    }
}

// MARK: Private

private extension ProfileLookingForChoiceView {
    func moveCursor() {
        guard let code = GenderMapper.lookingForCode(from: lookingFor) else {
            return
        }
        
        var x: CGFloat!
        var text: String!
        
        switch code {
        case 2:
            x = 2.scale
            text = "Profile.ShowMe.Girls".localized
        case 1:
            x = (frame.width / 2) - 109.scale / 2
            text = "Profile.ShowMe.Guys".localized
        case 3:
            x = frame.width - 2.scale - 109.scale
            text = "Profile.ShowMe.Both".localized
        default:
            return
        }
        
        UIView.animate(withDuration: 0.5, animations: { [weak self] in
            self?.cursorView.frame.origin.x = x
            self?.cursorLabel?.text = text
        })
    }
}

// MARK: Make constraints

private extension ProfileLookingForChoiceView {
    func makeConstraints() {
        [girlsButton, guysButton, bothButton].forEach {
            NSLayoutConstraint.activate([
                $0.widthAnchor.constraint(equalToConstant: 313.scale / 3),
                $0.heightAnchor.constraint(equalToConstant: 28.scale),
                $0.centerYAnchor.constraint(equalTo: centerYAnchor)
            ])
        }
        
        NSLayoutConstraint.activate([
            girlsButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            guysButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            bothButton.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        
        [leftSeparator, rightSeparator].forEach {
            NSLayoutConstraint.activate([
                $0.widthAnchor.constraint(equalToConstant: 1.scale),
                $0.heightAnchor.constraint(equalToConstant: 16.scale),
                $0.centerYAnchor.constraint(equalTo: centerYAnchor)
            ])
        }
        
        NSLayoutConstraint.activate([
            leftSeparator.trailingAnchor.constraint(equalTo: guysButton.leadingAnchor),
            rightSeparator.leadingAnchor.constraint(equalTo: guysButton.trailingAnchor)
        ])
    }
}

// MARK: Lazy initialization

private extension ProfileLookingForChoiceView {
    func makeButton(title: String) -> UIButton {
        let view = UIButton()
        view.setTitle(title, for: .normal)
        view.setTitleColor(.black, for: .normal)
        view.titleLabel?.font = Font.SFProText.regular(size: 14.scale)
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeSeparatorView() -> UIView {
        let view = UIView()
        view.backgroundColor = UIColor.lightGray
        view.layer.cornerRadius = 1.scale
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeCursorView() -> UIView {
        let view = UIView()
        view.frame.size = CGSize(width: 109.scale, height: 28.scale)
        view.frame.origin = CGPoint(x: 2.scale, y: 2.scale)
        view.backgroundColor = .white
        view.layer.cornerRadius = 9.scale
        view.layer.borderWidth = 0.5.scale
        view.layer.borderColor = UIColor.white.withAlphaComponent(0.04).cgColor
        addSubview(view)
        
        let cursorLabel = UILabel()
        cursorLabel.textColor = .black
        cursorLabel.font = Font.SFProText.regular(size: 14.scale)
        cursorLabel.textAlignment = .center
        cursorLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(cursorLabel)
        
        self.cursorLabel = cursorLabel
        
        NSLayoutConstraint.activate([
            cursorLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            cursorLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        return view
    }
}
