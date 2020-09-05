//
//  CompatibilityTableScoresCell.swift
//  Surf
//
//  Created by Andrey Chernyshev on 05.09.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import UIKit

final class CompatibilityTableScoresCell: UITableViewCell {
    lazy var loveScoreView = makeScoreView(title: "Compatibility.Score.Love".localized)
    lazy var trustScoreView = makeScoreView(title: "Compatibility.Score.Trust".localized)
    lazy var emotionsScoreView = makeScoreView(title: "Compatibility.Score.Emotions".localized)
    lazy var valuesScoreView = makeScoreView(title: "Compatibility.Score.Values".localized)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = UIColor.white
        
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(scores: CompatibilityTableScoresElement) {
        loveScoreView.score = scores.love
        trustScoreView.score = scores.trust
        emotionsScoreView.score = scores.emotions
        valuesScoreView.score = scores.values
    }
}

// MARK: Make constraints

private extension CompatibilityTableScoresCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            loveScoreView.centerXAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 44.scale),
            loveScoreView.topAnchor.constraint(equalTo: contentView.topAnchor),
            loveScoreView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            trustScoreView.centerXAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 134.scale),
            trustScoreView.topAnchor.constraint(equalTo: contentView.topAnchor),
            trustScoreView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            emotionsScoreView.centerXAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 224.scale),
            emotionsScoreView.topAnchor.constraint(equalTo: contentView.topAnchor),
            emotionsScoreView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            valuesScoreView.centerXAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 314.scale),
            valuesScoreView.topAnchor.constraint(equalTo: contentView.topAnchor),
            valuesScoreView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}

// MARK: Lazy initialization

private extension CompatibilityTableScoresCell {
    func makeScoreView(title: String) -> CompatibilityScoreView {
        let view = CompatibilityScoreView()
        view.title = title
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
}
