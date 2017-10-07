//
//  GridCollectionViewCell.swift
//  FlickrApp
//
//  Created by Ashish Prasad on 07/10/17.
//  Copyright © 2017 Ashish Prasad. All rights reserved.
//

import UIKit
import ReactiveCocoa
import ReactiveSwift
import AlamofireImage

class GridCollectionViewCell: BaseCollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textLabel: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        imageView.af_cancelImageRequest()
        imageView.image = nil
    }
}

extension GridCollectionViewCell: ReactiveView {
    func bind(viewModel: AnyObject) {
        if let cellModel = viewModel as? GridCollectionViewCellModel {
            let headerDisposable = self.textLabel.reactive.text <~ cellModel.header
            imageView.af_setImage(withURL: cellModel.imageUrl)

            let cellDisposable: [Disposable?] = [headerDisposable]
            disposables = cellDisposable.flatMap({ ($0) })
        }
    }
}

