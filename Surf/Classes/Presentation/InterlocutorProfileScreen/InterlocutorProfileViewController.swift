//
//  InterlocutorProfileViewController.swift
//  Surf
//
//  Created by Andrey Chernyshev on 30.07.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import UIKit
import RxSwift

final class InterlocutorProfileViewController: UIViewController {
    var interlocutorProfileView = InterlocutorProfileView()
    
    weak var delegate: InterlocutorProfileViewControllerDelegate?
    
    private let viewModel = InterlocutorProfileViewModel()
    
    private let disposeBag = DisposeBag()
    
    private var chat: Chat!
    
    override func loadView() {
        super.loadView()
        
        view = interlocutorProfileView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        interlocutorProfileView.tableView.actionDelegate = self
        
        interlocutorProfileView
            .tableView
            .setup(sections: viewModel.prepare(interlocutor: chat.interlocutor))
        
        viewModel
            .unmatched()
            .drive(onNext: { [weak self] success in
                Toast.notify(with: success ? "InterlocutorProfile.UnmatchSuccess".localized : "InterlocutorProfile.UnmatchFailure".localized,
                             style: success ? .success : .danger)
                
                if !success {
                    self?.complete()
                }
            })
            .disposed(by: disposeBag)
    }
}

// MARK: Make

extension InterlocutorProfileViewController {
    static func make(chat: Chat) -> InterlocutorProfileViewController {
        let vc = InterlocutorProfileViewController()
        vc.chat = chat
        return vc
    }
}

// MARK: InterlocutorProfileTableActionDelegate

extension InterlocutorProfileViewController: InterlocutorProfileTableActionDelegate {
    func interlocutorProfileTable(selected direct: InterlocutorProfileTableDirection) {
        switch direct {
        case .unmatch:
            viewModel.unmatch.accept(chat.id)
        case .report:
            goToReportScreen()
        }
    }
}

//MARK: ReportViewControllerDelegate

extension InterlocutorProfileViewController: ReportViewControllerDelegate {
    func reportViewController(reportWasCreated on: ReportOn) {
        complete()
    }
}

// MARK: Private

private extension InterlocutorProfileViewController {
    func complete() {
        delegate?.interlocutorProfileViewController(reported: chat)
        
        navigationController?.popViewController(animated: true)
    }
    
    func goToReportScreen() {
        let vc = ReportViewController.make(reportOn: .chatInterlocutor(chat))
        vc.delegate = self
        navigationController?.present(vc, animated: false)
    }
}
