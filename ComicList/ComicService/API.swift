//
//  API.swift
//  ComicList
//
//  Created by Home on 8/10/16.
//  Copyright © 2016 Guillermo Gonzalez. All rights reserved.
//

import Foundation

public enum API {
    case suggestions(query: String)
    case search(query: String, page: Int)
    case description(volumeIdentifier: Int)
}

extension API: Resource {
    
    public var path: String {
        switch self {
        case .suggestions, .search:
            return "search"
        case .description(volumeIdentifier: let identifier):
            return "volume/4050-(\(identifier))"
        }
    }
    
    public var parameters: [String : String] {
        switch self {
        case .suggestions(query: let q):
            return [
                "format": "json",
                "field_list": "name",
                "limit": "10",
                "page": "1",
                "query": q,
                "resources": "volume"
            ]
        case .search(query: let q, page: let p):
        //case let .search(query q, page p):
            return [
                "format": "json",
                "field_list": "id,image,name,publisher",
                "limit": "20",
                "page": String(p),
                "query": q,
                "resources": "volume"
            ]
        case .description:
            return [
                "format": "json",
                "field_list": "description",
            ]
        }
    }
}






