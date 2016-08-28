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
    
    var imageURLs: [String] = []
    var titles: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionViewFormat()
        
        dispatch_async(dispatch_get_main_queue()) {
            SwiftLoading().showLoading()
            F2FClient.sharedInstance().getURLsFromF2F {(URLs, titles, errorString) in
                if errorString == nil {
                    print(URLs!.count)
                    self.imageURLs = URLs!
                    self.titles = titles!
                }
            }
            SwiftLoading().hideLoading()
        }
        
    }
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 9
        
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("RecipeCollectionViewCell", forIndexPath: indexPath) as! RecipeCollectionViewCell
        
        if imageURLs != [] {
            let imageURL = NSURL(string: imageURLs[indexPath.row])
            if let imageData = NSData(contentsOfURL: imageURL!) {
                cell.imageForRecipe.image = UIImage(data: imageData)
                cell.title.text = titles[indexPath.row]
            } else {
                
            }
        }
        
        return cell
    
    }
    
    
    private func collectionViewFormat() {
        
        let space: CGFloat = 2.0
        let dimension: CGFloat = (view.frame.size.width - (2 * space)) / 3.0
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSizeMake(dimension, dimension)
        
    }
}
