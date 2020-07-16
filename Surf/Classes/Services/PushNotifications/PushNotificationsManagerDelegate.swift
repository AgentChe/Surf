//
//  PushNotificationsManagerDelegate.swift
//  shopChat
//
//  Created by Andrey Chernyshev on 01/06/2020.
//  Copyright © 2020 © ООО "СимбирСофт", 2019 г. «insuranceSimbirsoft Platform» - Интеллектуальная собственность ООО «СимбирСофт». All rights reserved.
//

protocol PushNotificationsManagerDelegate: class {
    func retrieved(status: PushNotificationsManager.PushNotificationsAuthorizationStatus)
    func retrieved(token: String?)
    func retrieved(model: PushNotificationModel)
}

extension PushNotificationsManagerDelegate {
    func retrieved(status: PushNotificationsManager.PushNotificationsAuthorizationStatus) {}
    func retrieved(token: String?) {}
    func retrieved(model: PushNotificationModel) {}
}
