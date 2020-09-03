//
//  CompatibilityViewController.swift
//  Surf
//
//  Created by Andrey Chernyshev on 04.09.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import UIKit
import RxSwift

final class CompatibilityViewController: UIViewController {
    var compatibilityView = CompatibilityView()
    
    private let viewModel = CompatibilityViewModel()
    
    private let disposeBag = DisposeBag()
    
    override func loadView() {
        super.loadView()
        
        view = compatibilityView
    }
}

// MARK: Make

extension CompatibilityViewController {
    static func make() -> CompatibilityViewController {
        CompatibilityViewController()
    }
}
