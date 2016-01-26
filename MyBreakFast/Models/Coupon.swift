//
//  Coupon.swift
//  MyBreakFast
//
//  Created by Uday Kiran Ailapaka on 26/01/16.
//  Copyright © 2016 AUK. All rights reserved.
//

import Foundation

class Coupon: NSObject {
    var couponid: String?
    var couponname: String?
    var discounttype: String?
    var discountvalue: String?
    var maxdiscount: String?
    var maxredeem: String?
    var category: String?
    var startdate: String?
    var enddate: String?
    var actualDiscount: String = "0";
}