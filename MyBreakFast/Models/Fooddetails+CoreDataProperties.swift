//
//  Fooddetails+CoreDataProperties.swift
//  
//
//  Created by Uday Kiran Ailapaka on 01/01/16.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Fooddetails {

    @NSManaged var calories: String?
    @NSManaged var carbohydrates: String?
    @NSManaged var fats: String?
    @NSManaged var fibre: String?
    @NSManaged var proteins: String?
    @NSManaged var offers: NSSet?

}
