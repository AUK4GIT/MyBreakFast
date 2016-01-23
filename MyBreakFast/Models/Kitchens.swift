//
//  Kitchens.swift
//  
//
//  Created by Uday Kiran Ailapaka on 20/01/16.
//
//

import Foundation
import CoreData


class Kitchens: NSManagedObject {

// Insert code here to add functionality to your managed object subclass
    
    func saveData(dict: NSDictionary){
        
        if let obj = dict.objectForKey("id") as? NSNumber{
            self.kid = obj.stringValue
        } else {
            self.kid = dict.objectForKey("id") as? String;
        }
        if let obj = dict.objectForKey("radius") as? NSNumber{
            self.radius = obj.stringValue
        } else {
            self.radius = dict.objectForKey("radius") as? String;
        }
        if let obj = dict.objectForKey("mobile") as? NSNumber{
            self.mobile = obj.stringValue
        } else {
            self.mobile = dict.objectForKey("mobile") as? String;
        }
        if let obj = dict.objectForKey("landline") as? NSNumber{
            self.landline = obj.stringValue
        } else {
            self.landline = dict.objectForKey("landline") as? String;
        }
        if let obj = dict.objectForKey("latitude") as? NSNumber{
            self.latitude = obj.stringValue
        } else {
            self.latitude = dict.objectForKey("latitude") as? String;
        }
        if let obj = dict.objectForKey("longitude") as? NSNumber{
            self.longitude = obj.stringValue
        } else {
            self.longitude = dict.objectForKey("longitude") as? String;
        }
        
        if let obj = dict.objectForKey("active") as? String{
            self.active = obj
        }
        if let obj = dict.objectForKey("address") as? String{
            self.address = obj
        }
        if let obj = dict.objectForKey("cluster") as? String{
            self.cluster = obj
        }
        if let obj = dict.objectForKey("description") as? String{
            self.kdescription = obj
        }
        if let obj = dict.objectForKey("location") as? String{
            self.location = obj
        }
        if let obj = dict.objectForKey("name") as? String{
            self.name = obj
        }
    }

}
