//
//  SearchViewController.swift
//  FAWN
//
//  Created by Andrey Chernyshev on 22/04/2020.
//  Copyright © 2020 Алексей Петров. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class SearchViewController: UIViewController {
    var searchView = SearchView()
    
    weak var delegate: SearchViewControllerDelegate?
    
    private let viewModel = SearchViewModel()
    
    private let disposeBag = DisposeBag()
    
    override func loadView() {
        super.loadView()
        
        view = searchView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        AmplitudeAnalytics.shared.log(with: .searchScr)
        
        searchView.collectionView.proposedInterlocutorsDelegate = self 
        
        viewModel
            .step()
            .drive(onNext: { [weak self] step in
                switch step {
                case .proposedInterlocutors(let proposedInterlocutors):
                    self?.searchView.collectionView.add(proposedInterlocutors: proposedInterlocutors)
                    
                    self?.searchView.collectionView.isHidden = proposedInterlocutors.isEmpty
                    self?.searchView.noProposedInterlocutorsView.isHidden = !proposedInterlocutors.isEmpty
                case .needPayment:
                    self?.searchView.noProposedInterlocutorsView.isHidden = false
                    
                    self?.goToPaygateScreen()
                }
            })
            .disposed(by: disposeBag)
        
        viewModel
            .liked()
            .drive(onNext: { [weak self] stub in
                let (proposedInterlocutor, mutual) = stub
                
                self?.searchView.collectionView.remove(proposedInterlocutor: proposedInterlocutor)
                
                if mutual {
                    self?.goToMutualLikedScreen()
                }
            })
            .disposed(by: disposeBag)
        
        viewModel
            .disliked()
            .drive(onNext: { [weak self] proposedInterlocutor in
                self?.searchView.collectionView.remove(proposedInterlocutor: proposedInterlocutor)
            })
            .disposed(by: disposeBag)
        
        searchView
            .noProposedInterlocutorsView
            .tryMoreTimeButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.viewModel.downloadProposedInterlocutors.accept(Void())
            })
            .disposed(by: disposeBag)
        
        searchView
            .noProposedInterlocutorsView
            .settingsButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.goToSettingsScreen()
            })
            .disposed(by: disposeBag)
        
        viewModel
            .signsForCompatibility()
            .drive(onNext: { [weak self] signs in
                let (userZodiacSign, proposedInterlocutorZodiacSign) = signs
                
                self?.goToCompatibilityScreen(userZodiacSign: userZodiacSign,
                                              proposedInterlocutorZodiacSign: proposedInterlocutorZodiacSign)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: Make

extension SearchViewController {
    static func make() -> SearchViewController {
        SearchViewController()
    }
}

// MARK: PaygateViewControllerDelegate

extension SearchViewController: PaygateViewControllerDelegate {
    func wasPurchased() {
        viewModel.downloadProposedInterlocutors.accept(Void())
    }
    
    func wasRestored() {
        viewModel.downloadProposedInterlocutors.accept(Void())
    }
}

// MARK: ReportViewControllerDelegate

extension SearchViewController: ReportViewControllerDelegate {
    func reportViewController(reportWasCreated on: ReportOn) {
        if case let .proposedInterlocutor(proposedInterlocutor) = on {
            searchView.collectionView.remove(proposedInterlocutor: proposedInterlocutor)
        }
    }
}

// MARK: ProposedInterlocutorsCollectionViewDelegate

extension SearchViewController: ProposedInterlocutorsCollectionViewDelegate {
    func liked(proposedInterlocutor: ProposedInterlocutor) {
        viewModel.like.accept(proposedInterlocutor)
    }
    
    func disliked(proposedInterlocutor: ProposedInterlocutor) {
        viewModel.dislike.accept(proposedInterlocutor)
    }
    
    func report(on proposedInterlocutor: ProposedInterlocutor) {
        goToReportScreen(proposedInterlocutor: proposedInterlocutor)
    }
    
    func setupSettings() {
        goToSettingsScreen()
    }
    
    func proposedInterlocutorsCollectionView(changed items: Int) {
        guard items == 0 else {
            return
        }
        
        viewModel.downloadProposedInterlocutors.accept(Void())
    }
    
    func compatibility(with proposedInterlocutor: ProposedInterlocutor) {
        viewModel.compatibilityWithProposedInterlocutor.accept(proposedInterlocutor)
    }
}

// MARK: MutualLikedViewControllerDelegate

extension SearchViewController: MutualLikedViewControllerDelegate {
    func sendMessageTapped() {
        delegate?.searchViewControllerSendMessageTapped()
    }
}

// MARK: Private

private extension SearchViewController {
    func goToPaygateScreen() {
        let vc = PaygateViewController.make()
        vc.delegate = self
        navigationController?.present(vc, animated: true)
    }
    
    func goToReportScreen(proposedInterlocutor: ProposedInterlocutor) {
        let vc = ReportViewController.make(reportOn: .proposedInterlocutor(proposedInterlocutor))
        vc.delegate = self
        
        navigationController?.present(vc, animated: false)
    }
    
    func goToMutualLikedScreen() {
        let vc = MutualLikedViewController.make()
        vc.delegate = self
        navigationController?.present(vc, animated: true)
    }
    
    func goToSettingsScreen() {
        let vc = SearchSettingsViewController.make()
        navigationController?.present(vc, animated: true)
    }
    
    func goToCompatibilityScreen(userZodiacSign: ZodiacSign, proposedInterlocutorZodiacSign: ZodiacSign) {
        let vc = CompatibilityViewController.make(userZodiacSign: userZodiacSign,
                                                  proposedInterlocutorZodiacSign: proposedInterlocutorZodiacSign)
        if #available(iOS 13.0, *) {
            navigationController?.present(vc, animated: true)
        } else {
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
