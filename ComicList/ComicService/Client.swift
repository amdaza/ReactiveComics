//
//  Client.swift
//  ComicList
//
//  Created by Home on 8/10/16.
//  Copyright © 2016 Guillermo Gonzalez. All rights reserved.
//

import Foundation
import HTTPFetcher
import RxSwift

private let baseURL = URL(string: "http://www.comicvine.com/api")!
private let key = "aa14d61c59028e35c1b7d6a604f3cadd41cc61ae"

public enum ClientError: Error {
    case couldNotDecodeJSON
    case badStatus(Int, String)
}

public final class Client {
    private let fetcher: HTTPFetcher
    
    public init(fetcher: HTTPFetcher =
        URLSession(configuration: URLSessionConfiguration.default)) {
        
        self.fetcher = fetcher
    }
    
    public func object<T: JSONDecodable>(forResource resource: Resource) -> Observable<T> {
        return response(forResource: resource)
            .map { response in
                guard let result: T = response.result() else {
                    print("Fail in objectForResource just one")
                    throw ClientError.couldNotDecodeJSON
                }
                return result
        }
    }
    
    public func objects<T: JSONDecodable>(forResource resource: Resource) -> Observable<[T]> {
        return response(forResource: resource)
            .map { response in
                guard let results: [T] = response.results() else {
                    print("Fail in objectsForResource array")
                    throw ClientError.couldNotDecodeJSON
                }
                return results
        }
    }
    
    private func response(forResource resource: Resource) -> Observable<Response> {
        
        // Get request from resource
        let request = resource.request(withBaseURL: baseURL,
                                       additionalParameters: ["api_key": key])
        // Get data and transform it to Response
        return fetcher.data(request: request)
            .map { data in
                print(data)
                guard let response: Response = decode(data) else {
                    print("Fail in response")
                    throw ClientError.couldNotDecodeJSON
                   
                }
                guard response.succeeded else {
                    throw ClientError.badStatus(response.status, response.message)
                }
                
                return response
        }
    }
}
