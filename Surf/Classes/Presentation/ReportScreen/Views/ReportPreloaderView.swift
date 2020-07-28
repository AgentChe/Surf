//
//  ReportPreloaderView.swift
//  Surf
//
//  Created by Andrey Chernyshev on 28.07.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import UIKit

final class ReportPreloaderView: UIView {
    lazy var label = makeLabel()
    lazy var activityIndicator = makeActivityIndicator()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Make constraints

private extension ReportPreloaderView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 131.scale),
            label.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            activityIndicator.centerYAnchor.constraint(equalTo: label.centerYAnchor),
            activityIndicator.leadingAnchor.constraint(equalTo: label.trailingAnchor, constant: 6.scale)
        ])
    }
}

// MARK: Lazy initialization

private extension ReportPreloaderView {
    func makeLabel() -> UILabel {
        let view = UILabel()
        view.text = "Report.Reporting".localized
        view.font = Font.OpenSans.regular(size: 17.scale)
        view.textColor = UIColor(red: 142 / 255, green: 142 / 255, blue: 147 / 255, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeActivityIndicator() -> UIActivityIndicatorView {
        let view = UIActivityIndicatorView()
        view.hidesWhenStopped = true
        view.style = .gray
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
