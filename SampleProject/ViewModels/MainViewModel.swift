//
//  MainViewModel.swift
//  FlickrApp
//
//  Created by Ashish Prasad on 27/09/17.
//  Copyright © 2017 Ashish Prasad. All rights reserved.
//

import UIKit
import ReactiveSwift
import ReactiveCocoa

class MainViewModel {
    // Input
    let searchText = MutableProperty<String?>(nil)
    
    // Outputs
    let dataSource = MutableProperty<[AnyObject]>([])
    let searchButtonEnabled = MutableProperty<Bool>(false)
    let pushPhotosGridVC = MutableProperty<PhotosGridViewModel?>(nil)
    
    // Actions
    lazy var searchAction: Action<Void, Bool, NSError> = { [unowned self] in
        return Action(enabledIf: self.searchButtonEnabled, execute: { _ in
            self .executeSearch(forQuery: self.searchText.value!)
            
            return SignalProducer(value: true)
        })
    }()
    
    var selectedData: Signal<(data: AnyObject, index: Int), NoError>? {
        didSet {
            selectedData?
                .observeValues({ [unowned self] (data) in
                    let (_, index) = data
                    if let model = self.dataSource.value[index] as? MainTableViewCellModel, let query = model.header.value {
                        self .executeSearch(forQuery: query)
                    }
                })
        }
    }

    // 
    init() {
        // Local Binding
        self.searchButtonEnabled <~ self.searchText.producer.map({ (searchQuery) -> Bool in
            guard let query = searchQuery, query.characters.count > 0 else {
                return false
            }
            return true
        })
    }
    
    func refresh() {
        self.dataSource.value = SearchCache.instance.searchQueries.map({ MainTableViewCellModel(header: $0 as! String) })
    }
    
    func executeSearch(forQuery query: String) {
        SearchCache.instance.update(recentSearch: query)
                
        let photoGridViewModel = PhotosGridViewModel(searchQuery: query)
        self.pushPhotosGridVC.value = photoGridViewModel
    }
}
