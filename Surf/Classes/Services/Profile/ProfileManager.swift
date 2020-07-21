//
//  ProfileManager.swift
//  FAWN
//
//  Created by Andrey Chernyshev on 22/04/2020.
//  Copyright © 2020 Алексей Петров. All rights reserved.
//

import RxSwift
import RxCocoa

final class ProfileManager {
    static let shared = ProfileManager()
    
    private struct Constants {
        static let profileKey = "profile_cached_key"
    }
    
    private var delegates = [Weak<ProfileManagerDelegate>]()
    
    fileprivate let retrievedTrigger = PublishRelay<Profile>()
    fileprivate let updatedTrigger = PublishRelay<Profile>()
    
    private init() {}
}

//  MARK: Retrieve

extension ProfileManager {
    static func retrieve() -> Single<Profile?> {
        guard let userToken = SessionService.shared.userToken else {
            return .deferred { .just(nil) }
        }
        
        return RestAPITransport()
            .callServerApi(requestBody: GetProfileRequest(userToken: userToken))
            .map { Profile.parseFromDictionary(any: $0) }
            .do(onSuccess: { profile in
                guard let profile = profile, save(profile: profile) else {
                    return
                }
                
                ProfileManager.shared.delegates.forEach {
                    $0.weak?.profileManager(retrieved: profile)
                }
                
                ProfileManager.shared.retrievedTrigger.accept(profile)
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

extension ProfileManager {
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
    
    static func change(lookingFor: [Gender], minAge: Int, maxAge: Int) -> Single<Bool> {
        guard let userToken = SessionService.shared.userToken else {
            return .deferred { .just(false) }
        }
        
        return RestAPITransport()
            .callServerApi(requestBody: SetRequest(userToken: userToken, lookingFor: GenderMapper.lookingForCode(from: lookingFor), minAge: minAge, maxAge: maxAge))
            .map { (try? !CheckResponseForError.isError(jsonResponse: $0)) ?? false }
            .do(onSuccess: { success in
                guard success, let profile = get() else {
                    return
                }
                
                let updated = ProfileBuilder()
                    .initial(profile: profile)
                    .lookingFor(lookingFor)
                    .minAge(minAge)
                    .maxAge(maxAge)
                    .build()
                
                guard save(profile: updated) else {
                    return
                }
                
                ProfileManager.shared.delegates.forEach( {
                    $0.weak?.profileMagager(updated: updated)
                })
                
                ProfileManager.shared.updatedTrigger.accept(updated)
            })
    }
}

// MARK: Emoji

extension ProfileManager {
    static func randomizeEmoji() -> Single<String?> {
        guard let userToken = SessionService.shared.userToken else {
            return .deferred { .just(nil) }
        }
        
        return RestAPITransport()
            .callServerApi(requestBody: RandomizeEmojiRequest(userToken: userToken))
            .map { EmojiMapper.emoji(response: $0) }
            .do(onSuccess: { emoji in
                guard let emoji = emoji, let profile = get() else {
                    return
                }
                
                let updated = ProfileBuilder()
                    .initial(profile: profile)
                    .emoji(emoji)
                    .build()
                
                guard save(profile: updated) else {
                    return
                }
                
                ProfileManager.shared.delegates.forEach( {
                    $0.weak?.profileMagager(updated: updated)
                })
                
                ProfileManager.shared.updatedTrigger.accept(updated)
            })
    }
}

// MARK: Observer

extension ProfileManager {
    func add(observer: ProfileManagerDelegate) {
        let weakly = observer as AnyObject
        delegates.append(Weak<ProfileManagerDelegate>(weakly))
        delegates = delegates.filter { $0.weak != nil }
    }
    
    func remove(observer: ProfileManagerDelegate) {
        if let index = delegates.firstIndex(where: { $0.weak === observer }) {
            delegates.remove(at: index)
        }
    }
}

// MARK: ReactiveCompatible

extension ProfileManager: ReactiveCompatible {}

// MARK: Rx signals

extension Reactive where Base: ProfileManager {
    var retrieved: Signal<Profile> {
        base.retrievedTrigger.asSignal()
    }
    
    var updated: Signal<Profile> {
        base.updatedTrigger.asSignal()
    }
}

// MARK: Private

private extension ProfileManager {
    @discardableResult
    private static func save(profile: Profile) -> Bool {
        guard let data = try? Profile.encode(object: profile) else {
            return false
        }
        
        UserDefaults.standard.set(data, forKey: Constants.profileKey)
        
        return true
    }
}
