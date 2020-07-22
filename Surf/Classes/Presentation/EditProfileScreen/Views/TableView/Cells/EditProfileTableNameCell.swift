//
//  EditProfileTableTextFieldCell.swift
//  Surf
//
//  Created by Andrey Chernyshev on 22.07.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import UIKit

final class EditProfileTableNameCell: UITableViewCell {
    weak var actionDelegate: EditProfileTableActionDelegate?
    
    lazy var titleLabel = makeTitleLabel()
    lazy var nameTextField = makeNameTextField()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = UIColor(red: 240 / 255, green: 240 / 255, blue: 242 / 255, alpha: 1)
        
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(name: String) {
        nameTextField.text = name
    }
}

// MARK: Private

private extension EditProfileTableNameCell {
    @objc
    func textFieldChanged() {
        actionDelegate?.editProfileTable(changed: nameTextField.text ?? "")
    }
}

// MARK: Make constraints

private extension EditProfileTableNameCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.scale),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.scale),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor)
        ])
        
        NSLayoutConstraint.activate([
            nameTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.scale),
            nameTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.scale),
            nameTextField.topAnchor.constraint(equalTo: titleLabel.topAnchor, constant: 6.scale),
            nameTextField.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}

// MARK: Lazy initialization

private extension EditProfileTableNameCell {
    func makeTitleLabel() -> UILabel {
        let view = UILabel()
        view.textColor = UIColor.black.withAlphaComponent(0.44)
        view.font = Font.SFProText.regular(size: 13.scale)
        view.numberOfLines = 0
        view.textAlignment = .left
        view.text = "EditProfile.FullName".localized
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeNameTextField() -> PaddingTextField {
        let view = PaddingTextField()
        view.leftInset = 16.scale
        view.rightInset = 16.scale
        view.topInset = 9.scale
        view.bottomInset = 11.scale
        view.layer.cornerRadius = 9.scale
        view.layer.masksToBounds = true
        view.backgroundColor = .white
        view.placeholder = "EditProfile.FullName".localized
        view.textColor = UIColor(red: 50 / 255, green: 50 / 255, blue: 52 / 255, alpha: 1)
        view.font = Font.OpenSans.semibold(size: 17.scale)
        view.addTarget(self, action: #selector(textFieldChanged), for: .valueChanged)
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
}
