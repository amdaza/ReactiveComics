//
//  VolumeListViewModel.swift
//  ComicList
//
//  Created by Guillermo Gonzalez on 02/10/2016.
//  Copyright © 2016 Guillermo Gonzalez. All rights reserved.
//

import Foundation
import ComicContainer

/// Represents a volume list view model
protocol VolumeListViewModelType: class {

    /// Called when volumes are inserted or removed
    var didUpdate: () -> Void { get set }

    /// The number of volumes in the list
    var numberOfVolumes: Int { get }

    /// Returns the volume at a given position
    func item(at position: Int) -> Volume
}



final class VolumeListViewModel: VolumeListViewModelType {

    var didUpdate: () -> Void = {}

    var numberOfVolumes: Int {
        //return items.count
        return results.numberOfVolumes
    }

    func item(at position: Int) -> Volume {
        //return items[position]
        return results.volume(atIndex: position)
    }

    /*
    private let items: [Volume] = [
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
    ]
 */
    
    private let results: VolumeResultsType
    
    init(results: VolumeResultsType = VolumeContainer.instance.all()) {
        self.results = results
        self.results.didUpdate = { [weak self] in
            self?.didUpdate()
        }
    }

}





