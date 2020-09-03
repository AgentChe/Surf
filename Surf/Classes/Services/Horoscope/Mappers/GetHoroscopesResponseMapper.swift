//
//  GetHoroscopesResponseMapper.swift
//  Surf
//
//  Created by Andrey Chernyshev on 03.09.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

final class GetHoroscopesResponseMapper {
    static func map(_ response: Any) -> Horoscopes? {
        guard
            let json = response as? [String: Any],
            let data = json["_data"] as? [String: Any]
        else {
            return nil
        }
        
        var list = [Horoscope]()
        
        for (key, value) in data {
            guard
                let on = HoroscopeOn(rawValue: key),
                let valueJson = value as? [String: Any],
                let articlesJsonArray = valueJson["articles"] as? [[String: Any]]
            else {
                continue
            }
            
            let articles = articlesJsonArray.compactMap { HoroscopeArticle.parseFromDictionary(any: $0) }
            
            guard !articles.isEmpty else {
                continue
            }
            
            let horoscope = Horoscope(on: on, articles: articles)
            
            list.append(horoscope)
        }
        
        guard !list.isEmpty else {
            return nil
        }
        
        return Horoscopes(list: list)
    }
}
