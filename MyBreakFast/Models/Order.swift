//
//  Order.swift
//  MyBreakFast
//
//  Created by Uday Kiran Ailapaka on 30/12/15.
//  Copyright © 2015 AUK. All rights reserved.
//

import Foundation

class Order: NSObject {
    var orders: [OrderItem] = []
    var timeSlotId: String?
    var addressId: String?
    var totalAmount: String?
    var totalAmountPayable: String?
    var vatAmount: String?
    var serviceChargeAmount: String?
    var offers: [Offer] = []
    var change: String?
    var orderId: String?
    var slot: String?
    var discount: String = "0";
    var couponsApplied: [String] = [];
}