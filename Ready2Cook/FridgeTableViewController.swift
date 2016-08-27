//
//  FridgeTableViewController.swift
//  Ready2Cook
//
//  Created by Keisuke Kishida on 8/27/16.
//  Copyright © 2016 kishidak. All rights reserved.
//

import UIKit

class FridgeTableViewController: UITableViewController, UITextFieldDelegate, UIAlertViewDelegate {
    
    let ud = NSUserDefaults.standardUserDefaults()
    var items:[String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.setEditing(true, animated: true)
        
        if let udID = ud.objectForKey("items") {
            items = udID as! [String]
        }
        
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return items.count
        
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("FridgeTableViewCell", forIndexPath: indexPath)
        
        cell.backgroundColor = colorForIndex(indexPath)
        cell.textLabel?.text = items[indexPath.row]
        
        return cell
        
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        
        return true
        
    }
    
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if editingStyle == .Delete {
            items.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            ud.setObject(items, forKey: "items")
            
        }
        
    }
    
    override func tableView(tableView: UITableView, moveRowAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {
        
        let tempItem = items[sourceIndexPath.row]
        items[sourceIndexPath.row] = items[destinationIndexPath.row]
        items[destinationIndexPath.row] = tempItem
        ud.setObject(items, forKey: "items")
        tableView.reloadData()
        
    }
    
    func colorForIndex(index: NSIndexPath) -> UIColor {
        
        let grad = (Float(index.row) / Float(items.count)) * 1.0
        return UIColor(red: 1.0, green: CGFloat(grad), blue: 1.0, alpha: 0.6)
        
    }
    
    @IBAction func addAnItem(sender: AnyObject) {
        
        let alert:UIAlertController = UIAlertController(title:"Add an Item", message: "Enter Below",preferredStyle: UIAlertControllerStyle.Alert)
        
        let cancelAction:UIAlertAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler:{(action:UIAlertAction!) -> Void in
            self.dismissViewControllerAnimated(true, completion: nil)
        })
        
        let defaultAction:UIAlertAction = UIAlertAction(title: "Add", style: UIAlertActionStyle.Default, handler:{(action:UIAlertAction!) -> Void in
            if let textField = alert.textFields {
                self.items.append(textField[0].text!)
                self.ud.setObject(self.items, forKey: "items")
            }
            self.dismissViewControllerAnimated(true, completion: nil)
            self.tableView.reloadData()
        })
        
        alert.addAction(cancelAction)
        alert.addAction(defaultAction)
        alert.addTextFieldWithConfigurationHandler({(text:UITextField!) -> Void in
        })
        
        presentViewController(alert, animated: true, completion: nil)
        
    }
    
    @IBAction func callHint(sender: AnyObject) {
    }
    
}
