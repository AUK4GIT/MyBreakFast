//
//  Offer+CoreDataProperties.swift
//  
//
//  Created by Uday Kiran Ailapaka on 07/01/16.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Offer {

    @NSManaged var menuid: String?
    @NSManaged var offerdesc: String?
    @NSManaged var offerid: String?
    @NSManaged var offername: String?
    @NSManaged var price: String?
    @NSManaged var quantity: String?
    @NSManaged var startdate: String?
    @NSManaged var status: String?
    @NSManaged var offeroftheday: String?

}
