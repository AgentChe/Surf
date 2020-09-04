//
//  HoroscopeViewModel.swift
//  Surf
//
//  Created by Andrey Chernyshev on 04.09.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import RxSwift
import RxCocoa

final class HoroscopeViewModel {
    let selectHoroscopeOn = PublishRelay<HoroscopeOn>()
    let expandArticleId = PublishRelay<String>()
    
    private let horoscopeManager = HoroscopeManagerCore()
    
    func sections() -> Driver<[HoroscopeTableSection]> {
        Driver
            .combineLatest(createHoroscopeOnSection(), createArticlesSections()) { [$0] + $1 }
    }
}

// MARK: Private

private extension HoroscopeViewModel {
    func createHoroscopeOnSection() -> Driver<HoroscopeTableSection> {
        getSelectedHoroscopeOn()
            .map {
                let element = HoroscopeTableSectionElement.horoscopeOn($0)
                let section = HoroscopeTableSection(elements: [element])
                
                return section
            }
    }
    
    func createArticlesSections() -> Driver<[HoroscopeTableSection]> {
        Driver
            .combineLatest(getHoroscopes(), getExpandedArticlesIds(), getSelectedHoroscopeOn()) { horoscopes, expandedArticlesIds, on in
                guard let articles = horoscopes?[on]?.articles else {
                    return [HoroscopeTableSection]()
                }
                
                return articles
                    .enumerated()
                    .map { item -> HoroscopeTableSection in
                        let (index, article) = item
                        
                        let id = String(describing: on) + String(index)
                        
                        let articleElement = HoroscopeTableArticleElement(id: id,
                                                                          title: article.header,
                                                                          text: article.text,
                                                                          isExpanded: expandedArticlesIds.contains(id))
                        
                        let element = HoroscopeTableSectionElement.article(articleElement)
                        let section = HoroscopeTableSection(elements: [element])
                        
                        return section
                    }
            }
    }
    
    func getProfile() -> Single<Profile?> {
        if let profile = ProfileManager.get() {
            return .deferred { .just(profile) }
        }
        
        return ProfileManager
            .retrieve()
            .catchErrorJustReturn(nil)
    }
    
    func getHoroscopes() -> Driver<Horoscopes?> {
        getProfile()
            .map { [horoscopeManager] profile -> Horoscopes? in
                guard
                    let profile = profile,
                    let zodiacSign = ZodiacManager.shared.zodiac(at: profile.birthdate)?.sign
                else {
                    return nil
                }
            
                return horoscopeManager.getHoroscopes(for: zodiacSign)
            }
            .asDriver(onErrorJustReturn: nil)
    }
    
    func getExpandedArticlesIds() -> Driver<Set<String>> {
        expandArticleId
            .distinctUntilChanged()
            .scan(Set()) { old, new -> Set<String> in
                var copy = old
                copy.insert(new)
                return copy
            }
            .asDriver(onErrorJustReturn: Set())
            .startWith(Set())
    }
    
    func getSelectedHoroscopeOn() -> Driver<HoroscopeOn> {
        selectHoroscopeOn
            .startWith(.today)
            .distinctUntilChanged()
            .asDriver(onErrorDriveWith: .empty())
    }
}
