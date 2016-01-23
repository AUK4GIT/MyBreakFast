//
//  Kitchens+CoreDataProperties.swift
//  
//
//  Created by Uday Kiran Ailapaka on 20/01/16.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Kitchens {

    @NSManaged var active: String?
    @NSManaged var address: String?
    @NSManaged var cluster: String?
    @NSManaged var kdescription: String?
    @NSManaged var kid: String?
    @NSManaged var landline: String?
    @NSManaged var latitude: String?
    @NSManaged var longitude: String?
    @NSManaged var location: String?
    @NSManaged var mobile: String?
    @NSManaged var name: String?
    @NSManaged var radius: String?

}
