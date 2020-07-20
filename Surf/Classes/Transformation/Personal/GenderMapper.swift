//
//  GenderMapper.swift
//  Surf
//
//  Created by Andrey Chernyshev on 18.07.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

final class GenderMapper {}

// MARK: Gender

extension GenderMapper {
    static func rawCode(from gender: Gender) -> Int {
        switch gender {
        case .male:
            return 1
        case .female:
            return 2
        }
    }
    
    static func gender(from rawCode: Int) -> Gender? {
        switch rawCode {
        case 1:
            return .male
        case 2:
            return .female
        default:
            return nil
        }
    }
}

// MARK: Looking for

extension GenderMapper {
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
    
    static func lookingFor(from code: Int) -> [Gender]? {
        switch code {
        case 1:
            return [.male]
        case 2:
            return [.female]
        case 3:
            return [.male, .female]
        default:
            return nil 
        }
    }
}
