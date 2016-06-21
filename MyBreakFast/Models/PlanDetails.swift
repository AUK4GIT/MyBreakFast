//
//  PlanDetails.swift
//  MyBreakFast
//
//  Created by AUK on 20/06/16.
//  Copyright © 2016 AUK. All rights reserved.
//

import Foundation

class PlanDetails: NSObject {
    var planDescription: String?
    var planImgURL: String?
    var dieticianId: String?
    var planId: String?
    var name: String?
    var price: String?
    var sat: String?
    var sun: String?
    var minweek: String?
    
    func saveData(dict: NSDictionary){
        
        if let obj = dict.objectForKey("id") as? NSNumber{
            self.planId = obj.stringValue
        } else {
            self.planId = dict.objectForKey("id") as? String;
        }
        
        if let obj = dict.objectForKey("dietician") as? NSNumber{
            self.dieticianId = obj.stringValue
        } else {
            self.dieticianId = dict.objectForKey("dietician") as? String;
        }
        
        if let obj = dict.objectForKey("price") as? NSNumber{
            self.price = obj.stringValue
        } else {
            self.price = dict.objectForKey("price") as? String;
        }
        
        if let obj = dict.objectForKey("sat") as? NSNumber{
            self.sat = obj.stringValue
        } else {
            self.sat = dict.objectForKey("sat") as? String;
        }
        
        if let obj = dict.objectForKey("sun") as? NSNumber{
            self.sun = obj.stringValue
        } else {
            self.sun = dict.objectForKey("sun") as? String;
        }
        
        if let obj = dict.objectForKey("min_week") as? NSNumber{
            self.minweek = obj.stringValue
        } else {
            self.minweek = dict.objectForKey("min_week") as? String;
        }
        
        if let obj = dict.objectForKey("name") as? String{
            self.name = obj
        }
        
        if let obj = dict.objectForKey("description") as? String{
            self.planDescription = obj
        }
        
        if let obj = dict.objectForKey("img_url") as? String{
            self.planImgURL = obj
        }
    }
}

