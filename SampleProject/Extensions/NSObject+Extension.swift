//
//  NSObject+Extension.swift
//  FlickrApp
//
//  Created by Ashish Prasad on 27/09/17.
//  Copyright © 2017 Ashish Prasad. All rights reserved.
//

import Foundation

extension NSObject {
    static var nameOfClass: String {
        return String(describing: self)
    }
}
