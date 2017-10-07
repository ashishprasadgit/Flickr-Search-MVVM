//
//  Storyboards.swift
//  FlickrApp
//
//  Created by Ashish Prasad on 27/09/17.
//  Copyright © 2017 Ashish Prasad. All rights reserved.
//

import UIKit

enum StoryBoards: String {
    case main = "Main"
    
    func instantiate() -> UIStoryboard {
        return UIStoryboard(name: self.rawValue, bundle: nil)
    }
}
