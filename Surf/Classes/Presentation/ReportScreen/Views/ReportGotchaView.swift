//
//  ReportGotchaViiew.swift
//  Surf
//
//  Created by Andrey Chernyshev on 28.07.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import UIKit

final class ReportGotchaView: UIView {
    lazy var titleLabel = makeTitleLabel()
    lazy var infoLabel = makeInfoLabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Make constraints

private extension ReportGotchaView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 32.scale)
        ])
        
        NSLayoutConstraint.activate([
            infoLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24.scale),
            infoLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24.scale),
            infoLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8.scale)
        ])
    }
}

// MARK: Lazy initialization

private extension ReportGotchaView {
    func makeTitleLabel() -> UILabel {
        let view = UILabel()
        view.text = "Report.Gotcha".localized
        view.font = Font.OpenSans.semibold(size: 17.scale)
        view.textColor = UIColor.black
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeInfoLabel() -> UILabel {
        let view = UILabel()
        view.font = Font.OpenSans.regular(size: 15.scale)
        view.textColor = UIColor(red: 142 / 255, green: 142 / 255, blue: 147 / 255, alpha: 1)
        view.numberOfLines = 0
        view.textAlignment = .center
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
