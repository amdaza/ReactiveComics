//
//  AppDelegate.swift
//  ComicList
//
//  Created by Guillermo Gonzalez on 29/09/2016.
//  Copyright © 2016 Guillermo Gonzalez. All rights reserved.
//

import UIKit
//@testable import ComicService
//import RxSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var coordinator: AppCoordinator?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        let window = UIWindow(frame: UIScreen.main.bounds)

        coordinator = AppCoordinator(window: window)
        coordinator?.start()
        
        /*
         // Url construction
        let resource = API.suggestions(query: "Hola gente")
        
        let request = resource.request(withBaseURL: URL(string: "http:example.com")!,
                                       additionalParameters: [
                                        "api_key": "hjgkjh"
            ])
        
        print("request: \(request)")
        */
        
        /*
         // Create response & suggestions
        let dictionary: JSONDictionary = [
            "error": "OK",
            "status_code": 1,
            "results": [
                [
                    "name": "Hola",
                    "resource_type": "volume"
                ],
                [
                    "name": "Caracola",
                    "resource_type": "volume"
                ]
            ]
        ]
        
        if let response: Response = decode(dictionary),
            let suggestions: [Suggestion] =
            response.results() {
            
            print("response: \(response)")
            print("suggestions: \(suggestions)")
        }
 */
        /*
        // Calling API for suggestions
        let client = Client()
        let suggestions: Observable<[Suggestion]> =
            client.objects(forResource: API.suggestions(query: "bat"))
        
        let _ = suggestions.subscribe(onNext: { suggestions in
            print("results: \(suggestions)")
        })
 */
        /*
        
        // Now that Client+API is created
        let client = Client()
        let suggestions = client.suggestions(forQuery: "thanos")
        
        let _ = suggestions.subscribe(onNext: { suggestions in
            print("results: \(suggestions)")
        })
*/
 
        return true
    }
}

