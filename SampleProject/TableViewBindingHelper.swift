//
//  TableViewBindingHelper.swift
//  ReactiveSwiftFlickrSearch
//
//  Created by Colin Eberhardt on 15/07/2014.
//  Copyright (c) 2014 Colin Eberhardt. All rights reserved.
//

import UIKit
import ReactiveSwift
import ReactiveCocoa

// a helper that makes it easier to bind to UITableView instances
// see: http://www.scottlogic.com/blog/2014/05/11/reactivecocoa-tableview-binding.html
class TableViewBindingHelper: NSObject {
  
    //MARK: Properties
    var delegate: UITableViewDelegate?
  
    fileprivate let tableView: UITableView
    fileprivate let templateCell: UITableViewCell
    fileprivate var data: [AnyObject]
    fileprivate let selectedCommandObserver: Signal<(data: AnyObject, index: Int), NoError>.Observer
    
    let selectedCommand: Signal<(data: AnyObject, index: Int), NoError>
    
    init(tableView: UITableView, dataSource: SignalProducer<[AnyObject], NoError>, nib: UINib) {
        self.tableView = tableView
        self.data = []
        
        // create an instance of the template cell and register with the table view
        templateCell = nib.instantiate(withOwner: nil, options: nil)[0] as! UITableViewCell
        tableView.register(nib, forCellReuseIdentifier: templateCell.reuseIdentifier!)
        
        // creating hot signal for row Tapped
        let (signal, observer) = Signal<(data: AnyObject, index: Int), NoError>.pipe()
        self.selectedCommand = signal
        self.selectedCommandObserver = observer
        
        super.init()
        
        // Observing Data source
        dataSource
            .take(during: self.reactive.lifetime)
            .observe(on: UIScheduler())
            .startWithValues({ [unowned self] (dataSource) in
                self.data = dataSource
                self.tableView.reloadData()
            })
        
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    deinit {
        selectedCommandObserver.sendCompleted()
    }
}

extension TableViewBindingHelper: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item: AnyObject = data[indexPath.row]
        let cell = tableView .dequeueReusableCell(withIdentifier: templateCell.reuseIdentifier!)
        if let reactiveView = cell as? ReactiveView {
            reactiveView.bind(viewModel: item)
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return templateCell.frame.size.height
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedCommandObserver.send(value: (data: data[indexPath.row], index: indexPath.row))
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if let delegate = self.delegate, delegate .responds(to: #selector(UIScrollViewDelegate.scrollViewDidScroll(_:))) {
            delegate.scrollViewDidScroll?(scrollView)
        }
    }
}
