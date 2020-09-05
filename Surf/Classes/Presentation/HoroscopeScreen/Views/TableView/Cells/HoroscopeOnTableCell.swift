//
//  HoroscopeOnTableCell.swift
//  Surf
//
//  Created by Andrey Chernyshev on 04.09.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import UIKit

final class HoroscopeOnTableCell: UITableViewCell {
    enum Tag: Int {
        case today = 0
        case tomorrow = 1
        case week = 2
        case month = 3
    }
    
    private struct Constants {
        static let _8E8E93Color = UIColor(red: 142 / 255, green: 142 / 255, blue: 147 / 255, alpha: 1)
        static let _1C1C1EColor = UIColor(red: 28 / 255, green: 28 / 255, blue: 30 / 255, alpha: 1)
    }
    
    weak var delegate: HoroscopesTableViewDelegate?
    
    lazy var scrollView = makeScrollView()
    lazy var todayButton = makeButton(text: "Horoscope.Today".localized, tag: Tag.today.rawValue)
    lazy var tomorrowButton = makeButton(text: "Horoscope.Tomorrow".localized, tag: Tag.tomorrow.rawValue)
    lazy var weekButton = makeButton(text: "Horoscope.Week".localized, tag: Tag.week.rawValue)
    lazy var monthButton = makeButton(text: "Horoscope.Month".localized, tag: Tag.month.rawValue)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = UIColor.white
        
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(horoscopeOn: HoroscopeOn) {
        let tag: Tag
        
        switch horoscopeOn {
        case .today: tag = .today
        case .tomorrow: tag = .tomorrow
        case .week: tag = .week
        case .month: tag = .month
        }
        
        update(tag: tag)
    }
}

// MARK: Private

private extension HoroscopeOnTableCell {
    @objc
    func tapped(sender: UIButton) {
        guard let tag = Tag(rawValue: sender.tag) else {
            return
        }
        
        update(tag: tag)
        
        delegate?.horoscopeTableDidTapped(tag: tag)
    }
    
    func update(tag: Tag) {
        [todayButton, tomorrowButton, weekButton, monthButton]
            .forEach {
                $0.backgroundColor = ($0.tag == tag.rawValue) ? Constants._1C1C1EColor : UIColor.clear
                $0.setTitleColor(($0.tag == tag.rawValue) ? UIColor.white : Constants._8E8E93Color, for: .normal)
            }
    }
}

// MARK: Make constraints

private extension HoroscopeOnTableCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: contentView.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            scrollView.heightAnchor.constraint(equalToConstant: 46.scale)
        ])
        
        NSLayoutConstraint.activate([
            todayButton.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 32.scale),
            todayButton.topAnchor.constraint(equalTo: scrollView.topAnchor),
            todayButton.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            todayButton.heightAnchor.constraint(equalToConstant: 46.scale)
        ])
        
        NSLayoutConstraint.activate([
            tomorrowButton.leadingAnchor.constraint(equalTo: todayButton.trailingAnchor, constant: 16.scale),
            tomorrowButton.topAnchor.constraint(equalTo: scrollView.topAnchor),
            tomorrowButton.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            tomorrowButton.heightAnchor.constraint(equalToConstant: 46.scale)
        ])
        
        NSLayoutConstraint.activate([
            weekButton.leadingAnchor.constraint(equalTo: tomorrowButton.trailingAnchor, constant: 16.scale),
            weekButton.topAnchor.constraint(equalTo: scrollView.topAnchor),
            weekButton.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            weekButton.heightAnchor.constraint(equalToConstant: 46.scale)
        ])
        
        NSLayoutConstraint.activate([
            monthButton.leadingAnchor.constraint(equalTo: weekButton.trailingAnchor, constant: 16.scale),
            monthButton.topAnchor.constraint(equalTo: scrollView.topAnchor),
            monthButton.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            monthButton.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -32.scale),
            monthButton.heightAnchor.constraint(equalToConstant: 46.scale)
        ])
    }
}

// MARK: Lazy initialization

private extension HoroscopeOnTableCell {
    func makeScrollView() -> UIScrollView {
        let view = UIScrollView()
        view.backgroundColor = UIColor.clear
        view.showsHorizontalScrollIndicator = false
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeButton(text: String, tag: Int) -> UIButton {
        let view = UIButton()
        view.tag = tag
        view.backgroundColor = UIColor.clear
        view.contentEdgeInsets = UIEdgeInsets(top: 0, left: 16.scale, bottom: 0, right: 16.scale)
        view.layer.cornerRadius = 16.scale
        view.titleLabel?.font = Font.Poppins.semibold(size: 17.scale)
        view.setTitle(text, for: .normal)
        view.setTitleColor(Constants._8E8E93Color, for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addTarget(self, action: #selector(tapped(sender:)), for: .touchUpInside)
        scrollView.addSubview(view)
        return view
    }
}
