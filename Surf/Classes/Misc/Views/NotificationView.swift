//
//  NotificationView.swift
//  Surf
//
//  Created by Andrey Chernyshev on 14.07.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import UIKit
import NotificationBannerSwift

final class NotificationView {}

// MARK: Management

extension NotificationView {
     static func notify(with text: String) {
        let attrs = text.attributed(with: TextAttributes()
            .font(Font.OpenSans.semibold(size: 17.scale))
            .textColor(UIColor.black)
            .textAlignment(.center))
        
        NotificationBanner(attributedTitle: attrs, style: BannerStyle.warning).show()
    }
}
