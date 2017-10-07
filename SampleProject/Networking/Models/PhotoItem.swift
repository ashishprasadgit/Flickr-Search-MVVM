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

struct PhotoItem: Mappable {
    var id: String!
    var server: String!
    var secret: String!
    var title: String!
    
    init?(map: Map) {

    }
    
    mutating func mapping(map: Map) {
        id <- map["id"]
        server <- map["server"]
        secret <- map["secret"]
        title <- map["title"]
    }
}
