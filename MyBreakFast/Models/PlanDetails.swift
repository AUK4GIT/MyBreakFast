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
    var priceSat: String?
    var priceSun: String?
    var priceSatSun: String?
    var sat: String?
    var sun: String?
    var minweek: String?
    var meal1Exists: String?
    var meal2Exists: String?
    var meal3Exists: String?
    var selectionText: String?
    
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
        
        if let obj = dict.objectForKey("price_with_sat") as? NSNumber{
            self.priceSat = obj.stringValue
        } else {
            self.priceSat = dict.objectForKey("price_with_sat") as? String;
        }
        
        if let obj = dict.objectForKey("price_with_sun") as? NSNumber{
            self.priceSun = obj.stringValue
        } else {
            self.priceSun = dict.objectForKey("price_with_sun") as? String;
        }
        
        if let obj = dict.objectForKey("price_with_sat_n_sun") as? NSNumber{
            self.priceSatSun = obj.stringValue
        } else {
            self.priceSatSun = dict.objectForKey("price_with_sat_n_sun") as? String;
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
        
        if let obj = dict.objectForKey("meal1_exist") as? NSNumber{
            self.meal1Exists = obj.stringValue
        } else {
            self.meal1Exists = dict.objectForKey("meal1_exist") as? String;
        }
        
        if let obj = dict.objectForKey("meal2_exist") as? NSNumber{
            self.meal2Exists = obj.stringValue
        } else {
            self.meal2Exists = dict.objectForKey("meal2_exist") as? String;
        }
        
        if let obj = dict.objectForKey("meal3_exist") as? NSNumber{
            self.meal3Exists = obj.stringValue
        } else {
            self.meal3Exists = dict.objectForKey("meal3_exist") as? String;
        }
        
        if let obj = dict.objectForKey("name") as? String{
            self.name = obj
        }
        
        if let obj = dict.objectForKey("selection_text") as? String{
            self.selectionText = obj
        }
        
        if let obj = dict.objectForKey("description") as? String{
            self.planDescription = obj
        }
        
        if let obj = dict.objectForKey("img_url") as? String{
            self.planImgURL = obj
        }
    }
}

