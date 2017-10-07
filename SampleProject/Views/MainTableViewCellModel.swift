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

class MainTableViewCellModel {
    // Input
    
    // Outputs
    let header: MutableProperty<String?>
    
    init(header: String?) {
        self.header = MutableProperty<String?>(header)
    }
}
