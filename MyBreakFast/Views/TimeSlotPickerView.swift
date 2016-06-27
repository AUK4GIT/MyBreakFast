//
//  TimeSlotPickerView.swift
//  MyBreakFast
//
//  Created by AUK on 26/06/16.
//  Copyright © 2016 AUK. All rights reserved.
//

import Foundation

class TimeSlotPickerView: UIView {
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        UIApplication.sharedApplication().sendAction(#selector(SubscriptionDetailsVC.dismissTimeSlotPicker), to: nil, from: self, forEvent: nil)
    }
}