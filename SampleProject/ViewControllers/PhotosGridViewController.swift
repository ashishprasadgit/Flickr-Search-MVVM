//
//  PhotosGridViewController.swift
//  FlickrApp
//
//  Created by Ashish Prasad on 07/10/17.
//  Copyright © 2017 Ashish Prasad. All rights reserved.
//

import UIKit
import ReactiveSwift
import ReactiveCocoa

class PhotosGridViewController: BaseViewController, Coordinable {
    
    typealias ViewModel = PhotosGridViewModel
    var viewModel: ViewModel!
    var screenSize = CGSize.zero
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        
        // Registering Collection View
        collectionView .register(cellType: GridCollectionViewCell.self)
        collectionView.dataSource = self
        collectionView.delegate = self
        
        // Binding View Model
        self .bindViewModel()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        screenSize = self.view.bounds.size
        self .invalidateLayout()
    }
    
    //MARK:- Binding
    private func bindViewModel() {
        viewModel.dataSource.producer.take(during: self.reactive.lifetime)
            .observe(on: UIScheduler())
            .startWithValues({ [unowned self] (dataSource) in
                self.collectionView.reloadData()
            })
        
        viewModel.colsInScreen.producer.take(during: self.reactive.lifetime)
            .observe(on: UIScheduler())
            .startWithValues({ [unowned self] (_) in
                self .invalidateLayout()
            })
        
        viewModel.showActivityIndicator.producer.take(during: self.reactive.lifetime)
            .observe(on: UIScheduler())
            .startWithValues({ [unowned self] (showActivityIndicatory) in
                self .animateActivityIndicator(showActivityIndicatory)
            })
    }
    
    func invalidateLayout() {
        let cols = viewModel.colsInScreen.value
        
        let flowLayout = self.collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        let sectionInset = flowLayout.sectionInset
        
        let width = (screenSize.width - sectionInset.left - sectionInset.right - CGFloat((cols - 1) * 6)) / CGFloat(cols)
        let height = width
        
        flowLayout.itemSize = CGSize(width: width, height: height)
        flowLayout .invalidateLayout()
    }
    
    //MARK:- Rotation Handling
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        screenSize = size
        viewModel.deviceOrientation.value = UIDevice.current.orientation
    }
}

extension PhotosGridViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.dataSource.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView .dequeueReusableCell(cellType: GridCollectionViewCell.self, for: indexPath)
        cell .bind(viewModel: viewModel.dataSource.value[indexPath.row])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let index = indexPath.row
        if (index + 6 > viewModel.dataSource.value.count) {
            viewModel .loadMoreData()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

    }
}
