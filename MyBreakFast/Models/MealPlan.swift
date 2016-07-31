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
    var numberofMeals: String = "0"
    var meal1Exists: String?
    var meal2Exists: String?
    var meal3Exists: String?
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
        
        var noOfMeals = 0;
        if let obj = mealPlan.objectForKey("meal1_exist") as? NSNumber{
            self.meal1Exists = obj.stringValue
        } else {
            self.meal1Exists = mealPlan.objectForKey("meal1_exist") as? String;
        }
        
        if let obj = mealPlan.objectForKey("meal2_exist") as? NSNumber{
            self.meal2Exists = obj.stringValue
        } else {
            self.meal2Exists = mealPlan.objectForKey("meal2_exist") as? String;
        }
        
        if let obj = mealPlan.objectForKey("meal3_exist") as? NSNumber{
            self.meal3Exists = obj.stringValue
        } else {
            self.meal3Exists = mealPlan.objectForKey("meal3_exist") as? String;
        }
        
        if self.meal1Exists == "1" {
            noOfMeals = noOfMeals+1;
        }
        if self.meal2Exists == "1" {
            noOfMeals = noOfMeals+1;
        }
        if self.meal3Exists == "1" {
            noOfMeals = noOfMeals+1;
        }
        
        self.numberofMeals = String(noOfMeals);
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