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
    
    // MARK: Food2Fork Parameter Keys
    struct F2FParameterKeys {
        static let APIKey = "key"
        static let Query = "q"
        static let Page = "page"
        static let RecipeID = "rId"
    }
    
    // MARK: Food2Fork Parameter Values
    struct F2FParameterValues {
        static let APIKey = "50d489ef52311b8d0b403b58a398090a"
    }
    
    struct F2FResponseKeys {
        static let Title = "title"
        static let F2FURL = "f2f_url"
        static let ImageURL = "image_url"
        static let Publisher = "publisher"
        static let PublisherURL = "publisher_url"
        static let RecipeID = "recipe_id"
        static let SocialRank = "soucial_rank"
        static let Success = "success"
        static let SourceURL = "source_url"
        static let Count = "count"
        static let Recipes = "recipes"
        static let Recipe = "recipe"
        static let Ingredients = "ingredients"
    }
    
}