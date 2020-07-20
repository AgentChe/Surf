//
//  ProfileService.swift
//  FAWN
//
//  Created by Andrey Chernyshev on 22/04/2020.
//  Copyright © 2020 Алексей Петров. All rights reserved.
//

import RxSwift

final class ProfileService {
    private struct Constants {
        static let profileKey = "profile_cached_key"
    }
}

//  MARK: Retrieve

extension ProfileService {
    static func retrieve() -> Single<Profile?> {
        guard let userToken = SessionService.shared.userToken else {
            return .deferred { .just(nil) }
        }
        
        return RestAPITransport()
            .callServerApi(requestBody: GetProfileRequest(userToken: userToken))
            .map { Profile.parseFromDictionary(any: $0) }
            .do(onSuccess: { profile in
                guard let profile = profile, let data = try? Profile.encode(object: profile) else {
                    return
                }
                
                UserDefaults.standard.set(data, forKey: Constants.profileKey)
            })
    }
    
    static func get() -> Profile? {
        guard let data = UserDefaults.standard.data(forKey: Constants.profileKey) else {
            return nil
        }
        
        return try? Profile.parse(from: data)
    }
}

// MARK: Set

extension ProfileService {
    static func fillProfile(myGender: Gender, showMeToGenders: [Gender], birthdate: Date, name: String, pushNotificationsToken: String?) -> Single<Bool> {
        guard let userToken = SessionService.shared.userToken else {
            return .deferred { .just(false) }
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let birthdateInFormat = formatter.string(from: birthdate)
        
        return RestAPITransport()
            .callServerApi(requestBody: SetRequest(userToken: userToken,
                                                   name: name,
                                                   birthdate: birthdateInFormat,
                                                   gender: GenderMapper.rawCode(from: myGender),
                                                   lookingFor: GenderMapper.lookingForCode(from: showMeToGenders),
                                                   pushNotificationsToken: pushNotificationsToken))
            .map { (try? !CheckResponseForError.isError(jsonResponse: $0)) ?? false }
    }
}

// MARK: Emoji

extension ProfileService {
    static func randomizeEmoji() -> Single<String?> {
        guard let userToken = SessionService.shared.userToken else {
            return .deferred { .just(nil) }
        }
        
        return RestAPITransport()
            .callServerApi(requestBody: RandomizeEmojiRequest(userToken: userToken))
            .map { EmojiMapper.emoji(response: $0) }
    }
}
