//
//  ReportViewController.swift
//  FAWN
//
//  Created by Алексей Петров on 12/05/2019.
//  Copyright © 2019 Алексей Петров. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class ReportViewController: UIViewController {
    var reportView = ReportView()
    
    weak var delegate: ReportViewControllerDelegate?
    
    private var reportOn: ReportOn!
    
    private let viewModel = ReportViewModel()
    
    private let disposeBag = DisposeBag()
    
    private let actionSheet = ReportActionSheet()
    
    private var isCompleted = false
    
    override func loadView() {
        super.loadView()
        
        view = reportView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        choice()
        addHideAction()
        
        reportView
            .whatExactlyView
            .cancelButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.dismiss(animated: false)
            })
            .disposed(by: disposeBag)
        
        reportView
            .whatExactlyView
            .sendButton.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let text = self?.reportView.whatExactlyView.textView.text, !text.isEmpty else {
                    return
                }
                
                self?.reportView.whatExactlyView.isHidden = true
                self?.reportView.whatExactlyView.textView.resignFirstResponder()
                
                self?.create(report: Report(type: .other, message: text))
            })
            .disposed(by: disposeBag)
        
        viewModel
            .activityIndicator
            .drive(onNext: { [weak self] isLoading in
                self?.reportView.preloaderView.isHidden = !isLoading
            })
            .disposed(by: disposeBag)
    }
}

// MARK: Make

extension ReportViewController {
    static func make(reportOn: ReportOn) -> ReportViewController {
        let vc = ReportViewController()
        vc.reportOn = reportOn
        vc.modalPresentationStyle = .overCurrentContext
        return vc
    }
}

// MARK: Private

private extension ReportViewController {
    func setup() {
        switch reportOn! {
        case .chatInterlocutor(let chat):
            reportView.gotchaView.infoLabel.text = String(format: "Report.SuccessInfo".localized, chat.interlocutor.name)
        case .proposedInterlocutor(let proposedInterlocutor):
            reportView.gotchaView.infoLabel.text = String(format: "Report.SuccessInfo".localized, proposedInterlocutor.name)
        }
    }
    
    func choice() {
        let actionSheet = self.actionSheet.prepare { [weak self] type in
            guard let type = type else {
                self?.dismiss(animated: false)
                return
            }
            
            switch type {
            case .other:
                self?.reportView.whatExactlyView.isHidden = false
                self?.reportView.whatExactlyView.textView.becomeFirstResponder()
            default:
                self?.create(report: Report(type: type))
            }
        }
        
        DispatchQueue.main.async { [weak self] in
            self?.present(actionSheet, animated: true)
        }
    }
    
    func create(report: Report) {
        let result: Driver<Bool>
        
        switch reportOn! {
        case .chatInterlocutor(let chat):
            result = viewModel.createOnChatInterlocutor(report: report, chatId: chat.id, proposedInterlocutorId: chat.interlocutor.id)
        case .proposedInterlocutor(let proposedInterlocutor):
            result = viewModel.createOnProposedInterlocutor(report: report, proposedInterlocutorId: proposedInterlocutor.id)
        }
        
        result
            .drive(onNext: { [weak self] success in
                guard let `self` = self else {
                    return
                }
                
                self.isCompleted = true
                
                guard success else {
                    Toast.notify(with: "Report.CreateReport.Failure".localized, style: .danger)
                    
                    return
                }
                
                self.reportView.gotchaView.isHidden = false
                
                self.delegate?.reportViewController(reportWasCreated: self.reportOn)
            })
            .disposed(by: disposeBag)
    }
    
    func addHideAction() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hide))
        reportView.addGestureRecognizer(tapGesture)
        reportView.isUserInteractionEnabled = true
    }
    
    @objc
    func hide() {
        guard isCompleted else {
            return
        }
        
        dismiss(animated: false)
    }
}
