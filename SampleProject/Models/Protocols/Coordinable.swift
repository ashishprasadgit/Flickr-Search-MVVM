//
//  Coordinable.swift
//  FlickrApp
//
//  Created by Ashish Prasad on 27/09/17.
//  Copyright © 2017 Ashish Prasad. All rights reserved.
//

import UIKit

protocol Coordinable {
    associatedtype ViewModel
    var viewModel: ViewModel! {get set}    
}

@objc protocol ReactiveView {
    func bind(viewModel: AnyObject)
}
