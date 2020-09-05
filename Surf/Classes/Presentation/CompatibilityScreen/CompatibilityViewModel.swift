//
//  CompatibilityViewModel.swift
//  Surf
//
//  Created by Andrey Chernyshev on 04.09.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import RxSwift
import RxCocoa

final class CompatibilityViewModel {
    private let compatibilityManager = CompatibilityManagerCore()
    
    func sections(userZodiacSign: ZodiacSign, proposedInterlocutorZodiacSign: ZodiacSign) -> Driver<[CompatibilityTableSection]> {
        compatibilityManager
            .rxGetCompatibilities(forceUpdate: false)
            .map { [weak self] compatibilities -> [CompatibilityTableSection] in
                guard let compatibility = compatibilities?[userZodiacSign, proposedInterlocutorZodiacSign] else {
                    return []
                }
                
                let units = compatibility.units
                
                return self?.createSections(units: units,
                                            userZodiacSign: userZodiacSign,
                                            proposedInterlocutorZodiacSign: proposedInterlocutorZodiacSign) ?? []
            }
            .asDriver(onErrorJustReturn: [])
    }
}

// MARK: Private

private extension CompatibilityViewModel {
    func createSections(units: CompatibilityUnits,
                        userZodiacSign: ZodiacSign,
                        proposedInterlocutorZodiacSign: ZodiacSign) -> [CompatibilityTableSection] {
        var sections = [CompatibilityTableSection]()
        
        let signsElement = CompatibilityTableSectionElement.signs(sign1: userZodiacSign, sign2: proposedInterlocutorZodiacSign)
        let signsSection = CompatibilityTableSection(items: [signsElement])
        sections.append(signsSection)
        
        let scores = CompatibilityTableScoresElement(love: units.loveScore,
                                                     trust: units.trustScore,
                                                     emotions: units.emotionsScore,
                                                     values: units.valuesScore)
        let scoresElement = CompatibilityTableSectionElement.scores(scores)
        let scoresSection = CompatibilityTableSection(items: [scoresElement])
        sections.append(scoresSection)
        
        let overallScoreElement = CompatibilityTableSectionElement.overallScore(units.generalScore)
        let overallScoreSection = CompatibilityTableSection(items: [overallScoreElement])
        sections.append(overallScoreSection)
        
        let textElement = CompatibilityTableSectionElement.text(units.compatibility)
        let textSection = CompatibilityTableSection(items: [textElement])
        sections.append(textSection)
        
        return sections
    }
}
