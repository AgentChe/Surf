//
//  CompatibilityTableSignsCell.swift
//  Surf
//
//  Created by Andrey Chernyshev on 05.09.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import UIKit

final class CompatibilityTableSignsCell: UITableViewCell {
    lazy var sign1ImageView = makeSingImageView()
    lazy var sign2ImageView = makeSingImageView()
    lazy var signsLabel = makeSignsLabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = UIColor.clear
        
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(sign1: ZodiacSign, sign2: ZodiacSign) {
        let sign1DescribingName = String(describing: sign1)
        let sign1ImageName = String(format: "HoroSign.Red.%@", sign1DescribingName)
        sign1ImageView.image = UIImage(named: sign1ImageName)
        
        let sign2DescribingName = String(describing: sign2)
        let sign2ImageName = String(format: "HoroSign.Red.%@", sign2DescribingName)
        sign2ImageView.image = UIImage(named: sign2ImageName)

        let sign1Localize = ZodiacSignMapper.localize(zodiacSign: sign1)
        let sign2Localize = ZodiacSignMapper.localize(zodiacSign: sign2)
        signsLabel.text = String(format: "%@ + %@", sign1Localize, sign2Localize)
    }
}

// MARK: Make constraints

private extension CompatibilityTableSignsCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            sign1ImageView.heightAnchor.constraint(equalToConstant: 64.scale),
            sign1ImageView.widthAnchor.constraint(equalToConstant: 64.scale),
            sign1ImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 133.scale),
            sign1ImageView.topAnchor.constraint(equalTo: contentView.topAnchor)
        ])
        
        NSLayoutConstraint.activate([
            sign2ImageView.heightAnchor.constraint(equalToConstant: 64.scale),
            sign2ImageView.widthAnchor.constraint(equalToConstant: 64.scale),
            sign2ImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -133.scale),
            sign2ImageView.topAnchor.constraint(equalTo: contentView.topAnchor)
        ])
        
        NSLayoutConstraint.activate([
            signsLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            signsLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            signsLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}
// MARK: Lazy initialization

private extension CompatibilityTableSignsCell {
    func makeSingImageView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.layer.cornerRadius = 32.scale
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeSignsLabel() -> UILabel {
        let view = UILabel()
        view.font = Font.Poppins.bold(size: 22.scale)
        view.textColor = UIColor.black
        view.textAlignment = .center
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
}
