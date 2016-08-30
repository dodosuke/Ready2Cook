//
//  RecipeCollectionViewController.swift
//  Ready2Cook
//
//  Created by Keisuke Kishida on 8/27/16.
//  Copyright © 2016 kishidak. All rights reserved.
//

import UIKit

class RecipeCollectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UISearchBarDelegate {
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    let ud = NSUserDefaults.standardUserDefaults()
    
    var count:Int = 0
    var imageURLs: [String] = []
    var titles: [String] = []
    var recipeIDs: [String] = []
    
    var images:[Int:NSData] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionViewFormat()
        
        if let udID = ud.objectForKey("items") {
            let items = udID as! [String]
            searchRecipe(items)
        }
        
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        let detailViewer = storyboard!.instantiateViewControllerWithIdentifier("DetailViewController") as! DetailViewController
        let recipeId = recipeIDs[indexPath.row]
        
//        download ingredients' data and pass data to detail viewer
        SwiftLoading().showLoading()
        F2FClient.sharedInstance().getIngredientsFromF2F(recipeId) {(ingredients, source, errorString) in
            dispatch_async(dispatch_get_main_queue()) {
                if errorString == nil {
                    detailViewer.ingredients = ingredients!
                    detailViewer.titleOfRecipe = self.titles[indexPath.row]
                    detailViewer.source = source!
                    detailViewer.image = self.images[indexPath.row]
                    detailViewer.recipeId = recipeId
                    
                    SwiftLoading().hideLoading()
                    self.navigationController!.pushViewController(detailViewer, animated: true)
                } else {
                    self.displayError(errorString!)
                    SwiftLoading().hideLoading()
                }
                
            }
            
        }
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return count
        
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("RecipeCollectionViewCell", forIndexPath: indexPath) as! RecipeCollectionViewCell
        
        if imageURLs != [] {
            dispatch_async(dispatch_get_main_queue()) {
                let imageURL = NSURL(string: self.imageURLs[indexPath.row])
                if let imageData = NSData(contentsOfURL: imageURL!) {
                    self.images[indexPath.row] = imageData
                    cell.imageForRecipe.image = UIImage(data: imageData)
                    cell.title.text = self.titles[indexPath.row]
                }
            }
            
        }
        
        return cell
    
    }
    
    func searchRecipe(items:[String]) {
        
        SwiftLoading().showLoading()
        
        F2FClient.sharedInstance().getURLsFromF2F(items) {(count, URLs, titles, recipeIDs, errorString) in
            dispatch_async(dispatch_get_main_queue()) {
                if errorString == nil {
                    self.count = count!
                    self.imageURLs = URLs!
                    self.titles = titles!
                    self.recipeIDs = recipeIDs!
                    self.collectionView.reloadData()
                    SwiftLoading().hideLoading()
//     If there are too many items and no results, search with less items will be carried out
                } else if errorString == "Retry" {
                    var newItems = items
                    newItems.removeLast()
                    self.searchRecipe(newItems)
                } else {
                    self.displayError(errorString!)
                    SwiftLoading().hideLoading()
                }
            }
        }
    }

    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        
        if let udID = ud.objectForKey("items") {
            let items = [searchBar.text!] + (udID as! [String])
            searchRecipe(items)
        }
    }

    
    @IBAction func refreshRecipe(sender: AnyObject) {
        
        if let udID = ud.objectForKey("items") {
            let items = udID as! [String]
            searchRecipe(items)
        }
    }
    
    private func collectionViewFormat() {
        
        let space: CGFloat = 2.0
        let dimension: CGFloat = (view.frame.size.width - (2 * space)) / 3.0
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSizeMake(dimension, dimension)
        
    }
    
    private func displayError(error:String) {
        print(error)
        
        let alert:UIAlertController = UIAlertController(title:"Alert", message: error, preferredStyle: .Alert)
        
        let cancelAction:UIAlertAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: {(action:UIAlertAction!) -> Void in})
        
        alert.addAction(cancelAction)
        
        presentViewController(alert, animated: true, completion: nil)
    }
    
}
