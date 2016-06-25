//
//  RegularPlan.swift
//  MyBreakFast
//
//  Created by AUK on 18/06/16.
//  Copyright © 2016 AUK. All rights reserved.
//

import Foundation

class RegularPlan: NSObject {
    var name: String?
    var mealPlans: [MealPlan]?

func saveData(mealPlans: NSArray){
    self.mealPlans = [];
        for mealPlan in mealPlans {
            if let mPlan = mealPlan as? NSDictionary {
                let mPlanObj = MealPlan();
                mPlanObj.saveData(mPlan);
                self.mealPlans?.append(mPlanObj)
            }
        }
    }
}