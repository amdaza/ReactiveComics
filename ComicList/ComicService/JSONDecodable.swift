//
//  JSONDecodable.swift
//  ComicList
//
//  Created by Home on 8/10/16.
//  Copyright © 2016 Guillermo Gonzalez. All rights reserved.
//

import Foundation

public typealias JSONDictionary = [String: Any]

public protocol JSONDecodable {
    init?(dictionary: JSONDictionary)
}

public func decode<T: JSONDecodable>(_ dictionary: JSONDictionary) -> T? {
    return T(dictionary: dictionary)
}

public func decode<T: JSONDecodable>(_ dictionaries: [JSONDictionary]) -> [T] {
    return dictionaries.flatMap(decode)
    // instead of return dictionaries.flatMap({ T(dictionary: $0) })
}

public func decode<T: JSONDecodable>(_ data: Data) -> T? {
    guard
        let jsonObject = try? JSONSerialization.jsonObject(with: data,
                                                       options: []),
        let JSONDictionary = jsonObject as? JSONDictionary,
        let object: T = decode(JSONDictionary) else {
            
            return nil
    }
    
    return object
}

// In case API also returns array (array of dictionaries), another function
