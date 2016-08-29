//
//  Recipe.swift
//  Ready2Cook
//
//  Created by Keisuke Kishida on 8/29/16.
//  Copyright © 2016 kishidak. All rights reserved.
//

import Foundation
import CoreData


class Recipe: NSManagedObject {

    convenience init (title:String, source:String, image:NSData, recipeId:String, context: NSManagedObjectContext) {
        if let ent = NSEntityDescription.entityForName("Location", inManagedObjectContext: context){
            self.init(entity:ent, insertIntoManagedObjectContext: context)
            self.title = title
            self.source = source
            self.image = image
            self.recipeId = recipeId
        }else {
            fatalError("")
        }
    }

}
