//
//  Ingredient.swift
//  Ready2Cook
//
//  Created by Keisuke Kishida on 8/29/16.
//  Copyright © 2016 kishidak. All rights reserved.
//

import Foundation
import CoreData


class Ingredient: NSManagedObject {

    convenience init (ingredient:String, recipeId:String, recipe:Recipe, context: NSManagedObjectContext) {
        if let ent = NSEntityDescription.entityForName("Ingredient", inManagedObjectContext: context){
            self.init(entity:ent, insertIntoManagedObjectContext: context)
            self.ingredient = ingredient
            self.recipeId = recipeId
            self.list = recipe
        }else {
            fatalError("")
        }
    }

}
