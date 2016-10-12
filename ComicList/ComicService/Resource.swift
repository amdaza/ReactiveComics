//
//  Resource.swift
//  ComicList
//
//  Created by Home on 8/10/16.
//  Copyright © 2016 Guillermo Gonzalez. All rights reserved.
//

import Foundation

public enum Method: String {
    case GET = "GET"
}

public protocol Resource {
    var method: Method { get }
    var path: String { get }
    var parameters: [String: String] { get }
}

extension Resource {
    
    // Optional implementation
    public var method: Method {
        return .GET
    }
    
    public var parameters: [String: String] {
        return [:]
    }
    
    // Would be internal by default
    internal func request(withBaseURL baseURL: URL,
        additionalParameters: [String: String]) -> URLRequest {
        
        let url = baseURL.appendingPathComponent(path)
        var components = URLComponents(url: url,
                                       resolvingAgainstBaseURL: false)!
        
        var parameters = self.parameters
        additionalParameters.forEach {
            parameters.updateValue($1, forKey: $0)
        }
        
        // Generate query url
        components.queryItems = parameters.map(URLQueryItem.init)
       
        /*
        // Equivalent to
        components.queryItems = parameters.map { key, value in
            return URLQueryItem(name: key, value: value)
        }
        */
    
        // Generate request
        var request = URLRequest(url: components.url!)
        request.httpMethod = method.rawValue // Get string "GET"
        
        return request
    }
}
