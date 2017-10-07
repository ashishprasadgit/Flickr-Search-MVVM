//
//  MainViewController.swift
//  FlickrApp
//
//  Created by Ashish Prasad on 27/09/17.
//  Copyright © 2017 Ashish Prasad. All rights reserved.
//

import UIKit
import ReactiveSwift
import ReactiveCocoa

class MainViewController: BaseViewController, Coordinable {
    
    typealias ViewModel = MainViewModel
    var viewModel: ViewModel!
    
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    private var bindingHelper: TableViewBindingHelper!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self .bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.viewModel .refresh()
    }
    
    //MARK:- Binding
    private func bindViewModel() {
        //
        viewModel.searchText <~ searchTextField.reactive.continuousTextValues
        searchButton.reactive.pressed = CocoaAction(viewModel.searchAction)

        //
        viewModel.searchButtonEnabled.producer.startWithValues { [unowned self] (searchButtonEnabled) in
            self.searchButton.isUserInteractionEnabled = (searchButtonEnabled)
            self.searchButton.alpha = (searchButtonEnabled) ? 1.0 : 0.4
        }
        
        viewModel.pushPhotosGridVC.producer
            .take(during: self.reactive.lifetime)
            .observe(on: UIScheduler())
            .startWithValues { [unowned self] (viewModel) in
            
            if let viewModel = viewModel {
                let vc = PhotosGridViewController.instantiate(fromStoryboard: .main)
                vc.viewModel = viewModel
                self.navigationController? .pushViewController(vc, animated: true)
            }
        }
        
        //
        bindingHelper = TableViewBindingHelper(tableView: tableView, dataSource: viewModel.dataSource.producer, nib: MainTableViewCell.nib())
        viewModel.selectedData = bindingHelper.selectedCommand.take(during: self.reactive.lifetime)
    }
}
