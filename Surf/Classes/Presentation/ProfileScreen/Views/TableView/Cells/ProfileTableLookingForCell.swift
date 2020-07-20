//
//  ProfileTableLookingForCell.swift
//  Surf
//
//  Created by Andrey Chernyshev on 20.07.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import UIKit
import RangeSeekSlider

final class ProfileTableLookingForCell: UITableViewCell {
    weak var actionDelegate: ProfileTableActionDelegate?
    
    lazy var containerView = makeContainerView()
    lazy var iconView = makeIconView()
    lazy var titleLabel = makeLabel(text: "Profile.ShowMe.Title".localized)
    lazy var minAgeLabel = makeLabel(text: "")
    lazy var maxAgeLabel = makeLabel(text: "")
    lazy var lookingForChoiseView = makeLookingForChoiceView()
    lazy var ageRangeSlider = makeAgeRangeSlider()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = UIColor(red: 240 / 255, green: 240 / 255, blue: 242 / 255, alpha: 1)
        
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(lookingFor: [Gender], minAge: Int, maxAge: Int) {
        update(label: minAgeLabel, age: minAge)
        update(label: maxAgeLabel, age: maxAge)
        lookingForChoiseView.lookingFor = lookingFor
        ageRangeSlider.selectedMinValue = CGFloat(minAge)
        ageRangeSlider.selectedMaxValue = CGFloat(maxAge)
    }
}

// MARK: RangeSeekSliderDelegate

extension ProfileTableLookingForCell: RangeSeekSliderDelegate {
    func rangeSeekSlider(_ slider: RangeSeekSlider, didChange minValue: CGFloat, maxValue: CGFloat) {
        update(label: minAgeLabel, age: Int(minValue))
        update(label: maxAgeLabel, age: Int(maxValue))
        
        sendAction()
    }
}

// MARK: Private

private extension ProfileTableLookingForCell {
    func sendAction() {
        actionDelegate?.profileTable(changed: lookingForChoiseView.lookingFor,
                                     minAge: Int(ageRangeSlider.selectedMinValue),
                                     maxAge: Int(ageRangeSlider.selectedMaxValue))
    }
    
    func update(label: UILabel, age: Int) {
        label.text = String(format: "%i %@", age, "Profile.ShowMe.Years".localized)
    }
}

// MARK: Make constraints

private extension ProfileTableLookingForCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.scale),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.scale),
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            iconView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 15.scale),
            iconView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 11.scale),
            iconView.widthAnchor.constraint(equalToConstant: 28.scale),
            iconView.heightAnchor.constraint(equalToConstant: 28.scale)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 58.scale),
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 15.scale)
        ])
        
        NSLayoutConstraint.activate([
            minAgeLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 15.scale),
            minAgeLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 55.scale)
        ])
        
        NSLayoutConstraint.activate([
            maxAgeLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -15.scale),
            maxAgeLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 55.scale)
        ])
        
        NSLayoutConstraint.activate([
            lookingForChoiseView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16.scale),
            lookingForChoiseView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16.scale),
            lookingForChoiseView.heightAnchor.constraint(equalToConstant: 32.scale),
            lookingForChoiseView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -26.scale)
        ])
        
        NSLayoutConstraint.activate([
            ageRangeSlider.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16.scale),
            ageRangeSlider.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16.scale),
            ageRangeSlider.heightAnchor.constraint(equalToConstant: 28.scale),
            ageRangeSlider.topAnchor.constraint(equalTo: minAgeLabel.bottomAnchor)
        ])
    }
}

// MARK: Lazy initialization

private extension ProfileTableLookingForCell {
    func makeContainerView() -> UIView {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 9.scale
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeIconView() -> UIImageView {
        let view = UIImageView()
        view.clipsToBounds = true
        view.contentMode = .scaleAspectFit
        view.image = UIImage(named: "Profile.ShowMe")
        view.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(view)
        return view
    }
    
    func makeLabel(text: String) -> UILabel {
        let view = UILabel()
        view.textColor = UIColor(red: 35 / 255, green: 35 / 255, blue: 38 / 255, alpha: 1)
        view.font = Font.SFProText.semibold(size: 17.scale)
        view.text = text
        view.textAlignment = .left
        view.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(view)
        return view
    }
    
    func makeLookingForChoiceView() -> ProfileLookingForChoiceView {
        let view = ProfileLookingForChoiceView()
        view.backgroundColor = UIColor(red: 239 / 255, green: 239 / 255, blue: 240 / 255, alpha: 1)
        view.layer.cornerRadius = 9.scale
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(view)
        
        view.on = { [weak self] genders in
            self?.sendAction()
        }
        
        return view
    }
    
    private func makeAgeRangeSlider() -> RangeSeekSlider {
        let view = RangeSeekSlider()
        view.delegate = self
        view.minValue = 16
        view.maxValue = 80
        view.handleDiameter = 24.scale
        view.selectedHandleDiameterMultiplier = 1
        view.lineHeight = 2.scale
        view.tintColor = UIColor(red: 230 / 255, green: 228 / 255, blue: 234 / 255, alpha: 1)
        view.colorBetweenHandles = UIColor(red: 0, green: 122 / 255, blue: 1, alpha: 1)
        view.hideLabels = true
        view.handleImage = UIImage(named: "Profile.ThumbSlider")
        view.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(view)
        return view
    }
}
