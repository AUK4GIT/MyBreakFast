//
//  Locations.swift
//  
//
//  Created by Uday Kiran Ailapaka on 14/11/15.
//
//

import Foundation
import CoreData


class Locations: NSManagedObject {

// Insert code here to add functionality to your managed object subclass
    
    func saveData(dict: NSDictionary){
        
        if let obj = dict.objectForKey("id") as? NSNumber{
            self.locationId = obj.stringValue
        } else {
            self.locationId = dict.objectForKey("id") as? String;
        }
        if let obj = dict.objectForKey("location_name") as? NSNumber{
            self.locationName = obj.stringValue
        } else {
            self.locationName = dict.objectForKey("location_name") as? String;
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
        if let obj = dict.objectForKey("active") as? NSNumber{
            self.active = obj.stringValue
        } else {
            self.active = dict.objectForKey("active") as? String;
        }
    }

}
