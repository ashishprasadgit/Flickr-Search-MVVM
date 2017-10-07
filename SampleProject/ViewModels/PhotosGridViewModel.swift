//
//  PhotosGridViewModel.swift
//  FlickrApp
//
//  Created by Ashish Prasad on 07/10/17.
//  Copyright © 2017 Ashish Prasad. All rights reserved.
//

import Foundation
import Moya
import ReactiveSwift
import ReactiveCocoa
import Moya_ObjectMapper

class PhotosGridViewModel {
    var provider: Networking = Networking.newDefaultNetworking()
    
    // Input
    let deviceOrientation = MutableProperty<UIDeviceOrientation>(UIDevice.current.orientation)
    let visibleIndexes = MutableProperty<[Int]>([])
    
    // Outputs
    let dataSource = MutableProperty<[AnyObject]>([])
    let colsInScreen = MutableProperty<Int>(2)
    let showActivityIndicator = MutableProperty<Bool>(false)
    
    // Actions  
    
    //
    var searchQuery: String
    var page = 1
    var perPage = 100
    var isDataLoading = false
    
    init(searchQuery: String) {
        self.searchQuery = searchQuery
        self.dataSource.value = []
        
        self.showActivityIndicator.value = true
        self.fetchImages()
        
        // Local Binding
        self.colsInScreen <~ self.deviceOrientation.producer.map({ ($0.isLandscape) ? 3 : 2 })
    }
    
    func loadMoreData() {
        self .fetchImages()
    }
    
    //MARK:- Network Calls
    func fetchImages() {
        guard isDataLoading == false else {
            return
        }
        
        let request = APIs.photosList(searchQuery: searchQuery, page: page, perPage: perPage)
        self.provider.request(request)
            .mapObject(PhotosInfo.self)
            .take(first: 1)
            .start { [weak self] result in
                guard let me = self else { return }
                
                switch result {
                case let .value(response):
                    if let photo = response.photo, let page = response.page {
                        let newElements = photo.map({ GridCollectionViewCellModel(photoItem: $0) })
                        
                        var dataSource = me.dataSource.value
                        dataSource = dataSource + newElements
                        me.dataSource.value = dataSource
                        
                        self?.page = (page + 1)
                    }
                default:
                    break
                }
                
                self?.isDataLoading = false
                self?.showActivityIndicator.value = false
            }
    }
}
