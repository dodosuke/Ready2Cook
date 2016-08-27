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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.allowsMultipleSelection = true
        
        collectionViewFormat()
        
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 30
        
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("RecipeCollectionViewCell", forIndexPath: indexPath) as! RecipeCollectionViewCell
        
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
