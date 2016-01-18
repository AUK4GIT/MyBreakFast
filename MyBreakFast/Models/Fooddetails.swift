//
//  Fooddetails.swift
//  
//
//  Created by Uday Kiran Ailapaka on 22/12/15.
//
//

import Foundation
import CoreData


class Fooddetails: NSManagedObject {

// Insert code here to add functionality to your managed object subclass
    func saveData(dict: NSDictionary){
        
        if let obj = dict.objectForKey("proteins") as? NSNumber{
            self.proteins = obj.stringValue
        } else {
            self.proteins = dict.objectForKey("proteins") as? String;
        }
        if let obj = dict.objectForKey("carbohydrates") as? NSNumber{
            self.carbohydrates = obj.stringValue
        } else {
            self.carbohydrates = dict.objectForKey("carbohydrates") as? String;
        }
        if let obj = dict.objectForKey("fats") as? NSNumber{
            self.fats = obj.stringValue
        } else {
            self.fats = dict.objectForKey("fats") as? String;
        }
        if let obj = dict.objectForKey("fibre") as? NSNumber{
            self.fibre = obj.stringValue
        } else {
            self.fibre = dict.objectForKey("fibre") as? String;
        }
        if let obj = dict.objectForKey("calories") as? NSNumber{
            self.calories = obj.stringValue
        } else {
            self.calories = dict.objectForKey("calories") as? String;
        }
        if let obj = dict.objectForKey("offers") as? NSArray{
            let items = self.mutableSetValueForKey("offers");
            for offer in obj {
                let offers = Helper.sharedInstance.getOfferssObject();
                offers.saveData(offer as! NSDictionary);
                items.addObject(offers)
            }
            self.offers = items;
        }
    }
}
