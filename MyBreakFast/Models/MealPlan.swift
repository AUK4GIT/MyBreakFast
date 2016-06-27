//
//  MealPlan.swift
//  MyBreakFast
//
//  Created by AUK on 25/06/16.
//  Copyright © 2016 AUK. All rights reserved.
//

import Foundation

class MealPlan: NSObject {
    var dieticianId: String?
    var planId: String?
    var name: String?
    var selectionText: String?
    var imageURL: String?
    var planDescription: String?
    //    var sat: String?
    //    var sun: String?
    //    var price: String?
    //    var minweek: String?
    
    func saveData(mealPlan: NSDictionary){
    
        
        if let obj = mealPlan.objectForKey("id") as? NSNumber{
            self.planId = obj.stringValue
        } else {
            self.planId = mealPlan.objectForKey("id") as? String;
        }
        
        if let obj = mealPlan.objectForKey("img_url") as? String{
            self.imageURL = obj
        }
        
        if let obj = mealPlan.objectForKey("selection_text") as? String{
            self.selectionText = obj
        }
        
        if let obj = mealPlan.objectForKey("name") as? String{
            self.name = obj
        }
        
        /*
         if let obj = mealPlan.objectForKey("min_week") as? NSNumber{
         self.minweek = obj.stringValue
         } else {
         self.minweek = mealPlan.objectForKey("min_week") as? String;
         }
         
         if let obj = mealPlan.objectForKey("price") as? NSNumber{
         self.price = obj.stringValue
         } else {
         self.price = mealPlan.objectForKey("price") as? String;
         }
         
         if let obj = mealPlan.objectForKey("sat") as? NSNumber{
         self.sat = obj.stringValue
         } else {
         self.sat = mealPlan.objectForKey("sat") as? String;
         }
         
         if let obj = mealPlan.objectForKey("sun") as? NSNumber{
         self.sun = obj.stringValue
         } else {
         self.sun = mealPlan.objectForKey("sun") as? String;
         }
         
         
         
         */
        
        if let obj = mealPlan.objectForKey("description") as? String{
            self.planDescription = obj
        }
        
        if let obj = mealPlan.objectForKey("dietician") as? NSDictionary{
            if let dietobj = obj.objectForKey("id") as? NSNumber{
                self.dieticianId = dietobj.stringValue
            } else {
                self.dieticianId = obj.objectForKey("id") as? String;
            }
        }
    }
}