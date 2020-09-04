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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        horoscopeView.tableView.actionsDelegate = self
        
        navigationItem.title = "Horoscope.Title".localized
        
        viewModel
            .sections()
            .drive(onNext: { [weak self] sections in
                self?.horoscopeView.tableView.setup(sections: sections)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: Make

extension HoroscopeViewController {
    static func make() -> HoroscopeViewController {
        HoroscopeViewController()
    }
}

// MARK: HoroscopesTableViewDelegate

extension HoroscopeViewController: HoroscopesTableViewDelegate {
    func horoscopeTableDidTapped(tag: HoroscopeOnTableCell.Tag) {
        switch tag {
        case .today:
            viewModel.selectHoroscopeOn.accept(.today)
        case .tomorrow:
            viewModel.selectHoroscopeOn.accept(.tomorrow)
        case .week:
            viewModel.selectHoroscopeOn.accept(.week)
        case .month:
            viewModel.selectHoroscopeOn.accept(.month)
        }
    }
    
    func horoscopeTableDidReadMoreTapped(articleId: String) {
        viewModel.expandArticleId.accept(articleId)
    }
}
