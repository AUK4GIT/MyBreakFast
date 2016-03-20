//
//  Item+CoreDataProperties.swift
//  
//
//  Created by Uday Kiran Ailapaka on 19/03/16.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Item {

    @NSManaged var active: String?
    @NSManaged var bestsuitedfor: String?
    @NSManaged var category: String?
    @NSManaged var imgurl: String?
    @NSManaged var instock: String?
    @NSManaged var itemdescription: String?
    @NSManaged var itemid: String?
    @NSManaged var itemname: String?
    @NSManaged var locationid: String?
    @NSManaged var maxlimit: String?
    @NSManaged var price: String?
    @NSManaged var stockid: String?
    @NSManaged var tags: String?
    @NSManaged var fooddetails: Fooddetails?

}
