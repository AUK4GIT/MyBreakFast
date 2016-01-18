//
//  UserDetails+CoreDataProperties.swift
//  
//
//  Created by Uday Kiran Ailapaka on 27/12/15.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension UserDetails {

    @NSManaged var address: String?
    @NSManaged var emailId: String?
    @NSManaged var phoneNumber: String?
    @NSManaged var userName: String?
    @NSManaged var userId: String?
    @NSManaged var referralCode: String?

}
