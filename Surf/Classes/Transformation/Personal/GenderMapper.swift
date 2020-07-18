//
//  GenderMapper.swift
//  Surf
//
//  Created by Andrey Chernyshev on 18.07.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

final class GenderMapper {
    static func rawCode(from gender: Gender) -> Int {
        switch gender {
        case .male:
            return 1
        case .female:
            return 2
        }
    }
    
    static func lookingForCode(from genders: [Gender]) -> Int? {
        if genders.count == 2 {
            return 3
        }
        
        guard let gender = genders.first else {
            return nil
        }
        
        switch gender {
        case .male:
            return 1
        case .female:
            return 2
        }
    }
}
