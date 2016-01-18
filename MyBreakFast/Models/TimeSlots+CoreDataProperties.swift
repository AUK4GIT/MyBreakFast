//
//  TimeSlots+CoreDataProperties.swift
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

extension TimeSlots {

    @NSManaged var endtime: String?
    @NSManaged var kitchenid: String?
    @NSManaged var orderlimit: String?
    @NSManaged var presentorders: String?
    @NSManaged var slot: String?
    @NSManaged var slotid: String?
    @NSManaged var starttime: String?
    @NSManaged var status: String?

}
