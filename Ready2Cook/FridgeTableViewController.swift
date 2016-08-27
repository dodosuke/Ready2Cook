//
//  FridgeTableViewController.swift
//  Ready2Cook
//
//  Created by Keisuke Kishida on 8/27/16.
//  Copyright © 2016 kishidak. All rights reserved.
//

import UIKit

class FridgeTableViewController: UITableViewController {
    
    let ud = NSUserDefaults.standardUserDefaults()
    var items:[String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.setEditing(true, animated: true)
        
        if let udID = ud.objectForKey("items") {
            items = udID as! [String]
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView?.reloadData()
        
    }

    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return items.count
        
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("FridgeTableViewCell", forIndexPath: indexPath)
        cell.textLabel?.text = items[indexPath.row]
        
        return cell
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        
        return true
        
    }
    
    override func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        
        return UITableViewCellEditingStyle.None
        
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if editingStyle == .Delete {
            items.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
        
    }
    
    override func tableView(tableView: UITableView, moveRowAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {
        
        let tempItem = items[sourceIndexPath.row]
        items[sourceIndexPath.row] = items[destinationIndexPath.row]
        items[destinationIndexPath.row] = tempItem
        
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        
        
    }
    
    
    @IBAction func addAnItem(sender: AnyObject) {

        print(items)
        items.append("")
        tableView?.reloadData()
        
    }
    
}

extension FridgeTableViewController: UITextFieldDelegate, FridgeTableViewCellDelegate {
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
        
    }
    
    func textFieldDidEndEditing(cell: FridgeTableViewCell, value: NSString) -> () {
        
        let path = tableView.indexPathForRowAtPoint(cell.convertPoint(cell.bounds.origin, toView: tableView))
        NSLog("row = %d, value = %@", path!.row, value)
    }
    
}
