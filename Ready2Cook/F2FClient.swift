//
//  F2FClient.swift
//  Ready2Cook
//
//  Created by Keisuke Kishida on 8/26/16.
//  Copyright © 2016 kishidak. All rights reserved.
//

import UIKit

class F2FClient: NSObject {
    
    func getURLsFromF2F(completionHandlerForF2F: (URLs: [String]?, errorString: String?) -> Void) {
        
        var imageURLs:[String] = []
        
        let methodParameters = [
            Constants.F2FParameterKeys.APIKey: Constants.F2FParameterValues.APIKey,
            Constants.F2FParameterKeys.Query: makeQuery()
        ]
        
        // create session and request
        let session = NSURLSession.sharedSession()
        let request = NSURLRequest(URL: F2FURLFromParameters(methodParameters))
        
        // create network request
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            
            // if an error occurs, print it and re-enable the UI
            func sendError(error: String) {
                print(error)
                completionHandlerForF2F(URLs: nil, errorString: error)
            }
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                sendError("There was an error with your request: \(error)")
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                sendError("Your request returned a status code other than 2xx!")
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                sendError("No data was returned by the request!")
                return
            }
            
            // parse the data
            let parsedResult: AnyObject!
            do {
                parsedResult = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
                print(parsedResult)
                if let results = parsedResult["recipes"] as? [[String:AnyObject]] {
                    for result in results {
                        if let imageURL = result["image_url"] as? String {
                            imageURLs.append(imageURL)
                        }
                    }
                }
                
                completionHandlerForF2F(URLs: imageURLs, errorString: nil)
                
            } catch {
                sendError("Could not parse the data as JSON: '\(data)'")
                return
            }
            
            
            
        }
        
        // start the task!
        task.resume()
    }
    
    
    private func F2FURLFromParameters(parameters: [String:AnyObject]) -> NSURL {
        
        let components = NSURLComponents()
        components.scheme = Constants.F2F.APIScheme
        components.host = Constants.F2F.APIHost
        components.path = Constants.F2F.APIPath
        components.queryItems = [NSURLQueryItem]()
        
        for (key, value) in parameters {
            let queryItem = NSURLQueryItem(name: key, value: "\(value)")
            components.queryItems!.append(queryItem)
        }
        
        print(components.URL!)
        return components.URL!
    }
    
    private func makeQuery() -> String {
        
        var query:String = ""
        
        let items = NSUserDefaults.standardUserDefaults().objectForKey("items") as! [String]
        for item in items {
            query = query + "," + item
        }
        
        return query
    }
    
    
    class func sharedInstance() -> F2FClient {
        struct Singleton {
            static var sharedInstance = F2FClient()
        }
        return Singleton.sharedInstance
    }
    
}
