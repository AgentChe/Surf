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
    
    private let userZodiacSign: ZodiacSign
    private let proposedInterlocutorZodiacSign: ZodiacSign
    
    private init(userZodiacSign: ZodiacSign, proposedInterlocutorZodiacSign: ZodiacSign) {
        self.userZodiacSign = userZodiacSign
        self.proposedInterlocutorZodiacSign = proposedInterlocutorZodiacSign
        
        super.init(nibName: nil, bundle: .main)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        
        view = compatibilityView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel
            .sections(userZodiacSign: userZodiacSign,
                      proposedInterlocutorZodiacSign: proposedInterlocutorZodiacSign)
            .drive(onNext: { [weak self] sections in
                self?.compatibilityView.tableView.setup(sections: sections)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: Make

extension CompatibilityViewController {
    static func make(userZodiacSign: ZodiacSign, proposedInterlocutorZodiacSign: ZodiacSign) -> CompatibilityViewController {
        let vc = CompatibilityViewController(userZodiacSign: userZodiacSign,
                                             proposedInterlocutorZodiacSign: proposedInterlocutorZodiacSign)
        vc.modalPresentationStyle = .popover
        return vc
    }
}
