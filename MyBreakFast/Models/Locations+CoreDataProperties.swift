//
//  Locations+CoreDataProperties.swift
//  
//
//  Created by Uday Kiran Ailapaka on 22/12/15.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Locations {

    @NSManaged var locationId: String?
    @NSManaged var locationName: String?
    @NSManaged var latitude: String?
    @NSManaged var longitude: String?
    @NSManaged var active: String?
    @NSManaged var cluster: String?

}
