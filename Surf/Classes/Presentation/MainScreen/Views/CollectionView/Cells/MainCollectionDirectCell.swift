//
//  MainCollectionDirectCell.swift
//  Surf
//
//  Created by Andrey Chernyshev on 04.09.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import UIKit

final class MainCollectionDirectCell: UICollectionViewCell {
    weak var delegate: MainCollectionViewDelegate?
    
    lazy var iconView = makeIconView()
    lazy var titleLabel = makeTitleLabel()
    lazy var subTitleLabel = makeSubTitleLabel()
    
    private var element: MainCollectionDirectElement!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor(red: 245 / 255, green: 245 / 255, blue: 245 / 255, alpha: 1)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapped))
        contentView.addGestureRecognizer(tapGesture)
        
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = 15.scale
        layer.borderWidth = 5.scale
        layer.borderColor = UIColor.clear.cgColor
        layer.masksToBounds = true
        
        contentView.layer.cornerRadius = 15.scale
        contentView.layer.borderWidth = 5.scale
        contentView.layer.borderColor = UIColor.clear.cgColor
        contentView.layer.masksToBounds = true
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = .zero
        layer.shadowRadius = 6.scale
        layer.shadowOpacity = 0.6
        layer.cornerRadius = 15.scale
        layer.masksToBounds = false
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: contentView.layer.cornerRadius).cgPath
    }
    
    func setup(element: MainCollectionDirectElement) {
        self.element = element
        
        iconView.image = UIImage(named: element.imageName)
        titleLabel.text = element.title
        subTitleLabel.text = element.subTitle
    }
}

// MARK: Private

private extension MainCollectionDirectCell {
    @objc
    func tapped() {
        delegate?.mainCollectionViewDidDirectTapped(element: element)
    }
}

// MARK: Make constraints

private extension MainCollectionDirectCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            iconView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -35.scale),
            iconView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20.scale),
            iconView.widthAnchor.constraint(equalToConstant: 64.scale),
            iconView.heightAnchor.constraint(equalToConstant: 64.scale)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 35.scale),
            titleLabel.trailingAnchor.constraint(equalTo: iconView.leadingAnchor, constant: -16.scale),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20.scale)
        ])
        
        NSLayoutConstraint.activate([
            subTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 35.scale),
            subTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -35.scale),
            subTitleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -36.scale.scale)
        ])
    }
}

// MARK: Lazy initialization

private extension MainCollectionDirectCell {
    func makeIconView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeTitleLabel() -> UILabel {
        let view = UILabel()
        view.textColor = UIColor.black
        view.font = Font.OpenSans.semibold(size: 28.scale)
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeSubTitleLabel() -> UILabel {
        let view = UILabel()
        view.textColor = UIColor.black
        view.font = Font.OpenSans.regular(size: 15.scale)
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
}
