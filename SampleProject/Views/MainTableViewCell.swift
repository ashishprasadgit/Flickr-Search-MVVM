//
//  MainTableViewCell.swift
//  FlickrApp
//
//  Created by Ashish Prasad on 28/09/17.
//  Copyright © 2017 Ashish Prasad. All rights reserved.
//

import UIKit
import ReactiveCocoa
import ReactiveSwift

class MainTableViewCell: BaseTableViewCell {
    @IBOutlet weak var cellHeaderLabel: UILabel!
}

extension MainTableViewCell: ReactiveView {
    func bind(viewModel: AnyObject) {
        if let cellModel = viewModel as? MainTableViewCellModel {
            let headerDisposable = self.cellHeaderLabel.reactive.text <~ cellModel.header
            
            disposables = [headerDisposable].flatMap({ ($0) })
        }
    }
}
