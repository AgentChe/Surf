//
//  ReadMoreView.swift
//  Surf
//
//  Created by Andrey Chernyshev on 04.09.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import UIKit
import QuartzCore

class ReadMoreView: UIView {
    var text: String? {
        didSet {
            let textAttr = TextAttributes()
                .textColor(attributes.textColor)
                .font(attributes.textFont)
                .lineHeight(attributes.textLineHeight)
                .letterSpacing(attributes.textLetterSpacing)

            textLabel.attributedText = text?.attributed(with: textAttr)
            needsExpanding = isTextTruncated
        }
    }

    var collapsedNumberOfLines: Int = 1 {
        didSet {
            gradientViewHeightConstraint = textLabel.heightAnchor.constraint(
                equalTo: gradientView.heightAnchor,
                multiplier: CGFloat(collapsedNumberOfLines)
            )

            updateExpanded()
        }
    }

    var isExpanded: Bool = false {
        didSet (previous) {
            if isExpanded != previous {
                updateExpanded()
            }
        }
    }
    
    var didTapMore: (() -> Void)?
    
    private let attributes: ReadMoreViewAttributes
    
    init(attributes: ReadMoreViewAttributes) {
        self.attributes = attributes
        
        super.init(frame: .zero)
        
        initialize(attributes: attributes)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        needsExpanding = isTextTruncated
    }
    
    private var needsExpanding: Bool = false {
        didSet (previous) {
            if needsExpanding != previous {
                updateExpanded()
            }
        }
    }

    private var gradientViewHeightConstraint: NSLayoutConstraint? {
        didSet (previous) {
            previous?.isActive = false
            gradientViewHeightConstraint?.isActive = true
        }
    }
    
    private let textLabel = UILabel()
    private let moreButton = UIButton(type: .system)
    private let gradientView = GradientView()
}

// MARK: Private

private extension ReadMoreView {
    private func initialize(attributes: ReadMoreViewAttributes) {
        let title = attributes.readMoreText
        let titleSize = title.size()
        let buttonSize = CGSize(width: ceil(titleSize.width + attributes.gradientWidth), height: ceil(titleSize.height * 3))
        
        let moreAttibutes = TextAttributes()
            .textColor(attributes.readMoreColor)
            .font(attributes.readMoreFont)
            .lineHeight(attributes.readMoreLineHeight)
            .letterSpacing(attributes.readMoreLetterSpacing)

        gradientView.isUserInteractionEnabled = false
        gradientView.translatesAutoresizingMaskIntoConstraints = false
        gradientView.gradientLayer.colors = attributes.gradientColors
        gradientView.gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientView.gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        gradientView.gradientLayer.locations = [0, (attributes.gradientWidth * 0.75 / buttonSize.width) as NSNumber]

        
        moreButton.translatesAutoresizingMaskIntoConstraints = false
        moreButton.contentHorizontalAlignment = .right
        moreButton.contentVerticalAlignment = .bottom
        moreButton.setAttributedTitle(title.attributed(with: moreAttibutes), for: .normal)
        moreButton.addTarget(self, action: #selector(handleMoreButtonTap), for: .touchUpInside)

        textLabel.translatesAutoresizingMaskIntoConstraints = false

        addSubview(textLabel)
        
        NSLayoutConstraint.activate([
            textLabel.topAnchor.constraint(equalTo: topAnchor),
            textLabel.leftAnchor.constraint(equalTo: leftAnchor),
            textLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            textLabel.rightAnchor.constraint(equalTo: rightAnchor)
        ])
        
        [gradientView, moreButton].forEach {
            addSubview($0)
        }

        NSLayoutConstraint.activate([
            moreButton.widthAnchor.constraint(equalToConstant: buttonSize.width),
            moreButton.heightAnchor.constraint(equalToConstant: buttonSize.height),
            moreButton.lastBaselineAnchor.constraint(equalTo: textLabel.lastBaselineAnchor),
            moreButton.rightAnchor.constraint(equalTo: textLabel.rightAnchor),
            gradientView.leftAnchor.constraint(equalTo: moreButton.leftAnchor),
            gradientView.rightAnchor.constraint(equalTo: moreButton.rightAnchor),
            gradientView.bottomAnchor.constraint(equalTo: textLabel.bottomAnchor)
        ])

        text = nil
        collapsedNumberOfLines = 1
        backgroundColor = nil

        updateExpanded()
    }

    @objc
    private func handleMoreButtonTap() {
        isExpanded = true
        didTapMore?()
    }

    private func updateExpanded() {
        let canBeExpanded = needsExpanding && !isExpanded

        moreButton.isHidden = !canBeExpanded
        gradientView.isHidden = !canBeExpanded
        textLabel.numberOfLines = isExpanded ? 0 : collapsedNumberOfLines
    }

    private var isTextTruncated: Bool {
        guard let text = textLabel.attributedText else {
            return false
        }

        let textRect = text.boundingRect(
            with: CGSize(width: textLabel.bounds.size.width, height: .greatestFiniteMagnitude),
            options: .usesLineFragmentOrigin,
            context: nil
        )

        return textRect.height > textLabel.bounds.height
    }
}
