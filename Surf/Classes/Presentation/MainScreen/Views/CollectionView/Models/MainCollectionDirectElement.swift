//
//  MainCollectionDirectElement.swift
//  Surf
//
//  Created by Andrey Chernyshev on 04.09.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

struct MainCollectionDirectElement {
    enum Direct {
        case horoscope
        case search
        case chats
    }
    
    let direct: Direct
    let imageName: String
    let title: String
    let subTitle: String
}
