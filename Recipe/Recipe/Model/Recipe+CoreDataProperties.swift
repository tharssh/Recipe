//
//  Recipe+CoreDataProperties.swift
//  Recipe
//
//  Created by InsightzClub on 11/04/2020.
//  Copyright © 2020 Tharsshinee. All rights reserved.
//
//

import Foundation
import CoreData


extension Recipe {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Recipe> {
        return NSFetchRequest<Recipe>(entityName: "Recipe")
    }
    

    @NSManaged public var type: String?
    @NSManaged public var ingredients: String?
    @NSManaged public var steps: String?
    @NSManaged public var image: NSData?
    @NSManaged public var title: String?

}
