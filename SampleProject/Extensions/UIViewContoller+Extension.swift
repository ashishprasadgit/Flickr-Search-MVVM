//
//  UIViewContoller+Extension.swift
//  FlickrApp
//
//  Created by Ashish Prasad on 27/09/17.
//  Copyright © 2017 Ashish Prasad. All rights reserved.
//

import UIKit

//Add storyboards here, for easy instanciation
extension UIViewController {
    func embedInNavController() -> UINavigationController {
        return UINavigationController(rootViewController: self)
    }
    
    class func instantiate(fromStoryboard storyboard: StoryBoards) -> Self {
        return instantiateFromStoryboardHelper(storyboard: storyboard)
    }
    
    private class func instantiateFromStoryboardHelper<T>(storyboard: StoryBoards) -> T {
        return storyboard.instantiate().instantiateViewController(withIdentifier: self.nameOfClass) as! T
    }
}
