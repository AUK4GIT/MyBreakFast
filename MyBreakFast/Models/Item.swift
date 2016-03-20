//
//  Item.swift
//  
//
//  Created by Uday Kiran Ailapaka on 14/11/15.
//
//

import Foundation
import CoreData


class Item: NSManagedObject {

// Insert code here to add functionality to your managed object subclass

    func saveData(dict: NSDictionary){
        
        if let obj = dict.objectForKey("id") as? NSNumber{
            self.itemid = obj.stringValue
        } else {
            self.itemid = dict.objectForKey("id") as? String;
        }
        if let obj = dict.objectForKey("name") as? String{
            self.itemname = obj
        } else {
            self.itemname = "\(dict.objectForKey("name"))";
        }
        if let obj = dict.objectForKey("location_id") as? NSNumber{
            self.locationid = obj.stringValue
        } else {
            self.locationid = dict.objectForKey("location_id") as? String;
        }
        if let obj = dict.objectForKey("description") as? String{
            self.itemdescription = obj
        } else {
            self.itemdescription = "\(dict.objectForKey("description"))";
        }
        if let obj = dict.objectForKey("category") as? String{
            self.category = obj
        } else {
            self.category = "\(dict.objectForKey("category"))";
        }
        if let obj = dict.objectForKey("price") as? NSNumber{
            self.price = obj.stringValue
        } else {
            self.price = dict.objectForKey("price") as? String;
        }
        if let obj = dict.objectForKey("max_order_limit") as? NSNumber{
            self.maxlimit = obj.stringValue
        } else {
            self.maxlimit = dict.objectForKey("max_order_limit") as? String;
        }
        if let obj = dict.objectForKey("img_url") as? String{
            self.imgurl = obj
        } else {
            self.imgurl = "\(dict.objectForKey("img_url"))";
        }
        if let obj = dict.objectForKey("in_stock") as? String{
            self.instock = obj
        } else {
            self.instock = "\(dict.objectForKey("in_stock"))";
        }
        if let obj = dict.objectForKey("active") as? String{
            self.active = obj
        } else {
            self.active = "\(dict.objectForKey("active"))";
        }
        if let obj = dict.objectForKey("best_suited") as? String{
            self.bestsuitedfor = obj
        } else {
            self.bestsuitedfor = "\(dict.objectForKey("best_suited"))";
        }
        if let obj = dict.objectForKey("tags") as? NSArray{
            self.tags = obj.componentsJoinedByString(",");
        }
        if let obj = dict.objectForKey("food_details") as? NSDictionary{
            self.fooddetails = Helper.sharedInstance.getFoodDetailsObject() as? Fooddetails;
            self.fooddetails?.saveData(obj);
            
            if let instock = self.instock {
                if instock == "Yes" {
                    
                    if let stock = obj.objectForKey("stock") as! NSDictionary? {
                        let maxOrdLimit = stock.objectForKey("max_order_limit") as? NSNumber
                        let maxilimit = Int(self.maxlimit!)
                        if let obj = stock.objectForKey("id") as? NSNumber{
                            self.stockid = obj.stringValue
                        } else {
                            self.stockid = stock.objectForKey("id") as? String;
                        }
                        if let presOrder = stock.objectForKey("present_orders") as? NSNumber {
                            let leftoverOrders = Int(maxOrdLimit!) - Int(presOrder)
                            let maxminlimit = min(maxilimit!, leftoverOrders)
                            self.maxlimit = String(maxminlimit);
                            if Int(presOrder) >= Int(maxOrdLimit!){
                                self.instock = "No";
                            }
                        }
                    }
                }
            }

        }
        
    }
}
