//
//  SessionService.swift
//  FAWN
//
//  Created by Andrey Chernyshev on 18/04/2020.
//  Copyright © 2020 Алексей Петров. All rights reserved.
//

import RxSwift
import FBSDKLoginKit

final class SessionService {
    static let shared = SessionService()
    
    private let appleSignInManager = AppleSignInManager()
    
    private init() {}
    
    private struct Constants {
        static let userTokenKey = "user_token_key"
        static let userIdKey = "user_id_key"
    }
}

// MARK: Token

extension SessionService {
    var userToken: String? {
        UserDefaults.standard.string(forKey: Constants.userTokenKey)
    }
    
    var userId: Int? {
        UserDefaults.standard.value(forKey: Constants.userIdKey) as? Int
    }
    
    static func check(token: String) -> Single<Bool> {
        RestAPITransport()
            .callServerApi(requestBody: CheckUserTokenRequest(userToken: token))
            .map { (try? !CheckResponseForError.isError(jsonResponse: $0)) ?? false }
            .do(onSuccess: { success in
                if success {
                    AppStateProxy.UserTokenProxy.userTokenCheckedWithSuccessResult.accept(Void())
                }
            })
    }
}

// MARK: Create user

extension SessionService {
    static func createUser(with email: String) -> Single<Token?> {
        RestAPITransport()
            .callServerApi(requestBody: CreateUserRequest(email: email))
            .map { TokenTransformation.fromCreateUserResponse($0) }
            .do(onSuccess: { token in
                UserDefaults.standard.set(token?.token, forKey: Constants.userTokenKey)
                UserDefaults.standard.set(token?.userId, forKey: Constants.userIdKey)
                
                if token?.token != nil {
                    AppStateProxy.UserTokenProxy.didUpdatedUserToken.accept(Void())
                }
            })
    }
    
    static func facebookUser() -> Single<Token?> {
        signInFacebook()
            .flatMap { token in
                guard let token = token else {
                    return .deferred { .just(nil) }
                }
                
                return RestAPITransport()
                    .callServerApi(requestBody: FacebookLoginRequest(facebookToken: token))
                    .map { TokenTransformation.fromCreateUserResponse($0) }
            }
            .do(onSuccess: { token in
                UserDefaults.standard.set(token?.token, forKey: Constants.userTokenKey)
                UserDefaults.standard.set(token?.userId, forKey: Constants.userIdKey)
                
                if token?.token != nil {
                    AppStateProxy.UserTokenProxy.didUpdatedUserToken.accept(Void())
                }
            })
    }
    
    @available(iOS 13.0, *)
    static func appleUser() -> Single<Token?> {
        SessionService.shared
            .appleSignInManager
            .signIn()
            .flatMap { credentials -> Single<Token?> in
                guard let credentials = credentials else {
                    return .just(nil)
                }
                
                return RestAPITransport()
                    .callServerApi(requestBody: AppleLoginRequest(identificator: credentials.identifier))
                    .map { TokenTransformation.fromCreateUserResponse($0) }
            }
            .do(onSuccess: { token in
                UserDefaults.standard.set(token?.token, forKey: Constants.userTokenKey)
                UserDefaults.standard.set(token?.userId, forKey: Constants.userIdKey)
                
                if token?.token != nil {
                    AppStateProxy.UserTokenProxy.didUpdatedUserToken.accept(Void())
                }
            })
    }
}

// MARK: Confirm code

extension SessionService {
    static func requireConfirmCode(email: String) -> Single<Bool> {
        RestAPITransport()
            .callServerApi(requestBody: RequireConfirmCodeRequest(email: email))
            .map { (try? !CheckResponseForError.isError(jsonResponse: $0)) ?? false }
    }
    
    static func confirmCode(email: String, code: String) -> Single<Token?> {
        RestAPITransport()
            .callServerApi(requestBody: ConfirmCodeRequest(email: email, code: code))
            .map { TokenTransformation.fromCreateUserResponse($0) }
            .do(onSuccess: { token in
                UserDefaults.standard.set(token?.token, forKey: Constants.userTokenKey)
                UserDefaults.standard.set(token?.userId, forKey: Constants.userIdKey)
                
                if token?.token != nil {
                    AppStateProxy.UserTokenProxy.didUpdatedUserToken.accept(Void())
                }
            })
    }
}

// MARK: Banned

extension SessionService {
    static func banned() -> Single<Bool?> {
        guard let userToken = SessionService.shared.userToken else {
            return .deferred { .just(false) }
        }
        
        return RestAPITransport()
            .callServerApi(requestBody: CheckUserBannedRequest(userToken: userToken))
            .map { CheckUserBannedResponseMapper.banned(response: $0) } 
    }
}

// MARK: Delete user

extension SessionService {
    static func deleteUser() -> Single<Bool> {
        guard let userToken = SessionService.shared.userToken else {
            return .deferred { .just(false) }
        }
        
        return RestAPITransport()
            .callServerApi(requestBody: DeleteAccountRequest(userToken: userToken))
            .map { (try? !CheckResponseForError.isError(jsonResponse: $0)) ?? false }
            .do(onSuccess: { success in
                guard success else {
                    return
                }
                
                UserDefaults.standard.removeObject(forKey: Constants.userTokenKey)
                UserDefaults.standard.removeObject(forKey: Constants.userIdKey)
            })
    }
}

// MARK: Private

private extension SessionService {
    static func signInFacebook() -> Single<String?> {
        Single.create { event in
            AccessToken.current = nil
            
            let manager = LoginManager()
            manager.logOut()
            
            manager.logIn(permissions: ["public_profile", "email"], from: nil) { _, _ in
                event(.success(AccessToken.current?.tokenString))
            }
            
            return Disposables.create()
        }
    }
}
