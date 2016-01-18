//
//  Offer.swift
//  
//
//  Created by Uday Kiran Ailapaka on 14/11/15.
//
//

import Foundation
import CoreData


@objc class Offer: NSManagedObject {

// Insert code here to add functionality to your managed object subclass
func saveData(dict: NSDictionary){
    
    if let obj = dict.objectForKey("id") as? NSNumber{
        self.offerid = obj.stringValue
    } else {
        self.offerid = dict.objectForKey("id") as? String;
    }
    
    if let obj = dict.objectForKey("offer_name") as? NSNumber{
        self.offername = obj.stringValue
    } else {
        self.offername = dict.objectForKey("offer_name") as? String;
    }
    
    if let obj = dict.objectForKey("description") as? NSNumber{
        self.offerdesc = obj.stringValue
    } else {
        self.offerdesc = dict.objectForKey("description") as? String;
    }
    
    if let obj = dict.objectForKey("qty") as? NSNumber{
        self.quantity = obj.stringValue
    } else {
        self.quantity = dict.objectForKey("qty") as? String;
    }
    
    if let obj = dict.objectForKey("price") as? NSNumber{
        self.price = obj.stringValue
    } else {
        self.price = dict.objectForKey("price") as? String;
    }
    
    if let obj = dict.objectForKey("menu_id") as? NSNumber{
        self.menuid = obj.stringValue
    } else {
        self.menuid = dict.objectForKey("menu_id") as? String;
    }
    
    if let obj = dict.objectForKey("status") as? NSNumber{
        self.status = obj.stringValue
    } else {
        self.status = dict.objectForKey("status") as? String;
    }
    
    if let obj = dict.objectForKey("start_date") as? NSNumber{
        self.startdate = obj.stringValue
    } else {
        self.startdate = dict.objectForKey("start_date") as? String;
    }
    
    if let obj = dict.objectForKey("offer_of_the_day") as? NSNumber{
        self.offeroftheday = obj.stringValue
    } else {
        self.offeroftheday = dict.objectForKey("offer_of_the_day") as? String;
    }
    
    }
    
}
