//
//  MainTableViewModel.swift
//  FlickrApp
//
//  Created by Ashish Prasad on 28/09/17.
//  Copyright © 2017 Ashish Prasad. All rights reserved.
//

import Foundation
import ReactiveSwift
import ReactiveCocoa

class GridCollectionViewCellModel {
    // Outputs
    let header: MutableProperty<String?>
    let imageUrl: URL
    
    //
    init(photoItem: PhotoItem) {
        self.header = MutableProperty<String?>(photoItem.title)
        self.imageUrl = APIs.fetchImage(serverID: photoItem.server, secret: photoItem.secret, imageID: photoItem.id) .url()
    }
}
