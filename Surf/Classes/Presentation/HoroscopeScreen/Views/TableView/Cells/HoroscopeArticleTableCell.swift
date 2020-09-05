//
//  HoroscopeArticleTableCell.swift
//  Surf
//
//  Created by Andrey Chernyshev on 04.09.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import UIKit

final class HoroscopeArticleTableCell: UITableViewCell {
    weak var delegate: HoroscopesTableViewDelegate?
    
    lazy var titleLabel = makeTitleLabel()
    lazy var readMoreView = makeReadMoreView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = UIColor.white
        
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(article: HoroscopeTableArticleElement) {
        titleLabel.text = article.title
        
        readMoreView.collapsedNumberOfLines = 3
        readMoreView.text = article.text
        readMoreView.isExpanded = article.isExpanded
        readMoreView.didTapMore = { [weak self] in
            self?.delegate?.horoscopeTableDidReadMoreTapped(articleId: article.id)
        }
    }
}

// MARK: Make constraints

private extension HoroscopeArticleTableCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 32.scale),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -32.scale),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor)
        ])
        
        NSLayoutConstraint.activate([
            readMoreView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 32.scale),
            readMoreView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -32.scale),
            readMoreView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            readMoreView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16.scale)
        ])
    }
}

// MARK: Lazy initialization

private extension HoroscopeArticleTableCell {
    func makeTitleLabel() -> UILabel {
        let view = UILabel()
        view.font = Font.OpenSans.bold(size: 22.scale)
        view.textColor = UIColor.black
        view.numberOfLines = 0
        view.setContentHuggingPriority(UILayoutPriority(rawValue: 251), for: .vertical)
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeReadMoreView() -> ReadMoreView {
        let attributes = ReadMoreViewAttributes("Horoscope.ReadMore".localized,
                                                readMoreFont: Font.Poppins.semibold(size: 15.scale),
                                                gradientColors: [UIColor.white.withAlphaComponent(0).cgColor,
                                                                 UIColor.white.cgColor],
                                                textFont: Font.Poppins.regular(size: 14.scale))
        
        let view = ReadMoreView(attributes: attributes)
        view.setContentHuggingPriority(UILayoutPriority(rawValue: 250), for: .vertical)
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
}
