//
//  Constants.swift
//  Ready2Cook
//
//  Created by Keisuke Kishida on 8/28/16.
//  Copyright © 2016 kishidak. All rights reserved.
//

import Foundation

struct Constants {
    
    // MARK: Food2Fork
    struct F2F {
        static let APIScheme = "http"
        static let APIHost = "food2fork.com"
        static let APIPathSearch = "/api/search"
        static let APIPathGet = "/api/get"
        
    }
    
    // MARK: Flickr Parameter Keys
    struct F2FParameterKeys {
        static let APIKey = "key"
        static let Query = "q"
        static let Page = "page"
        static let RecipeID = "rId"
    }
    
    // MARK: Flickr Parameter Values
    struct F2FParameterValues {
        static let APIKey = "50d489ef52311b8d0b403b58a398090a"
    }
    
    enum Method {
        case SEARCH
        case GET
    }

}