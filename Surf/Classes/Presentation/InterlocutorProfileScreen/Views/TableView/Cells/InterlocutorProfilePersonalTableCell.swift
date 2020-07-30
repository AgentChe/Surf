//
//  InterlocutorProfilePersonalTableCell.swift
//  Surf
//
//  Created by Andrey Chernyshev on 30.07.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import UIKit

final class InterlocutorProfilePersonalTableCell: UITableViewCell {
    lazy var nameAgeLabel = makeNameAgeLabel()
    lazy var emojiLabel = makeEmojiLabel()
    lazy var zodiacSignLabel = makeZodiacSignLabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = UIColor(red: 240 / 255, green: 240 / 255, blue: 242 / 255, alpha: 1)
        
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(name: String, birthdate: Date, emoji: String) {
        let age = Calendar.current.dateComponents([.year], from: birthdate, to: Date()).year ?? 0
        nameAgeLabel.attributedText = String(format: "%@, %i", name, age)
            .attributed(with: TextAttributes()
                .lineHeight(36.scale))
        
        emojiLabel.text = emoji
        
        if let zodiacSign = ZodiacManager.shared.zodiac(at: birthdate)?.sign {
            zodiacSignLabel.text = ZodiacSignMapper.localize(zodiacSign: zodiacSign)
        }
    }
}

// MARK: Make constraints

private extension InterlocutorProfilePersonalTableCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            nameAgeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.scale),
            nameAgeLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            nameAgeLabel.trailingAnchor.constraint(equalTo: emojiLabel.leadingAnchor, constant: -16.scale),
        ])
        
        NSLayoutConstraint.activate([
            emojiLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20.scale),
            emojiLabel.topAnchor.constraint(equalTo: contentView.topAnchor)
        ])
        
        NSLayoutConstraint.activate([
            zodiacSignLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.scale),
            zodiacSignLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.scale),
            zodiacSignLabel.topAnchor.constraint(equalTo: nameAgeLabel.bottomAnchor),
            zodiacSignLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}

// MARK: Lazy initialization

private extension InterlocutorProfilePersonalTableCell {
    func makeNameAgeLabel() -> UILabel {
        let view = UILabel()
        view.textAlignment = .left
        view.textColor = .black
        view.font = Font.OpenSans.bold(size: 34.scale)
        view.numberOfLines = 0
        view.setContentHuggingPriority(UILayoutPriority(rawValue: 250), for: .horizontal)
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeEmojiLabel() -> UILabel {
        let view = UILabel()
        view.font = view.font.withSize(32.scale)
        view.setContentHuggingPriority(UILayoutPriority(rawValue: 251), for: .horizontal)
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeZodiacSignLabel() -> UILabel {
        let view = UILabel()
        view.textAlignment = .left
        view.textColor = UIColor(red: 154 / 255, green: 154 / 255, blue: 162 / 255, alpha: 1)
        view.font = Font.OpenSans.semibold(size: 17.scale)
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
}
