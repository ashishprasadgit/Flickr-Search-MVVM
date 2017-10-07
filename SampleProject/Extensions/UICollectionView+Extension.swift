//
//  UITableViewCell+Extension.swift
//  FlickrApp
//
//  Created by Ashish Prasad on 27/09/17.
//  Copyright © 2017 Ashish Prasad. All rights reserved.
//

import UIKit

extension UICollectionView {
    func dequeueReusableCell<T: UICollectionViewCell>(cellType: T.Type, for indexPath: IndexPath) -> T {
        return self.dequeueReusableCell(withReuseIdentifier: cellType.nameOfClass, for: indexPath) as! T
    }
    
    func register<T: UICollectionViewCell>(cellType: T.Type) {
        self .register(T.nib(), forCellWithReuseIdentifier: T.nameOfClass)
    }
}
