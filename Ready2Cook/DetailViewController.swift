//
//  DetailViewController.swift
//  Ready2Cook
//
//  Created by Keisuke Kishida on 8/28/16.
//  Copyright © 2016 kishidak. All rights reserved.
//

import UIKit
import CoreData

class DetailViewController: UITableViewController {
    
    var ingredients:[String] = []

    var titleOfRecipe:String = ""
    var source:String = ""
    var image:NSData? = nil
    var recipeId:String = ""
    
    var fav: Bool = false
    
    @IBOutlet weak var rightBarButton: UIBarButtonItem!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        checkRecipe()
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return ingredients.count
        
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("DetailTableViewCell", forIndexPath: indexPath)
        let ingredient = ingredients[indexPath.row]
        
        cell.textLabel?.text = ingredient
        
//      Change the color of ingredient's name, if you have in your fridge
        
        if let udID = NSUserDefaults.standardUserDefaults().objectForKey("items") {
            let items = udID as! [String]
            for item in items {
                if ingredient.containsString(item) {
                    cell.textLabel?.textColor = UIColor.redColor()
                }
            }
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let app = UIApplication.sharedApplication()
        app.openURL(NSURL(string: source)!)
        
    }
    
//    Add to a favorite list (Store the recipe)
    @IBAction func fav(sender: AnyObject) {
        
        if fav {
            rightBarButton.image = UIImage(named: "fav")
            deleteRecipe(recipeId)
        } else {
            rightBarButton.image = UIImage(named: "fav_solid")
            saveRecipe(titleOfRecipe, source: source, image: image!, recipeId: recipeId, ingredients: ingredients)
        }
        
        fav = !fav
    }
    
//   judging the recipe is in the favorite lists
    func checkRecipe() {
        
        let recipeIds = loadRecipeIDs()
        for id in recipeIds {
            if id == recipeId {
                fav = true
                rightBarButton.image = UIImage(named: "fav_solid")
            }
        }
    }
}
