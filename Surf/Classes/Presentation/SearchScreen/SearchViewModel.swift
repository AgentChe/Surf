//
//  SearchViewModel.swift
//  FAWN
//
//  Created by Andrey Chernyshev on 22/04/2020.
//  Copyright © 2020 Алексей Петров. All rights reserved.
//

import RxSwift
import RxCocoa

final class SearchViewModel {
    enum Step {
        case proposedInterlocutors([ProposedInterlocutor])
        case needPayment
    }
    
    let downloadProposedInterlocutors = PublishRelay<Void>()
    let like = PublishRelay<ProposedInterlocutor>()
    let dislike = PublishRelay<ProposedInterlocutor>()
    let compatibilityWithProposedInterlocutor = PublishRelay<ProposedInterlocutor>()
    
    func step() -> Driver<Step> {
        downloadProposedInterlocutors
            .startWith(Void())
            .flatMapLatest {
                SearchService
                    .proposedInterlocuters()
                    .map { (false, $0) }
                    .catchError { error in
                        if let paymentError = error as? PaymentError, paymentError == .needPayment {
                            return .just((true, []))
                        } else {
                            return .just((false, []))
                        }
                    }
            }
            .map {
                $0 ? Step.needPayment : Step.proposedInterlocutors($1)
            }
            .asDriver(onErrorDriveWith: .never())
    }
    
    func liked() -> Driver<(ProposedInterlocutor, Bool)> {
        like
            .flatMap { prposedInterlocutor in
                SearchService
                    .likeProposedInterlocutor(with: prposedInterlocutor.id)
                    .flatMap { mutual -> Single<(ProposedInterlocutor, Bool)> in
                        guard let mutual = mutual else {
                            return .never()
                        }
                        
                        return .deferred { .just((prposedInterlocutor, mutual)) }
                    }
                    .catchError { _ in .never() }
                }
        .asDriver(onErrorDriveWith: .never())
    }
    
    func disliked() -> Driver<ProposedInterlocutor> {
        dislike
            .flatMap { prposedInterlocutor in
                SearchService
                    .dislikeProposedInterlocutor(with: prposedInterlocutor.id)
                    .map { prposedInterlocutor }
                    .catchError { _ in .never() }
                }
            .asDriver(onErrorDriveWith: .never())
    }
    
    func signsForCompatibility() -> Driver<(ZodiacSign, ZodiacSign)> {
        let userZodiacSign = ProfileManager
            .retrieve()
            .flatMap { profile -> Single<ZodiacSign> in
                guard let profile = profile, let zodiac = ZodiacManager.shared.zodiac(at: profile.birthdate) else {
                    return .never()
                }
                
                return .deferred { .just(zodiac.sign) }
            }
            .asDriver(onErrorDriveWith: .empty())
        
        let proposedInterlocutorZodiacSign = compatibilityWithProposedInterlocutor
            .flatMapLatest { proposedInterlocutor -> Observable<ZodiacSign> in
                guard let zodiac = ZodiacManager.shared.zodiac(at: proposedInterlocutor.birthdate) else {
                    return .empty()
                }
                
                return .deferred { .just(zodiac.sign) }
            }
            .asDriver(onErrorDriveWith: .empty())
        
        return Driver
            .combineLatest(userZodiacSign, proposedInterlocutorZodiacSign) { ($0, $1) }
    }
}
