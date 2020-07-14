//
//  PaygateView.swift
//  GaiaVPN
//
//  Created by Andrey Chernyshev on 29.06.2020.
//  Copyright © 2020 ENI LENGVICH. All rights reserved.
//

import UIKit

final class PaygateView: UIView {
    lazy var closeButton = makeCloseButton()
    lazy var mainView = makeMainView()
    lazy var specialOfferView = makeSpecialOfferView()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        backgroundColor = .black
        
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Make constraints
    
    private func makeConstraints() {
        NSLayoutConstraint.activate([
            mainView.leadingAnchor.constraint(equalTo: leadingAnchor),
            mainView.trailingAnchor.constraint(equalTo: trailingAnchor),
            mainView.topAnchor.constraint(equalTo: topAnchor),
            mainView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            specialOfferView.leadingAnchor.constraint(equalTo: leadingAnchor),
            specialOfferView.trailingAnchor.constraint(equalTo: trailingAnchor),
            specialOfferView.topAnchor.constraint(equalTo: topAnchor),
            specialOfferView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            closeButton.widthAnchor.constraint(equalToConstant: 37.scale),
            closeButton.heightAnchor.constraint(equalToConstant: 37.scale),
            closeButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20.scale),
            closeButton.topAnchor.constraint(equalTo: topAnchor, constant: ScreenSize.isIphoneXFamily ? 38.scale : 24.scale)
        ])
    }
    
    // MARK: Lazy initialization
    
    private func makeCloseButton() -> UIButton {
        let view = UIButton()
        view.setImage(UIImage(named: "paygate_main_close"), for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    private func makeMainView() -> PaygateMainView {
        let view = PaygateMainView()
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    private func makeSpecialOfferView() -> PaygateSpecialOfferView {
        let view = PaygateSpecialOfferView()
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
