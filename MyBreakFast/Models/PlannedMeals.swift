//
//  PlannedMeals.swift
//  MyBreakFast
//
//  Created by AUK on 20/06/16.
//  Copyright © 2016 AUK. All rights reserved.
//

import Foundation

class PlannedMeals: NSObject {
    var mealId: String?
    var menuId: String?
    var calories: String?
    var carbohydrates: String?
    var fats: String?
    var fibre: String?
    var proteins: String?
    var name: String?
    var mealDescription: String?
    var bestSuitedfor: String?
    var imgURL: String?
    
    func saveData(dict: NSDictionary){
        
        if let dicti = dict.objectForKey("food_details") as? NSDictionary
        {
        
            if let obj = dicti.objectForKey("id") as? NSNumber{
                self.mealId = obj.stringValue
            } else {
                self.mealId = dicti.objectForKey("id") as? String;
            }
            
            if let obj = dicti.objectForKey("menu_id") as? NSNumber{
                self.menuId = obj.stringValue
            } else {
                self.menuId = dicti.objectForKey("menu_id") as? String;
            }
            
            if let obj = dicti.objectForKey("calories") as? NSNumber{
                self.calories = obj.stringValue
            } else {
                self.calories = dicti.objectForKey("calories") as? String;
            }
            
            if let obj = dicti.objectForKey("carbohydrates") as? NSNumber{
                self.carbohydrates = obj.stringValue
            } else {
                self.carbohydrates = dicti.objectForKey("carbohydrates") as? String;
            }
            
            if let obj = dicti.objectForKey("fats") as? NSNumber{
                self.fats = obj.stringValue
            } else {
                self.fats = dicti.objectForKey("fats") as? String;
            }
            
            if let obj = dicti.objectForKey("fibre") as? NSNumber{
                self.fibre = obj.stringValue
            } else {
                self.fibre = dicti.objectForKey("fibre") as? String;
            }
            
            if let obj = dicti.objectForKey("proteins") as? NSNumber{
                self.proteins = obj.stringValue
            } else {
                self.proteins = dicti.objectForKey("proteins") as? String;
            }
        }
        
        if let obj = dict.objectForKey("name") as? String{
            self.name = obj
        }
        
        if let obj = dict.objectForKey("best_suited") as? String{
            self.bestSuitedfor = obj
        }
        
        if let obj = dict.objectForKey("img_url") as? String{
            self.imgURL = obj
        }
        
        if let obj = dict.objectForKey("description") as? String{
            self.mealDescription = obj
        }
    }
}