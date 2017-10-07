//
//  UITableViewCell+Extension.swift
//  FlickrApp
//
//  Created by Ashish Prasad on 27/09/17.
//  Copyright © 2017 Ashish Prasad. All rights reserved.
//

import UIKit

extension UIView {
    class func nib() -> UINib {
        let nibIdentifier = self.nameOfClass
        return UINib(nibName: nibIdentifier, bundle: nil)
    }
}

