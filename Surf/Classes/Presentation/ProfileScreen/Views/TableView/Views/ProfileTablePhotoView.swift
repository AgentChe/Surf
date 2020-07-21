//
//  ProfileTablePhotoView.swift
//  Surf
//
//  Created by Andrey Chernyshev on 21.07.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import UIKit

final class ProfileTablePhotoView: UIView {
    lazy var imageView = makeImageView()
    lazy var label = makeLabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Make constraints

private extension ProfileTablePhotoView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16.scale),
            label.widthAnchor.constraint(equalToConstant: 20.scale),
            label.heightAnchor.constraint(equalToConstant: 20.scale)
        ])
    }
}

// MARK: Lazy initialization

private extension ProfileTablePhotoView {
    func makeImageView() -> UIImageView {
        let view = UIImageView()
        view.clipsToBounds = true
        view.contentMode = .scaleAspectFill
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeLabel() -> UILabel {
        let view = UILabel()
        view.backgroundColor = UIColor(red: 229 / 255, green: 229 / 255, blue: 234 / 255, alpha: 1)
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 10.scale
        view.textColor = .black
        view.font = Font.SFProText.regular(size: 14.scale)
        view.textAlignment = .center
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
