//
//  SearchResultsViewModel.swift
//  ComicList
//
//  Created by Guillermo Gonzalez on 03/10/2016.
//  Copyright © 2016 Guillermo Gonzalez. All rights reserved.
//

import Foundation
import RxSwift
import ComicContainer
import ComicService

protocol SearchResultsViewModelType: class {

    /// The search query
    var query: String { get }

    /// Called after a new page of results has been loaded
    var didLoadPage: () -> Void { get set }

    /// The current number of search results
    var numberOfItems: Int { get }

    /// Returns the volume at a given position
    func item(at position: Int) -> Volume

    /// Loads the first page of results
    ///
    /// - parameter trigger: An observable that will trigger loading the next page
    ///
    /// - returns: An observable that will send the number of pages loaded
    func load(nextPage trigger: Observable<Void>) -> Observable<Int>
}


final class SearchResultsViewModel: SearchResultsViewModelType {

    let query: String
    var didLoadPage: () -> Void = {}

    public var numberOfItems: Int {
        return results.numberOfVolumes
    }

    public func item(at position: Int) -> Volume {
        precondition(position < numberOfItems)
        return results.volume(atIndex: position)
    }

    public func load(nextPage trigger: Observable<Void>) -> Observable<Int> {
        return doLoad(page: 1, nextPage: trigger)
    }

    //private var items: [Volume] = []
    
    private let client: Client
    private let container: VolumeContainerType
    private let results: VolumeResultsType
    private let disposeBag = DisposeBag()

    init(query: String,
         client: Client = Client(),
         container: VolumeContainerType = VolumeContainer.temporary()) {
        
        self.query = query
        self.client = client
        self.container = container
        
        container.load()
            .subscribe()
            .addDisposableTo(disposeBag)
        
        results = container.all()
        
        results.didUpdate = { [weak self] in
            // Creating ciclic reference, need to capture list
            self?.didLoadPage()
        }
    }

    private func doLoad(page current: Int, nextPage trigger: Observable<Void>) -> Observable<Int> {
        /*
        items.append(contentsOf: [
            Volume(identifier: 38656,
                   title: "Doctor Strange: The Oath",
                   coverURL: URL(string: "http://comicvine.gamespot.com/api/image/scale_small/1641291-ds__to.jpg"),
                   publisherName: "Marvel"),
            Volume(identifier: 67079,
                   title: "Age Of Ultron",
                   coverURL: URL(string: "http://comicvine.gamespot.com/api/image/scale_small/3816330-01.jpg"),
                   publisherName: "Marvel"),
            Volume(identifier: 39255,
                   title: "Thanos Imperative",
                   coverURL: URL(string: "http://comicvine.gamespot.com/api/image/scale_small/1704425-the_thanos_imperative_hc.jpg"),
                   publisherName: "Marvel")
        ])
         
         didLoadPage()
         
         return Observable.just(1)
        */
        let container = self.container
        
        return client.searchResults(forQuery: query, page: current)
            /*.do(onNext: {
                print("page: \(current)")
            })*/
            .flatMap { volumes in
                return container.save(volumes: volumes)
            }
            // We're sure that self will exists, unowned is not an optional (not like weak)
            .flatMap { [unowned self] _ in
                return Observable.concat([
                    Observable.just(current),
                    Observable.never().takeUntil(trigger),
                    self.doLoad(page: (current + 1), nextPage: trigger)
                ])
            }
        
        
    }
}
