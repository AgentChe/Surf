//
//  CompatibilityTableTextCell.swift
//  Surf
//
//  Created by Andrey Chernyshev on 05.09.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import UIKit

final class CompatibilityTableTextCell: UITableViewCell {
    lazy var compatibilityLabel = makeCompatibilityLabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = UIColor.clear
        
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(text: String) {
        compatibilityLabel.text = text
    }
}

// MARK: Make constraints

private extension CompatibilityTableTextCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            compatibilityLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 32.scale),
            compatibilityLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -32.scale),
            compatibilityLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            compatibilityLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}
// MARK: Lazy initialization

private extension CompatibilityTableTextCell {
    func makeCompatibilityLabel() -> UILabel {
        let view = UILabel()
        view.font = Font.Poppins.regular(size: 15.scale)
        view.textColor = UIColor(red: 130 / 255, green: 130 / 255, blue: 130 / 255, alpha: 1)
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
}
