//
//  MainPageController.swift
//  Surf
//
//  Created by Andrey Chernyshev on 19.07.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import UIKit

final class MainPageController: UIPageViewController {
    weak var pageControllerDelegate: MainPageViewControllerDelegate?
    
    private var controllers = [UIViewController]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegate = self 
        dataSource = self
        
        if let firstVC = controllers.first {
            setViewControllers([firstVC], direction: .forward, animated: true)
        }
    }
}

// MARK: Make

extension MainPageController {
    static func make(viewControllers: [UIViewController]) -> MainPageController {
        let vc = MainPageController(transitionStyle: .scroll, navigationOrientation: .horizontal)
        vc.controllers = viewControllers
        return vc
    }
}

// MARK: UIPageViewControllerDataSource

extension MainPageController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard viewController == controllers.last else {
            return nil
        }
        
        return controllers.first
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard viewController == controllers.first else {
            return nil
        }
        
        return controllers.last
    }
}

// MARK: UIPageViewControllerDelegate

extension MainPageController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard
            let vc = viewControllers?.first,
            let index = controllers.firstIndex(of: vc)
        else {
            return
        }

        pageControllerDelegate?.changed(page: index)
    }
}

// MARK: MainTabBarViewDelegate

extension MainPageController: MainTabBarViewDelegate {
    func searchSelected() {
        guard
            let currentVC = controllers.last,
            let previousVC = dataSource?.pageViewController(self, viewControllerBefore: currentVC)
        else {
            return
        }
        
        setViewControllers([previousVC], direction: .reverse, animated: true)
    }
    
    func chatsSelected() {
        guard
            let currentVC = controllers.first,
            let nextVC = dataSource?.pageViewController(self, viewControllerAfter: currentVC)
        else {
            return
        }
        
        setViewControllers([nextVC], direction: .forward, animated: true)
    }
}
