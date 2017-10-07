//
//  UserDefaultManager.swift
//  FlickrApp
//
//  Created by Ashish Prasad on 07/10/17.
//  Copyright © 2017 Ashish Prasad. All rights reserved.
//

import Foundation

class SearchCache {
    static let instance = SearchCache()
    
    let searchQueries = NSMutableOrderedSet()
    
    func update(recentSearch query: String) {
        searchQueries.insert(query, at: 0)
    }
}
