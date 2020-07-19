//
//  MainView.swift
//  Surf
//
//  Created by Andrey Chernyshev on 19.07.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import UIKit

final class MainView: UIView {
    lazy var screensContainerView = makeScreensContainerView()
    lazy var tabBarView = makeTabBarView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Make constraints

private extension MainView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            screensContainerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            screensContainerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            screensContainerView.topAnchor.constraint(equalTo: topAnchor),
            screensContainerView.bottomAnchor.constraint(equalTo: tabBarView.topAnchor)
        ])
        
        NSLayoutConstraint.activate([
            tabBarView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tabBarView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tabBarView.bottomAnchor.constraint(equalTo: bottomAnchor),
            tabBarView.heightAnchor.constraint(equalToConstant: 96.scale)
        ])
    }
}

// MARK: Lazy initialization

private extension MainView {
    func makeScreensContainerView() -> UIView {
        let view = UIView()
        view.backgroundColor = UIColor.white.withAlphaComponent(0.8)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeTabBarView() -> MainTabBarView {
        let view = MainTabBarView()
        view.backgroundColor = UIColor.white
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
