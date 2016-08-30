//
//  CoreDataBookmarksCVC.swift
//  Ready2Cook
//
//  Created by Keisuke Kishida on 8/29/16.
//  Copyright © 2016 kishidak. All rights reserved.
//

import UIKit
import CoreData

extension BookmarksCollectionViewController {
    
    func loadRecipe() -> [Recipe] {
        
        let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let stack = delegate.stack
        let fr = NSFetchRequest(entityName: "Recipe")
        fr.sortDescriptors = [NSSortDescriptor(key: "recipeId", ascending: true)]
        
        do {
            if let results: Array = try stack.context.executeFetchRequest(fr) {
                recipes = results as! [Recipe]
                return recipes
            }
        } catch let error as NSError {
            print("READ ERROR:\(error.localizedDescription)")
            return []
        }
    }
    
    func loadIngredients(recipe:Recipe) -> [String] {
        
        var ingredients:[String] = []
        
        let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let stack = delegate.stack
        let fr = NSFetchRequest(entityName: "Ingredient")
        fr.sortDescriptors = [NSSortDescriptor(key: "ingredient", ascending: true)]
        fr.predicate = NSPredicate(format: "list = %@", argumentArray: [recipe])
        
        do {
            if let results: Array = try stack.context.executeFetchRequest(fr) {
                if results.count > 0 {
                    for result in results {
                        let ingredient = result as! Ingredient
                        ingredients.append(ingredient.ingredient!)
                    }
                }
            }
        } catch let error as NSError {
            print("READ ERROR:\(error.localizedDescription)")
        }
        
        return ingredients
    }
}
