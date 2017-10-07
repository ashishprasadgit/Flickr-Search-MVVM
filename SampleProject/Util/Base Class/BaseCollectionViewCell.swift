
//
//  BaseTableViewCell.swift
//  FlickrApp
//
//  Created by Ashish Prasad on 29/09/17.
//  Copyright © 2017 Ashish Prasad. All rights reserved.
//

import UIKit
import ReactiveSwift
import ReactiveCocoa

class BaseCollectionViewCell: UICollectionViewCell {
    var disposables = [Disposable]()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        for disposable in disposables {
            disposable.dispose()
        }
        disposables.removeAll(keepingCapacity: true)
    }
}
