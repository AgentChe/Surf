//
//  CompatibilityTableOverallScoreCell.swift
//  Surf
//
//  Created by Andrey Chernyshev on 05.09.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import UIKit

final class CompatibilityTableOverallScoreCell: UITableViewCell {
    lazy var titleLabel = makeTitleLabel()
    lazy var pieView = makePieView()
    lazy var valueLabel = makeValueLabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = UIColor.clear
        
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(overallScore: Double) {
        pieView.progress = overallScore
        valueLabel.text = String(overallScore)
    }
}

// MARK: Make constraints

private extension CompatibilityTableOverallScoreCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 32.scale),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            pieView.heightAnchor.constraint(equalToConstant: 24.scale),
            pieView.widthAnchor.constraint(equalToConstant: 24.scale),
            pieView.trailingAnchor.constraint(equalTo: valueLabel.leadingAnchor, constant: -12.scale),
            pieView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            valueLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -32.scale),
            valueLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
}
// MARK: Lazy initialization

private extension CompatibilityTableOverallScoreCell {
    func makeTitleLabel() -> UILabel {
        let view = UILabel()
        view.font = Font.Poppins.bold(size: 22.scale)
        view.textColor = UIColor.black
        view.text = "Compatibility.OverallScore.Title".localized
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makePieView() -> PieView {
        let view = PieView()
        view.backgroundColor = UIColor.clear
        view.pieBackgroundColor = UIColor(red: 239 / 255, green: 239 / 255, blue: 244 / 255, alpha: 1)
        view.pieFilledColer = UIColor(red: 1, green: 198 / 255, blue: 67 / 255, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeValueLabel() -> UILabel {
        let view = UILabel()
        view.font = Font.Poppins.bold(size: 22.scale)
        view.textColor = UIColor.black
        view.text = "Compatibility.OverallScore.Title".localized
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
}
