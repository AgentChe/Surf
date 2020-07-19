//
//  MainTabBaritem.swift
//  Surf
//
//  Created by Andrey Chernyshev on 19.07.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import UIKit

final class MainTabBarItem: UIView {
    lazy var imageView = makeImageView()
    lazy var label = makeLabel()
    
    var selectedImage: UIImage?
    var unselectedImage: UIImage?
    
    var isSelected: Bool = false {
        didSet {
            update()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.cornerRadius = 20.scale
        layer.masksToBounds = true
        
        makeConstraints()
        update()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize {
        CGSize(width: 81.scale, height: 36.scale)
    }
}

// MARK: Private

private extension MainTabBarItem {
    func update() {
        imageView.image = isSelected ? selectedImage : unselectedImage
        backgroundColor = isSelected ? UIColor(red: 50 / 255, green: 50 / 255, blue: 52 / 255, alpha: 1) : .clear
        label.textColor = isSelected ? .white : UIColor(red: 50 / 255, green: 50 / 255, blue: 52 / 255, alpha: 1)
    }
}

// MARK: Make constraints

private extension MainTabBarItem {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 24.scale),
            imageView.heightAnchor.constraint(equalToConstant: 24.scale),
            imageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12.scale)
        ])
        
        NSLayoutConstraint.activate([
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12.scale),
            label.centerYAnchor.constraint(equalTo: centerYAnchor),
            label.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 8.scale)
        ])
    }
}

// MARK: Lazy initialization

private extension MainTabBarItem {
    func makeImageView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeLabel() -> UILabel {
        let view = UILabel()
        view.font = Font.OpenSans.semibold(size: 15.scale)
        view.textAlignment = .center
        view.numberOfLines = 1
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
