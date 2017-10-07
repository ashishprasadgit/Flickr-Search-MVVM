//
//  BaseTableViewCell.swift
//  FlickrApp
//
//  Created by Ashish Prasad on 29/09/17.
//  Copyright © 2017 Ashish Prasad. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    lazy var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    lazy var greyView: UIView = { [unowned self] in
        let greyView = UIView()
        greyView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
        greyView.backgroundColor = UIColor.black
        greyView.alpha = 0.5
        return greyView
    }()
    
    func animateActivityIndicator(_ animate: Bool) {
        if animate {
            activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
            activityIndicator.center = self.view.center
            activityIndicator.hidesWhenStopped = true
            activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
            view.addSubview(activityIndicator)
            activityIndicator.startAnimating()
            self.view.addSubview(greyView)
        }
        else {
            self.activityIndicator.stopAnimating()
            self.greyView.removeFromSuperview()
        }
    }
}
