//
//  PushNotificationsManager.swift
//  shopChat
//
//  Created by Andrey Chernyshev on 01/06/2020.
//  Copyright © 2020 © ООО "СимбирСофт", 2019 г. «insuranceSimbirsoft Platform» - Интеллектуальная собственность ООО «СимбирСофт». All rights reserved.
//

import UserNotifications
import UIKit.UIApplication
import Firebase

final class PushNotificationsManager: NSObject {
    enum PushNotificationsAuthorizationStatus {
        case authorized, denied, notDetermined
    }
    
    static let shared = PushNotificationsManager()
    
    private let notificationsCenter = UNUserNotificationCenter.current()
    
    private var delegates = [Weak<PushNotificationsManagerDelegate>]()
    
    private override init() {}
    
    func configure(launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        notificationsCenter.delegate = self
    }
}

// MARK: UNUserNotificationCenterDelegate

extension PushNotificationsManager: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        received(userInfo: response.notification.request.content.userInfo)
    }
}

// MARK: Received messages

extension PushNotificationsManager {
    func received(userInfo: [AnyHashable : Any]) {
        guard let model = PushNotificationModelMapper.map(userInfo: userInfo) else {
            return
        }
        
        DispatchQueue.main.async { [weak self] in
            self?.delegates.forEach { $0.weak?.retrieved(model: model) }
        }
    }
}

// MARK: Request authorization

extension PushNotificationsManager {
    func requestAuthorization() {
        notificationsCenter.requestAuthorization(options: [.alert, .sound]) { granted, _ in
            DispatchQueue.main.async {
                if granted {
                    UIApplication.shared.registerForRemoteNotifications()
                } else {
                    self.delegates.forEach { $0.weak?.retrieved(token: nil) }
                }
            }
        }
    }
    
    func received(pushToken: Data?, error: Error?) {
        Messaging.messaging().apnsToken = pushToken
        
        DispatchQueue.main.async { [weak self] in
            if error == nil, let token = Messaging.messaging().fcmToken {
                self?.delegates.forEach { $0.weak?.retrieved(token: token) }
            } else {
                self?.delegates.forEach { $0.weak?.retrieved(token: nil) }
            }
        }
    }
}

// MARK: Authorization Status

extension PushNotificationsManager {
    static func retriveAuthorizationStatus(handler: ((PushNotificationsAuthorizationStatus) -> Void)? = nil) {
        shared.notificationsCenter.getNotificationSettings { settings in
            DispatchQueue.main.async {
                let result: PushNotificationsAuthorizationStatus
                
                switch settings.authorizationStatus {
                case .authorized:
                    result = .authorized
                case .notDetermined:
                    result = .notDetermined
                default:
                    result = .denied
                }
                
                handler?(result)
                shared.delegates.forEach { $0.weak?.retrieved(status: result) }
            }
        }
    }
}

// MARK: Observer

extension PushNotificationsManager {
    func add(observer: PushNotificationsManagerDelegate) {
        let weakly = observer as AnyObject
        delegates.append(Weak<PushNotificationsManagerDelegate>(weakly))
        delegates = delegates.filter { $0.weak != nil }
    }
    
    func remove(observer: PushNotificationsManagerDelegate) {
        if let index = delegates.firstIndex(where: { $0.weak === observer }) {
            delegates.remove(at: index)
        }
    }
}
