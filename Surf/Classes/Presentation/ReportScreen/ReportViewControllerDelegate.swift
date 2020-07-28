//
//  ReportViewControllerDelegate.swift
//  Surf
//
//  Created by Andrey Chernyshev on 28.07.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

protocol ReportViewControllerDelegate: class {
    func reportViewController(reportWasCreated on: ReportOn)
}

extension ReportViewControllerDelegate {
    func reportViewController(reportWasCreated on: ReportOn) {}
}
