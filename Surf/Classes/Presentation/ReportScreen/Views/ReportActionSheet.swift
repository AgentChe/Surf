//
//  ReportActionSheet.swift
//  Surf
//
//  Created by Andrey Chernyshev on 28.07.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import UIKit

final class ReportActionSheet {
    func prepare(handler: @escaping ((ReportType?) -> Void)) -> UIAlertController {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Report.InappropriateMessages".localized, style: .default) { _ in
            handler(.inappropriateMessages)
        })
        
        alert.addAction(UIAlertAction(title: "Report.InappropriatePhotos".localized, style: .default) { _ in
            handler(.inappropriatePhotos)
        })
        
        alert.addAction(UIAlertAction(title: "Report.FeelLikeSpam".localized, style: .default) { _ in
            handler(.spam)
        })
        
        alert.addAction(UIAlertAction(title: "Report.Other".localized, style: .default) { _ in
            handler(.other)
        })
        
        alert.addAction(UIAlertAction(title: "Cancel".localized, style: .cancel) { _ in
            handler(nil)
        })
        
        return alert
    }
}
