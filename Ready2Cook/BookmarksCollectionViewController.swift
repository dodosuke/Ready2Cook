//
//  BookmarksCollectionViewController.swift
//  Ready2Cook
//
//  Created by Keisuke Kishida on 8/27/16.
//  Copyright © 2016 kishidak. All rights reserved.
//

import UIKit
import CoreData

class BookmarksCollectionViewController: UICollectionViewController {
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    var recipes:[Recipe] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionViewFormat()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        recipes = loadRecipe()
        collectionView?.reloadData()
        
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return recipes.count
        
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        let detailViewer = storyboard!.instantiateViewControllerWithIdentifier("DetailViewController") as! DetailViewController
        let recipe = recipes[indexPath.row]
        let ingredients = loadIngredients(recipe)
        
//        Pass the data to detail viewer
        detailViewer.ingredients = ingredients
        detailViewer.titleOfRecipe = recipe.title!
        detailViewer.source = recipe.source!
        detailViewer.image = recipe.image
        detailViewer.recipeId = recipe.recipeId!
        
        navigationController!.pushViewController(detailViewer, animated: true)
        
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("BookmarksCollectionViewCell", forIndexPath: indexPath) as! BookmarksCollectionViewCell
        let recipe = recipes[indexPath.row]
        
        cell.title.text = recipe.title
        cell.imageForRecipe.image = UIImage(data: recipe.image!)
        
        return cell
        
    }
    
    private func collectionViewFormat() {
        
        let space: CGFloat = 3.0
        let dimension: CGFloat = (view.frame.size.width - (2 * space)) / 3.0
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSizeMake(dimension, dimension)
        
    }
    
}
