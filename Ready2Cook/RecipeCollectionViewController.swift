//
//  RecipeCollectionViewController.swift
//  Ready2Cook
//
//  Created by Keisuke Kishida on 8/27/16.
//  Copyright © 2016 kishidak. All rights reserved.
//

import UIKit

class RecipeCollectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var collectionView: UICollectionView!
    
    let ud = NSUserDefaults.standardUserDefaults()
    var items:[String] = []
    var count:Int = 0
    var imageURLs: [String] = []
    var titles: [String] = []
    var recipeIDs: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionViewFormat()
        
        searchRecipe()
    }

    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        let detailViewer = storyboard!.instantiateViewControllerWithIdentifier("DetailViewController") as! DetailViewController
        let recipeId = recipeIDs[indexPath.row]
        
        SwiftLoading().showLoading()
        F2FClient.sharedInstance().getIngredientsFromF2F(recipeId) {(ingredients, source, errorString) in
            if errorString == nil {
                dispatch_async(dispatch_get_main_queue()) {
                    print(ingredients,source)
                    detailViewer.ingredients = ingredients!
                    detailViewer.source = source!
                    SwiftLoading().hideLoading()
                    self.navigationController!.pushViewController(detailViewer, animated: true)
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
                    cell.imageForRecipe.image = UIImage(data: imageData)
                    cell.title.text = self.titles[indexPath.row]
                }
            }
            
        }
        
        return cell
    
    }
    
    func searchRecipe() {
        
        if let udID = ud.objectForKey("items") {
            items = udID as! [String]
        }
        
        SwiftLoading().showLoading()
        F2FClient.sharedInstance().getURLsFromF2F(items) {(count, URLs, titles, recipeIDs, errorString) in
            if errorString == nil {
                dispatch_async(dispatch_get_main_queue()) {
                    self.count = count!
                    self.imageURLs = URLs!
                    self.titles = titles!
                    self.recipeIDs = recipeIDs!
                    self.collectionView.reloadData()
                    SwiftLoading().hideLoading()
                }
            }
        }

        
    }
    
    @IBAction func refreshRecipe(sender: AnyObject) {
        
        searchRecipe()
        
    }
    
    private func collectionViewFormat() {
        
        let space: CGFloat = 2.0
        let dimension: CGFloat = (view.frame.size.width - (2 * space)) / 3.0
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSizeMake(dimension, dimension)
        
    }
}
