//
//  CoreDataDetailVC.swift
//  Ready2Cook
//
//  Created by Keisuke Kishida on 8/29/16.
//  Copyright © 2016 kishidak. All rights reserved.
//

import UIKit
import CoreData

extension DetailViewController {
    
    func saveRecipe(title: String, source: String, image: NSData, recipeId: String, ingredients: [String]) {
        
        // Get the stack
        let delegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let stack = delegate.stack
        let fr = NSFetchRequest(entityName: "Recipe")
        fr.sortDescriptors = [NSSortDescriptor(key: "recipeId", ascending: true)]
        
        // Create the FetchedResultsController
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fr, managedObjectContext: stack.context, sectionNameKeyPath: nil, cacheName: nil)
        
        // Create a new recipe... and Core Data takes care of the rest!
        let newRecipe = Recipe(title: title, source: source, image: image, recipeId: recipeId, context: fetchedResultsController.managedObjectContext)

        saveIngredients(ingredients, recipeId: recipeId, recipe: newRecipe)
        
        stack.save()
    
    }
    
    func saveIngredients(ingredients:[String], recipeId: String, recipe:Recipe) {
        
        // Get the stack
        let delegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let stack = delegate.stack
        let fr = NSFetchRequest(entityName: "Ingredient")
        fr.sortDescriptors = [NSSortDescriptor(key: "ingredient", ascending: true)]
        
        // Create the FetchedResultsController
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fr, managedObjectContext: stack.context, sectionNameKeyPath: nil, cacheName: nil)
        
        // Create a new recipe... and Core Data takes care of the rest!
        for ingredient in ingredients {
            let newIngredient = Ingredient(ingredient: ingredient, recipeId: recipeId, recipe: recipe, context: fetchedResultsController.managedObjectContext)
            print("Just created an ingredient: \(newIngredient)")
        }
        stack.save()
        
    }
    
    func deleteRecipe(recipeId: String) {
        
        let delegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let stack = delegate.stack
        let fr = NSFetchRequest(entityName: "Recipe")
        fr.returnsObjectsAsFaults = false
        
        do {
            let results: Array = try stack.context.executeFetchRequest(fr)
            if results.count > 0 {
                
                for i in 0...results.count-1 {
                    
                    let id = results[i].valueForKey("recipeId") as! String
                    if id == recipeId {
                        
                        let recipe = results[i] as! Recipe
                        stack.context.deleteObject(recipe)
                        stack.save()
                    }
                }
            }
        } catch let error as NSError {
            print("FETCH ERROR:\(error.localizedDescription)")
        }
    }
    
    func loadRecipeIDs() -> [String] {
        
        var recipeIds:[String] = []
        
        let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let stack = delegate.stack
        let fr = NSFetchRequest(entityName: "Recipe")
        fr.sortDescriptors = [NSSortDescriptor(key: "recipeId", ascending: true)]
        
        do {
            if let results: Array = try stack.context.executeFetchRequest(fr) {
                for result in results {
                    let recipe = result as! Recipe
                    recipeIds.append(recipe.recipeId!)
                }
            }
        } catch let error as NSError {
            print("READ ERROR:\(error.localizedDescription)")
        }
        
        return recipeIds
    }
    
}
