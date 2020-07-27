//
//  ProposedInterlocutorCollectionCell.swift
//  FAWN
//
//  Created by Andrey Chernyshev on 22/04/2020.
//  Copyright © 2020 Алексей Петров. All rights reserved.
//

import UIKit
import Kingfisher

final class ProposedInterlocutorCollectionCell: UICollectionViewCell {
    weak var delegate: ProposedInterlocutorsCollectionViewDelegate?
    
    lazy var reportButton = makeReportButton()
    lazy var settingsButton = makeSettingsButton()
    lazy var photosSlider = makePhotosSlider()
    lazy var emojiLabel = makeEmojiLabel()
    lazy var welcomeLabel = makeWelcomeLabel()
    lazy var horoSignImageView = makeHoroSignImageView()
    lazy var likeButton = makeLikeButton()
    lazy var dislikeButton = makeDislikeButton()
    
    private var proposedInterlocutor: ProposedInterlocutor!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = UIColor(red: 240 / 255, green: 240 / 255, blue: 242 / 255, alpha: 1)
        
        makeConstraints()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        horoSignImageView.image = nil
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(proposedInterlocutor: ProposedInterlocutor) {
        self.proposedInterlocutor = proposedInterlocutor
        
        emojiLabel.text = proposedInterlocutor.emoji
        
        let age = Calendar.current.dateComponents([.year], from: proposedInterlocutor.birthdate, to: Date()).year ?? 0
        welcomeLabel.text = String(format: "%@, %i", proposedInterlocutor.name, age)
        
        if let zodiacSign = ZodiacManager.shared.zodiac(at: proposedInterlocutor.birthdate) {
            let describingZodiacSign = String(describing: zodiacSign.sign)
            horoSignImageView.image = UIImage(named: String(format: "white_sign_%@", describingZodiacSign))
        }
        
        photosSlider.setup(urls: proposedInterlocutor.photos.sorted(by: { $0.order < $1.order } ).compactMap { URL(string: $0.url) })
    }
}

// MARK: Private

private extension ProposedInterlocutorCollectionCell {
    @objc
    func reportTapped() {
        delegate?.report(on: proposedInterlocutor)
    }
    
    @objc
    func settingsTapped() {
        delegate?.setupSettings()
    }
    
    @objc
    func likeTapped() {
        delegate?.liked(proposedInterlocutor: proposedInterlocutor)
    }
    
    @objc
    func dislikeTapped() {
        delegate?.disliked(proposedInterlocutor: proposedInterlocutor)
    }
}

// MARK: Make constraints

private extension ProposedInterlocutorCollectionCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            reportButton.widthAnchor.constraint(equalToConstant: 30.scale),
            reportButton.heightAnchor.constraint(equalToConstant: 30.scale),
            reportButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -32.scale),
            reportButton.topAnchor.constraint(equalTo: contentView.topAnchor)
        ])
        
        NSLayoutConstraint.activate([
            settingsButton.widthAnchor.constraint(equalToConstant: 30.scale),
            settingsButton.heightAnchor.constraint(equalToConstant: 30.scale),
            settingsButton.trailingAnchor.constraint(equalTo: reportButton.leadingAnchor, constant: -16.scale),
            settingsButton.centerYAnchor.constraint(equalTo: reportButton.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            photosSlider.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 28.scale),
            photosSlider.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -28.scale),
            photosSlider.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 56.scale),
            photosSlider.heightAnchor.constraint(equalToConstant: ScreenSize.isIphoneXFamily ? 449.scale : 350.scale)
        ])
        
        NSLayoutConstraint.activate([
            emojiLabel.leadingAnchor.constraint(equalTo: photosSlider.leadingAnchor, constant: 24.scale),
            emojiLabel.bottomAnchor.constraint(equalTo: welcomeLabel.topAnchor, constant: -8.scale)
        ])
        
        NSLayoutConstraint.activate([
            welcomeLabel.leadingAnchor.constraint(equalTo: photosSlider.leadingAnchor, constant: 24.scale),
            welcomeLabel.trailingAnchor.constraint(equalTo: photosSlider.trailingAnchor, constant: -24.scale),
            welcomeLabel.bottomAnchor.constraint(equalTo: horoSignImageView.topAnchor, constant: -8.scale)
        ])
        
        NSLayoutConstraint.activate([
            horoSignImageView.leadingAnchor.constraint(equalTo: photosSlider.leadingAnchor, constant: 24.scale),
            horoSignImageView.widthAnchor.constraint(equalToConstant: 36.scale),
            horoSignImageView.heightAnchor.constraint(equalToConstant: 36.scale),
            horoSignImageView.bottomAnchor.constraint(equalTo: photosSlider.bottomAnchor, constant: -28.scale)
        ])
        
        NSLayoutConstraint.activate([
            likeButton.widthAnchor.constraint(equalToConstant: 60.scale),
            likeButton.heightAnchor.constraint(equalToConstant: 60.scale),
            likeButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -97.scale),
            likeButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            dislikeButton.widthAnchor.constraint(equalToConstant: 60.scale),
            dislikeButton.heightAnchor.constraint(equalToConstant: 60.scale),
            dislikeButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 97.scale),
            dislikeButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}

// MARK: Lazy initialization

private extension ProposedInterlocutorCollectionCell {
    func makeReportButton() -> UIButton {
        let view = UIButton()
        view.setImage(UIImage(named: "Search.Report"), for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        
        view.addTarget(self, action: #selector(reportTapped), for: .touchUpInside)
        
        return view
    }
    
    func makeSettingsButton() -> UIButton {
        let view = UIButton()
        view.setImage(UIImage(named: "Search.Settings"), for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        
        view.addTarget(self, action: #selector(settingsTapped), for: .touchUpInside)
        
        return view
    }
    
    func makePhotosSlider() -> PhotosSlider {
        let view = PhotosSlider()
        view.backgroundColor = .clear
        view.layer.cornerRadius = 16.scale
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeEmojiLabel() -> UILabel {
        let view = UILabel()
        view.textAlignment = .center
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeHoroSignImageView() -> UIImageView {
        let view = UIImageView()
        view.clipsToBounds = true
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeWelcomeLabel() -> UILabel {
        let view = UILabel()
        view.numberOfLines = 0
        view.textColor = .white
        view.font = Font.OpenSans.bold(size: 34.scale)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeLikeButton() -> UIButton {
        let view = UIButton()
        view.contentMode = .scaleAspectFit
        view.setImage(UIImage(named: "Search.Like"), for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        
        view.addTarget(self, action: #selector(likeTapped), for: .touchUpInside)
        
        return view
    }
    
    func makeDislikeButton() -> UIButton {
        let view = UIButton()
        view.contentMode = .scaleAspectFit
        view.setImage(UIImage(named: "Search.Dislike"), for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        
        view.addTarget(self, action: #selector(dislikeTapped), for: .touchUpInside)
        
        return view
    }
}
