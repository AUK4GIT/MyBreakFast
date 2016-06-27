//
//  Order.swift
//  MyBreakFast
//
//  Created by Uday Kiran Ailapaka on 30/12/15.
//  Copyright © 2015 AUK. All rights reserved.
//

import Foundation

class Order: NSObject {
    
    //Alacarte
    var orders: [OrderItem] = []
    var timeSlotId: String?
    var addressId: String?
    var orderId: String?
    var slot: String?
    
    //common
    var discount: String = "0";
    var couponsApplied: [Coupon] = [];
    var hasRedeemedPoints: Bool = false;
    var pointsToRedeem = "0";
    var modeOfPayment: PaymentType = PaymentType.NONE;
    var totalAmount: String?
    var totalAmountPayable: String?
    var vatAmount: String?
    var serviceChargeAmount: String?
    var offers: [Offer] = []
    var change: String?
    
    //Subscription
    var mealPlanId: String?
    var address1: String?
    var slot1: String?
    var address2: String?
    var slot2: String?
    var address3: String?
    var slot3: String?
    var weeks:String?
    var subscriptionDate: String?
    var satIncluded: String?

}