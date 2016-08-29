//
//  Recipe+CoreDataProperties.swift
//  Ready2Cook
//
//  Created by Keisuke Kishida on 8/29/16.
//  Copyright © 2016 kishidak. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Recipe {

    @NSManaged var title: String?
    @NSManaged var source: String?
    @NSManaged var image: NSData?
    @NSManaged var recipeId: String?
    @NSManaged var ingredients: NSSet?

}
