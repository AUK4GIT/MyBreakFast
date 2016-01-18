//
//  MyOrder+CoreDataProperties.swift
//  
//
//  Created by Uday Kiran Ailapaka on 29/12/15.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension MyOrder {

    @NSManaged var couponid: String?
    @NSManaged var date: String?
    @NSManaged var deliveredtime: String?
    @NSManaged var deliveryStatus: String?
    @NSManaged var deliveryTime: String?
    @NSManaged var discount: String?
    @NSManaged var extra: String?
    @NSManaged var invoiceid: String?
    @NSManaged var orderedtime: String?
    @NSManaged var orderid: String?
    @NSManaged var subtotal: String?
    @NSManaged var surcharge: String?
    @NSManaged var totalamount: String?
    @NSManaged var userid: String?
    @NSManaged var vat: String?
    @NSManaged var addressId: String?

}
