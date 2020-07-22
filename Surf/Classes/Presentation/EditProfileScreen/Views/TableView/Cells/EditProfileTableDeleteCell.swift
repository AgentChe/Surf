//
//  EditProfileTableDeleteCell.swift
//  Surf
//
//  Created by Andrey Chernyshev on 22.07.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import UIKit

final class EditProfileTableDeleteCell: UITableViewCell {
    weak var actionDelegate: EditProfileTableActionDelegate?
    
    lazy var deleteButton = makeDeleteButton()
    lazy var authInfoLabel = makeAuthInfoLabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = UIColor(red: 240 / 255, green: 240 / 255, blue: 242 / 255, alpha: 1)
        
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(email: String) {
        authInfoLabel.text = String(format: "EditProfile.AuthInfo".localized, email)
    }
}

// MARK: Private

private extension EditProfileTableDeleteCell {
    @objc
    func tapped() {
        actionDelegate?.editProfileTableDeleteTapped()
    }
}

// MARK: Make constraints

private extension EditProfileTableDeleteCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            deleteButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.scale),
            deleteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.scale),
            deleteButton.topAnchor.constraint(equalTo: contentView.topAnchor),
            deleteButton.heightAnchor.constraint(equalToConstant: 48.scale)
        ])
        
        NSLayoutConstraint.activate([
            authInfoLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.scale),
            authInfoLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.scale),
            authInfoLabel.topAnchor.constraint(equalTo: deleteButton.bottomAnchor, constant: 6.scale),
            authInfoLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}

// MARK: Lazy initialization

private extension EditProfileTableDeleteCell {
    func makeDeleteButton() -> UIButton {
        let view = UIButton()
        view.backgroundColor = .white
        view.contentHorizontalAlignment = .left
        view.layer.cornerRadius = 9.scale
        view.titleEdgeInsets = UIEdgeInsets(top: 0.scale, left: 16.scale, bottom: 0.scale, right: 16.scale)
        view.titleLabel?.font = Font.SFProText.regular(size: 17.scale)
        view.setTitleColor(UIColor(red: 1, green: 59 / 255, blue: 48 / 255, alpha: 1), for: .normal)
        view.setTitle("EditProfile.DeleteAccount".localized, for: .normal)
        view.addTarget(self, action: #selector(tapped), for: .touchUpInside)
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeAuthInfoLabel() -> UILabel {
        let view = UILabel()
        view.textColor = UIColor.black.withAlphaComponent(0.44)
        view.font = Font.SFProText.regular(size: 13.scale)
        view.numberOfLines = 0
        view.textAlignment = .left
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
}
