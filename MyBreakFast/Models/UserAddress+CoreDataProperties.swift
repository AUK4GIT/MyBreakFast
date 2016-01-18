//
//  UserAddress+CoreDataProperties.swift
//  
//
//  Created by Uday Kiran Ailapaka on 28/12/15.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension UserAddress {

    @NSManaged var addressId: String?
    @NSManaged var lineone: String?
    @NSManaged var linetwo: String?
    @NSManaged var category: String?
    @NSManaged var cluster: String?

}
