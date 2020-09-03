//
//  GetCompatibilitiesResponseMapper.swift
//  Surf
//
//  Created by Andrey Chernyshev on 03.09.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

final class GetCompatibilitiesResponseMapper {
    static func map(response: Any) -> Compatibilities? {
        guard
            let json = response as? [String: Any],
            let data = json["_data"] as? [String: [String: Any]]
        else {
            return nil
        }
        
        var list = [Compatibility]()
        
        for (withWhatZodiacSignThisComparedStringKey, compatibilitiesJson) in data {
            guard
                let withWhatZodiacSignThisComparedIntKey = Int(withWhatZodiacSignThisComparedStringKey),
                let withWhatZodiacSignThisCompared = ZodiacSignMapper.zodiacSign(from: withWhatZodiacSignThisComparedIntKey)
            else {
                continue
            }
            
            for (whatZodiacSignHasThisStringKey, compatibilityUnitsJson) in compatibilitiesJson {
                guard
                    let whatZodiacSignHasThisIntKey = Int(whatZodiacSignHasThisStringKey),
                    let whatZodiacSignHasThis = ZodiacSignMapper.zodiacSign(from: whatZodiacSignHasThisIntKey),
                    let units = CompatibilityUnits.parseFromDictionary(any: compatibilityUnitsJson)
                else {
                    continue
                }
                
                let compatibility = Compatibility(units: units,
                                                  whatZodiacSignHasThis: whatZodiacSignHasThis,
                                                  withWhatZodiacSignThisCompared: withWhatZodiacSignThisCompared)
                
                list.append(compatibility)
            }
        }
        
        return Compatibilities(list: list)
    }
}
