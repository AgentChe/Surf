//
//  ProfileViewModel.swift
//  Surf
//
//  Created by Andrey Chernyshev on 19.07.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import RxSwift
import RxCocoa

final class ProfileViewModel {
    func sections() -> Driver<[ProfileTableSection]> {
        ProfileService
            .retrieve()
            .map { [weak self] profile -> [ProfileTableSection] in
                guard let `self` = self, let profile = profile else {
                    return []
                }
                
                return self.prepare(profile: profile)
            }
            .asDriver(onErrorJustReturn: [])
    }
}

// MARK: Private

private extension ProfileViewModel {
    func prepare(profile: Profile) -> [ProfileTableSection] {
        var result = [ProfileTableSection]()
        
        let personalItem = ProfileTableItem.personal(name: profile.name,
                                                     birthdate: profile.birthdate,
                                                     emoji: profile.emoji)
        let personalSection = ProfileTableSection(items: [personalItem])
        result.append(personalSection)
        
        return result
    }
}
