//
//  OnboardingView.swift
//  Surf
//
//  Created by Andrey Chernyshev on 15.07.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import UIKit

final class OnboardingView: UIView {
    lazy var myGenderView = makeMyGenderView()
    lazy var showMeToGendersView = makeShowMeToGendersView()
    lazy var birthdayView = makeBirthdayView()
    lazy var photosView = makePhotosView()
    lazy var nameView = makeNameView()
    lazy var welcomeView = makeWelcomeView()
    lazy var notificationsView = makeNotificationsView()
}

// MARK: Lazy initialization

private extension OnboardingView {
    func makeMyGenderView() -> OnboardingMyGenderView {
        let view = OnboardingMyGenderView()
        view.backgroundColor = .white
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeShowMeToGendersView() -> OnboardingShowMeToGendersView {
        let view = OnboardingShowMeToGendersView()
        view.backgroundColor = .white
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeBirthdayView() -> OnboardingBirthdayView {
        let view = OnboardingBirthdayView()
        view.backgroundColor = .white
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makePhotosView() -> OnboardingPhotosView {
        let view = OnboardingPhotosView()
        view.backgroundColor = .white
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeNameView() -> OnboardingNameView {
        let view = OnboardingNameView()
        view.backgroundColor = .white
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeWelcomeView() -> OnboardingWelcomeView {
        let view = OnboardingWelcomeView()
        view.backgroundColor = .white
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeNotificationsView() -> OnboardingNotificationsView {
        let view = OnboardingNotificationsView()
        view.backgroundColor = .white
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
