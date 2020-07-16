//
//  PhotosSlider.swift
//  FAWN
//
//  Created by Andrey Chernyshev on 23/04/2020.
//  Copyright © 2020 Алексей Петров. All rights reserved.
//

import UIKit
import Kingfisher

final class PhotosSlider: UIView {
    struct Constants {
        static let selectedColor = UIColor.white
        static let unselectedColor = UIColor(red: 142 / 255, green: 142 / 255, blue: 147 / 255, alpha: 0.6)
        
        static let sliderIndicatorWidth = 3.scale
        static let sliderIndicatorHeight = 20.scale
        static let sliderIndicatorMargin = 4.scale
    }
    
    private lazy var slideIndicators = [UIView]()
    private lazy var slides = [UIImageView]()
    
    private var urls: [URL] = []
    
    private var isConfigured = false
    
    func setup(urls: [URL]) {
        slideIndicators.forEach { $0.removeFromSuperview() }
        slideIndicators = []
        
        slides.forEach { $0.removeFromSuperview() }
        slides = []
        
        subviews.forEach { $0.removeFromSuperview() }
        
        isConfigured = false
        
        self.urls = urls
        
        setNeedsLayout()
        layoutIfNeeded()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        guard !isConfigured && !urls.isEmpty else {
            return
        }
        
        configure()
        
        isConfigured = true
    }
}

// MARK: UIScrollViewDelegate

extension PhotosSlider: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let slideIndex = Int(round(scrollView.contentOffset.y / frame.height))
        
        for (index, slideIndicator) in slideIndicators.enumerated() {
            slideIndicator.backgroundColor = slideIndex == index ? Constants.selectedColor : Constants.unselectedColor
        }
    }
}

// MARK: Private

private extension PhotosSlider {
    private func configure() {
        let scrollView = makeScrollView()
        scrollView.frame.size = CGSize(width: frame.width, height: frame.height)
        scrollView.frame.origin = CGPoint(x: 0, y: 0)
        scrollView.contentSize = CGSize(width: frame.width, height: frame.height * CGFloat(urls.count))
        addSubview(scrollView)
        
        let sliderIndicatorX = frame.width - Constants.sliderIndicatorWidth - 20.scale
        var sliderIndicatorY = 24.scale
        
        for (index, url) in urls.enumerated() {
            let slide = makeSlide()
            slide.frame.size = CGSize(width: frame.width, height: frame.height)
            slide.frame.origin = CGPoint(x: 0, y: frame.height * CGFloat(index))
            slide.kf.setImage(with: url)
            slides.append(slide)
            scrollView.addSubview(slide)
            
            let slideIndicator = makeSlideIndicator()
            slideIndicator.frame.size = CGSize(width: Constants.sliderIndicatorWidth, height: Constants.sliderIndicatorHeight)
            slideIndicator.frame.origin = CGPoint(x: sliderIndicatorX, y: sliderIndicatorY)
            slideIndicator.backgroundColor = index == 0 ? Constants.selectedColor : Constants.unselectedColor
            slideIndicators.append(slideIndicator)
            
            sliderIndicatorY += CGFloat(Constants.sliderIndicatorHeight + Constants.sliderIndicatorMargin)
        }
    }
}

// MARK: Lazy initialization

private extension PhotosSlider {
    private func makeScrollView() -> UIScrollView {
        let view = UIScrollView()
        view.isPagingEnabled = true
        view.delegate = self
        view.showsHorizontalScrollIndicator = false
        view.showsVerticalScrollIndicator = false
        addSubview(view)
        return view
    }
    
    private func makeSlide() -> UIImageView {
        let view = UIImageView()
        view.layer.cornerRadius = 26.scale
        view.layer.masksToBounds = true
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        return view
    }
    
    private func makeSlideIndicator() -> UIView {
        let view = UIView()
        view.layer.cornerRadius = 2.scale
        addSubview(view)
        return view
    }
}
