//
//  MyOrder.swift
//  
//
//  Created by Uday Kiran Ailapaka on 29/12/15.
//
//

import Foundation
import CoreData


class MyOrder: NSManagedObject {

// Insert code here to add functionality to your managed object subclass
    
    func saveData(dict: NSDictionary){
        
        if let obj = dict.objectForKey("sub_total") as? NSNumber{
            self.subtotal = obj.stringValue
        } else {
            self.subtotal = dict.objectForKey("sub_total") as? String;
        }
        if let obj = dict.objectForKey("total_amount") as? NSNumber{
            self.totalamount = obj.stringValue
        } else {
            self.totalamount = dict.objectForKey("total_amount") as? String;
        }
        if let obj = dict.objectForKey("id") as? NSNumber{
            self.orderid = obj.stringValue
        } else {
            self.orderid = dict.objectForKey("id") as? String;
        }
        let orderStatuses = dict.objectForKey("orderStatuses") as? [NSDictionary];
        if orderStatuses?.count>0 {
            self.deliveryStatus = orderStatuses![0].objectForKey("order_status") as? String;
            self.deliveryTime = orderStatuses![0].objectForKey("status_date") as? String;
        }
        let orderAddresses = dict.objectForKey("orderAddresses") as? [NSDictionary];
        if orderAddresses?.count>0 {
            
            if let obj = orderAddresses![0].objectForKey("address_id") as? NSNumber{
                self.addressId = obj.stringValue
            } else {
                self.addressId = orderAddresses![0].objectForKey("address_id") as? String;
            }
        }
        
    }


}
