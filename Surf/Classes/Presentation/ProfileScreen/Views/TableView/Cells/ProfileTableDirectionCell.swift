//
//  ProfileTableDirectionCell.swift
//  Surf
//
//  Created by Andrey Chernyshev on 20.07.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import UIKit

final class ProfileTableDirectionCell: UITableViewCell {
    lazy var containerView = makeContainerView()
    lazy var directionLabel = makeDirectionLabel()
    lazy var directionIcon = makeDirectionIcon()
    
    weak var actionDelegate: ProfileTableActionDelegate?
    
    private var direction: ProfileTableDirection!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = UIColor(red: 240 / 255, green: 240 / 255, blue: 242 / 255, alpha: 1)
        
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(direction: ProfileTableDirection, title: String, withIcon: Bool, maskedCorners: CACornerMask) {
        self.direction = direction
        
        directionLabel.text = title
        directionIcon.isHidden = !withIcon
        containerView.layer.maskedCorners = maskedCorners
    }
}

// MARK: Private

private extension ProfileTableDirectionCell {
    @objc
    func tapped() {
        actionDelegate?.profileTable(selected: direction)
    }
}

// MARK: Make constraints

private extension ProfileTableDirectionCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.scale),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.scale),
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            directionLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16.scale),
            directionLabel.trailingAnchor.constraint(equalTo: directionIcon.leadingAnchor, constant:  -16.scale),
            directionLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 13.scale),
            directionLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -13.scale)
        ])
        
        NSLayoutConstraint.activate([
            directionIcon.widthAnchor.constraint(equalToConstant: 15.scale),
            directionIcon.heightAnchor.constraint(equalToConstant: 17.scale),
            directionIcon.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            directionIcon.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16.scale)
        ])
    }
}

// MARK: Lazy initialization

private extension ProfileTableDirectionCell {
    func makeContainerView() -> UIView {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 9.scale
        view.layer.maskedCorners = []
        view.isUserInteractionEnabled = true
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapped))
        view.addGestureRecognizer(tapGesture)
        
        return view
    }
    
    func makeDirectionLabel() -> UILabel {
        let view = UILabel()
        view.textColor = .black
        view.font = Font.SFProText.regular(size: 17.scale)
        view.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(view)
        return view
    }
    
    func makeDirectionIcon() -> UIImageView {
        let view = UIImageView()
        view.clipsToBounds = true
        view.contentMode = .scaleAspectFit
        view.image = UIImage(named: "Profile.ArrowRight")
        view.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(view)
        return view
    }
}
