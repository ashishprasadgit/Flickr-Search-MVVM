//
//  Array+Extension.swift
//  FlickrApp
//
//  Created by Ashish Prasad on 27/09/17.
//  Copyright © 2017 Ashish Prasad. All rights reserved.
//

import Foundation

extension Array {
    static func filterNils(_ array: [Element?]) -> [Element] {
        return array.filter { $0 != nil }.map { $0! }
    }
    
    func filterNils() -> [Element] {
        return Array.filterNils(self)
    }
}
