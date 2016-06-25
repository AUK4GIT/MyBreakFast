//
//  MealSlot.swift
//  MyBreakFast
//
//  Created by AUK on 20/06/16.
//  Copyright © 2016 AUK. All rights reserved.
//

import Foundation

class MealSlot: NSObject {
    var slotType: String?
    var mealSlots: [TimeSlot]?
    
    func saveData(dict: NSArray){
        self.mealSlots = []
        for slot in dict {
            if let slot = slot as? NSDictionary {
            let tSlot = TimeSlot()
            
            if let obj = slot.objectForKey("id") as? NSNumber{
                tSlot.slotId = obj.stringValue
            } else {
                tSlot.slotId = slot.objectForKey("id") as? String;
            }

            if let obj = slot.objectForKey("start_time") as? String{
                tSlot.startTime = obj
            }
            
            if let obj = slot.objectForKey("end_time") as? String{
                tSlot.endTime = obj
            }
            
            self.mealSlots?.append(tSlot);
        }
        }
    }
    
}