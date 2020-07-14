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

protocol ReportViewControllerDelegate: class {
    func reportWasCreated(reportOn: ReportViewController.ReportOn)
}

final class ReportViewController: UIViewController {
    enum ReportOn {
        case chatInterlocutor(Chat)
        case proposedInterlocutor(ProposedInterlocutor)
    }
    
    enum ReportType: Int {
        case inappropriateMessages = 1
        case inappropriatePhotos = 2
        case spam = 3
        case other = 4
    }
    
    struct Report {
        let type: ReportType
        let message: String?
        
        init(type: ReportType, message: String? = nil) {
            self.type = type
            self.message = message
        }
    }
    
    // MenuView
    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var inappropriateMessageButton: UIButton!
    @IBOutlet weak var inappropriatePhotos: UIButton!
    @IBOutlet weak var feelLikeSpamButton: UIButton!
    @IBOutlet weak var otherButton: UIButton!
    @IBOutlet weak var closeButton: UIButton!
    
    // ProcessinView
    @IBOutlet weak var processingView: UIView!
    @IBOutlet weak var reportingLabel: UILabel!
    
    // OtherReasonView
    @IBOutlet weak var otherReasonView: UIView!
    @IBOutlet weak var whatExactlyLabel: UILabel!
    @IBOutlet weak var otherReasonTextView: UITextView!
    @IBOutlet weak var otherCancelButton: UIButton!
    @IBOutlet weak var otherSendButton: UIButton!
    
    weak var delegate: ReportViewControllerDelegate?
    
    private var reportOn: ReportOn!
    
    private let viewModel = ReportViewModel()
    
    private let disposeBag = DisposeBag()
    
    init(on: ReportOn) {
        self.reportOn = on
        
        super.init(nibName: "ReportViewController", bundle: .main)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind()
        localize()
        
        switch reportOn! {
        case .chatInterlocutor(let chat):
            headerLabel.text = String(format: "Report.Menu.Header".localized, chat.interlocutorName)
        case .proposedInterlocutor(let proposedInterlocutor):
            headerLabel.text = String(format: "Report.Menu.Header".localized, proposedInterlocutor.interlocutorFullName)
        }
    }
}

// MARK: Private

private extension ReportViewController {
    func bind() {
        viewModel.loading
            .drive(onNext: { [weak self] loading in
                self?.menuView.isHidden = loading
                self?.processingView.isHidden = !loading
            })
            .disposed(by: disposeBag)
        
        Observable
            .merge(
                inappropriateMessageButton.rx.tap.map { Report(type: .inappropriateMessages) },
                inappropriatePhotos.rx.tap.map { Report(type: .inappropriatePhotos) },
                feelLikeSpamButton.rx.tap.map { Report(type: .spam) },
                otherSendButton.rx.tap
                    .do(onNext: { [otherReasonView, otherReasonTextView] in
                        otherReasonView?.isHidden = true
                        otherReasonTextView?.resignFirstResponder()
                    })
                    .map { [otherReasonTextView] in Report(type: .other, message: otherReasonTextView?.text) }
            )
            .flatMapLatest { [weak self] report -> Driver<Void> in
                guard let viewModel = self?.viewModel, let reportOn = self?.reportOn else {
                    return Driver<Void>.empty()
                }
                
                switch reportOn {
                case .chatInterlocutor(let chat):
                    return viewModel.createOnProposedInterlocutor(report: report, proposedInterlocutorId: chat.interlocutorId)
                case .proposedInterlocutor(let proposedInterlocutor):
                    return viewModel.createOnProposedInterlocutor(report: report, proposedInterlocutorId: proposedInterlocutor.id)
                }
            }
            .subscribe(onNext: { [weak self] in
                guard let `self` = self else {
                    return
                }
                
                self.delegate?.reportWasCreated(reportOn: self.reportOn!)
                self.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
        
        otherButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.menuView.isHidden = true
                self?.otherReasonView.isHidden = false
                self?.otherReasonTextView.becomeFirstResponder()
            })
            .disposed(by: disposeBag)
        
        closeButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
        
        otherCancelButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.otherReasonView.isHidden = true
                self?.otherReasonTextView.resignFirstResponder()
                self?.menuView.isHidden = false
            })
            .disposed(by: disposeBag)
    }
    
    func localize() {
        subtitleLabel.text = "Report.Menu.SubTitle".localized
        inappropriateMessageButton.setTitle("Report.Menu.InappropriateMessage".localized, for: .normal)
        inappropriatePhotos.setTitle("Report.Menu.InappropriatePhotos".localized, for: .normal)
        feelLikeSpamButton.setTitle("Report.Menu.FeelLikeSpam".localized, for: .normal)
        otherButton.setTitle("Report.Menu.Other".localized, for: .normal)
        closeButton.setTitle("Report.Menu.Close".localized, for: .normal)
        
        reportingLabel.text = "Report.Processing.Reporting".localized
        
        whatExactlyLabel.text = "Report.OtherReason.WhatExactly".localized
        otherCancelButton.setTitle("Report.OtherReason.Cancel".localized, for: .normal)
        otherSendButton.setTitle("Report.OtherReason.Send".localized, for: .normal)
    }
}
