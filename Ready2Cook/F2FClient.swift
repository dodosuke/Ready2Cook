//
//  F2FClient.swift
//  Ready2Cook
//
//  Created by Keisuke Kishida on 8/26/16.
//  Copyright © 2016 kishidak. All rights reserved.
//

import UIKit

class F2FClient: NSObject {
    
    func getURLsFromF2F(items: [String]?, completionHandlerForF2F: (count: Int?, URLs: [String]?, titles: [String]?, recipeIDs: [String]?, errorString: String?) -> Void) {
        
        var imageURLs:[String] = []
        var titles:[String] = []
        var recipeIDs:[String] = []
        var methodParameters: [String:AnyObject] = [
            Constants.F2FParameterKeys.APIKey: Constants.F2FParameterValues.APIKey,
            Constants.F2FParameterKeys.Query: makeQuery(items!)
            ]
 
        // create session and request
        let session = NSURLSession.sharedSession()
        let request = NSURLRequest(URL: F2FSearchURLfromParameters(methodParameters))
        
        // create network request
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            
            // if an error occurs, print it and re-enable the UI
            func sendError(error: String) {
                print(error)
                completionHandlerForF2F(count: nil, URLs: nil, titles: nil, recipeIDs: nil, errorString: error)
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

                if let count = parsedResult[Constants.F2FResponseKeys.Count] as? Int {
                    if count != 0 {
                        if let results = parsedResult[Constants.F2FResponseKeys.Recipes] as? [[String:AnyObject]] {
                            for result in results {
                                if let imageURL = result[Constants.F2FResponseKeys.ImageURL] as? String {
                                    imageURLs.append(imageURL)
                                }
                                if let title = result[Constants.F2FResponseKeys.Title] as? String {
                                    titles.append(title)
                                }
                                if let recipeID = result[Constants.F2FResponseKeys.RecipeID] as? String {
                                    recipeIDs.append(recipeID)
                                }
                            }
                        }
                    } else if items!.count == 1 {
                        sendError("No Results")
                    } else {
//     If there are too many items and no results, search with less items will be carried out
                        sendError("Retry")
                    }
                    
                    completionHandlerForF2F(count: count, URLs: imageURLs, titles: titles, recipeIDs: recipeIDs, errorString: nil)

                }
                
            } catch {
                sendError("Could not parse the data as JSON: '\(data)'")
                return
            }
            
        }
        
        // start the task!
        task.resume()
    }
    
    func getIngredientsFromF2F(recipeId: String?, completionHandlerForF2F: (ingredients: [String]?, source: String?, errorString: String?) -> Void) {
        
        var ingredients:[String] = []
        var sourceURL:String = ""
        
        let methodParameters: [String:AnyObject] = [
            Constants.F2FParameterKeys.APIKey: Constants.F2FParameterValues.APIKey,
            Constants.F2FParameterKeys.RecipeID: recipeId!
        ]
        
        // create session and request
        let session = NSURLSession.sharedSession()
        let request = NSURLRequest(URL: F2FGetURLfromParameters(methodParameters))
        
        // create network request
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            
            // if an error occurs, print it and re-enable the UI
            func sendError(error: String) {
                print(error)
                completionHandlerForF2F(ingredients: nil, source: nil, errorString: error)
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
                
                if let results = parsedResult[Constants.F2FResponseKeys.Recipe] as? [String:AnyObject] {
                    if let ingredientsList = results[Constants.F2FResponseKeys.Ingredients] as? [String] {
                        ingredients = ingredientsList
                    }
                    if let source_url = results[Constants.F2FResponseKeys.SourceURL] as? String {
                        sourceURL = source_url
                    }
                }
                
                completionHandlerForF2F(ingredients: ingredients, source: sourceURL, errorString: nil)
                
            } catch {
                sendError("Could not parse the data as JSON: '\(data)'")
                return
            }
            
        }
        
        // start the task!
        task.resume()
    }
    
    private func F2FSearchURLfromParameters(parameters: [String:AnyObject]) -> NSURL {
        
        let components = NSURLComponents()
        components.scheme = Constants.F2F.APIScheme
        components.host = Constants.F2F.APIHost
        components.path = Constants.F2F.APIPathSearch
        components.queryItems = [NSURLQueryItem]()
        
        for (key, value) in parameters {
            let queryItem = NSURLQueryItem(name: key, value: "\(value)")
            components.queryItems!.append(queryItem)
        }
        
        print(components.URL!)
        return components.URL!
    }
    
    private func F2FGetURLfromParameters(parameters: [String:AnyObject]) -> NSURL {
        
        let components = NSURLComponents()
        components.scheme = Constants.F2F.APIScheme
        components.host = Constants.F2F.APIHost
        components.path = Constants.F2F.APIPathGet
        components.queryItems = [NSURLQueryItem]()
        
        for (key, value) in parameters {
            let queryItem = NSURLQueryItem(name: key, value: "\(value)")
            components.queryItems!.append(queryItem)
        }
        
        print(components.URL!)
        return components.URL!
    }
    
    private func makeQuery(items: [String]?) -> String {
        
        var query:String = ""
        
        if items != nil {
            for item in items! {
                query = query + "," + item
            }
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
