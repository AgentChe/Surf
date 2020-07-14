//
//  PaginatedDataLoader.swift
//  FAWN
//
//  Created by Andrey Chernyshev on 07/06/2020.
//  Copyright © 2020 Алексей Петров. All rights reserved.
//

import RxSwift
import RxCocoa

struct Page<T> {
    let page: Int
    let data: [T]

    var nextPage: Int? {
        return data.isEmpty ? nil : page + 1
    }
}

final class PaginatedDataLoader<E> {
    let loading: Driver<Bool>
    let error: Driver<Error>
    let elements: Driver<[E]>

    private let disposeBag = DisposeBag()

    init(firstTrigger: Observable<Void>, nextTrigger: Observable<Void>, observableFactory: @escaping (Int) -> Observable<Page<E>>) {
        let activityIndicator = RxActivityIndicator()
        loading = activityIndicator.asDriver()
        
        let errorRelay = PublishRelay<Error>()
        error = errorRelay.asDriver(onErrorDriveWith: .never())
        
        func load(_ page: Int) -> Observable<Page<E>> {
            return observableFactory(page)
                .trackActivity(activityIndicator)
                .catchError { error in
                    errorRelay.accept(error)
                    return .empty()
                }
        }
        
        let lastPage = PublishSubject<Page<E>>()
        
        let firstPage = firstTrigger.flatMapLatest { load(1) }
        
        let nextPage = firstTrigger.flatMapLatest {
            nextTrigger.withLatestFrom(lastPage)
                .flatMapFirst { $0.nextPage.map { load($0) } ?? .empty() }
        }
        
        Observable.merge(firstPage, nextPage)
            .subscribe(lastPage)
            .disposed(by: disposeBag)
        
        elements = firstTrigger
            .flatMapLatest {
                lastPage.map { $0.data }
            }
            .asDriver(onErrorDriveWith: .never())
    }
}

