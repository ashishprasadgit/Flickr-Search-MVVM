//
//  ArgoUser.swift
//  FlickrApp
//
//  Created by Ashish Prasad on 28/09/17.
//  Copyright © 2017 Ashish Prasad. All rights reserved.
//
//

import Foundation
import ObjectMapper

struct PhotosInfo: Mappable {
    var page: Int!
    var pages: Int!
    var perPage: Int!
    
    var photo: [PhotoItem]?
    
    init?(map: Map) {
        guard let _ = map.JSON["photos"] else {
            return nil
        }
    }
    
    mutating func mapping(map: Map) {
        
        page <- map["photos.page"]
        pages <- map["photos.pages"]
        perPage <- map["photos.perPage"]
        
        photo <- map["photos.photo"]
    }
}
