//
//  AppCoordinator.swift
//  FlickrApp
//
//  Created by Ashish Prasad on 27/09/17.
//  Copyright © 2017 Ashish Prasad. All rights reserved.
//

import Foundation

import UIKit

//Handles the transition between UIViewControllers, and new instanciation
class AppCoordinator {
    static let shared = AppCoordinator()
    
    private var window: UIWindow!
    
    fileprivate var rootController: UIViewController! {
        didSet {
            self.window.rootViewController = rootController
        }
    }
    
    fileprivate var navigationController = UINavigationController()
    
    func start(forWindow window: UIWindow) {
        self.window = window
        
        let vc = MainViewController.instantiate(fromStoryboard: StoryBoards.main)
        vc.viewModel = MainViewModel()
        
        var viewController = navigationController.viewControllers
        viewController .append(vc)
        navigationController.viewControllers = viewController
        
        self.rootController = navigationController
    }
}

// Routing Logic
extension AppCoordinator {    
    func push(viewController: UIViewController) {
        self.navigationController .pushViewController(viewController, animated: true)
    }
}

