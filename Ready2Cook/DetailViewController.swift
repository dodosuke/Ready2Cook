//
//  DetailViewController.swift
//  Ready2Cook
//
//  Created by Keisuke Kishida on 8/28/16.
//  Copyright © 2016 kishidak. All rights reserved.
//

import UIKit

class DetailViewController: UITableViewController {
    
    let ud = NSUserDefaults.standardUserDefaults()
    var items:[String] = []
    var ingredients:[String] = []
    var source:String = ""
    var fav: Bool = false
    
    @IBOutlet weak var rightBarButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let udID = ud.objectForKey("items") {
            items = udID as! [String]
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return ingredients.count
        
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("DetailTableViewCell", forIndexPath: indexPath)
        let ingredient = ingredients[indexPath.row]
        
        cell.textLabel?.text = ingredient
        
//        change the color of ingredient's name, if you have in your fridge
        for item in items {
            if ingredient.containsString(item) {
                cell.textLabel?.textColor = UIColor.redColor()
            }
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let app = UIApplication.sharedApplication()
        app.openURL(NSURL(string: source)!)
        
    }
    
    
    @IBAction func fav(sender: AnyObject) {
        
        if fav {
            rightBarButton.image = UIImage(named: "fav")
        } else {
            rightBarButton.image = UIImage(named: "fav_solid")
        }
        
        fav = !fav
        
    }
    
    
}
