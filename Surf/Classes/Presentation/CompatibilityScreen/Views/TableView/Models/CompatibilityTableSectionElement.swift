//
//  CompatibilityTableSectionElement.swift
//  Surf
//
//  Created by Andrey Chernyshev on 05.09.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

enum CompatibilityTableSectionElement {
    case signs(sign1: ZodiacSign, sign2: ZodiacSign)
    case scores(CompatibilityTableScoresElement)
    case overallScore(Double)
    case text(String)
}
