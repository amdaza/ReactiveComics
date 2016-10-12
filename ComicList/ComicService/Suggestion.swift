//
//  Suggestion.swift
//  ComicList
//
//  Created by Home on 8/10/16.
//  Copyright © 2016 Guillermo Gonzalez. All rights reserved.
//

import Foundation

public struct Suggestion {
    
    public let title: String
}

extension Suggestion: JSONDecodable {
    
    public init?(dictionary: JSONDictionary) {
        guard let title = dictionary["name"] as? String else {
            return nil
        }
        
        self.title = title
    }
}
