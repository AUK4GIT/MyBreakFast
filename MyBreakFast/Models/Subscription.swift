//
//  Subscription.swift
//  MyBreakFast
//
//  Created by AUK on 18/06/16.
//  Copyright © 2016 AUK. All rights reserved.
//

import Foundation

class Subscription: NSObject {
    var planType: String?
    var dieticians: [Dietician]?
    var regplans: [RegularPlan]?
    var selectedPlanId: String?
    var selectedDieticianId: String?
    var planDetails: PlanDetails?
    var planSlots: [MealSlot]?
    var mealPlans: [PlannedMeals]?
    
    func saveSubscrDetails(dict: NSDictionary){
        
        if let dicti = dict.objectForKey("meal_plan") as? NSDictionary{
            self.planDetails = PlanDetails()
            self.planDetails?.saveData(dicti)
        }
        
        if let dicti = dict.objectForKey("meal_slots") as? NSDictionary{
            self.planSlots = []
            if let dict = dicti.objectForKey("m1_timeslots") as? NSArray{
                let mealSlots = MealSlot();
                mealSlots.slotType = "1";
                mealSlots.saveData(dict)
                self.planSlots?.append(mealSlots)
            }
            
            if let dict = dicti.objectForKey("m2_timeslots") as? NSArray{
                let mealSlots = MealSlot();
                mealSlots.slotType = "2";
                mealSlots.saveData(dict)
                self.planSlots?.append(mealSlots)
            }
            
            if let dict = dicti.objectForKey("m3_timeslots") as? NSArray{
                let mealSlots = MealSlot();
                mealSlots.slotType = "3";
                mealSlots.saveData(dict)
                self.planSlots?.append(mealSlots)
            }
        }
        
        if let dicti = dict.objectForKey("meals") as? NSArray{
            self.mealPlans = []
            for dict in dicti {
                let plannedMeal = PlannedMeals()
                plannedMeal.saveData(dict as! NSDictionary)
                self.mealPlans?.append(plannedMeal)
            }
        }
    }
    
    func saveData(dict: NSDictionary){
        if let dieticians = dict.objectForKey("dieticians") as? NSArray {
            self.dieticians = [];
            for dietician in dieticians {
                let dietiObj = Dietician()
                if let obj = dietician.objectForKey("id") as? NSNumber{
                    dietiObj.dieticianId = obj.stringValue
                } else {
                    dietiObj.dieticianId = dietician.objectForKey("id") as? String;
                }
                if let obj = dietician.objectForKey("f_name") as? String{
                    dietiObj.firstName = obj
                }
                if let obj = dietician.objectForKey("l_name") as? String{
                    dietiObj.lastName = obj
                }
                if let obj = dietician.objectForKey("img_url") as? String{
                    dietiObj.imgURL = obj
                }
                if let obj = dietician.objectForKey("bio") as? String{
                    dietiObj.biography = obj
                }
                self.dieticians?.append(dietiObj)
            }
            
        }
        
        if let plans = dict.objectForKey("regular_plans") as? NSArray {
            self.regplans = [];
            for plan in plans {
                let planObj = RegularPlan();
                if let obj = plan.objectForKey("name") as? String{
                    planObj.name = obj
                }
                if let mealPlans = plan.objectForKey("meal_plans") as? NSArray{
                    planObj.saveData(mealPlans);
                }
                self.regplans?.append(planObj)
            }
        }
    }
}

