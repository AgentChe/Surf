//
//  HoroscopeViewController.swift
//  Surf
//
//  Created by Andrey Chernyshev on 04.09.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import UIKit
import RxSwift

final class HoroscopeViewController: UIViewController {
    var horoscopeView = HoroscopeView()
    
    private let viewModel = HoroscopeViewModel()
    
    private let disposeBag = DisposeBag()
    
    override func loadView() {
        super.loadView()
        
        view = horoscopeView
    }
}

// MARK: Make

extension HoroscopeViewController {
    static func make() -> HoroscopeViewController {
        HoroscopeViewController()
    }
}
