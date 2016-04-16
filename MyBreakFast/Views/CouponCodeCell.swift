//
//  CouponCodeCell.swift
//  MyBreakFast
//
//  Created by Uday Kiran Ailapaka on 04/01/16.
//  Copyright © 2016 AUK. All rights reserved.
//

import Foundation

class CouponCodeCell: UICollectionViewCell {
    
    @IBOutlet  var couponTextField: UITextField!
    @IBAction func couponAction(sender: UIButton) {
        self.couponTextField.resignFirstResponder()
        sender.enabled = false;
        if self.couponTextField.text?.characters.count == 0 {
            UIAlertView(title: "First Eat", message: "Coupon code cannot be empty.", delegate: nil, cancelButtonTitle: "OK").show()
            sender.enabled = true;
            return;
        }
        
        self.couponTextField.text = self.couponTextField.text?.uppercaseString
        
//        let coupons = (Helper.sharedInstance.order?.couponsApplied.filter() { $0.couponname == self.couponTextField.text! })!
        let coupons = Helper.sharedInstance.order?.couponsApplied 

        if coupons!.count > 0 {
//            UIAlertView(title: "First Eat", message: "Coupon code already applied.", delegate: nil, cancelButtonTitle: "OK").show()
            UIAlertView(title: "First Eat", message: "Only one coupon can be applied per order.", delegate: nil, cancelButtonTitle: "OK").show()
            sender.enabled = true;
            return;
        }
        
        if Helper.sharedInstance.order?.hasRedeemedPoints == true {
            UIAlertView(title: "First Eat", message: "Cannot apply coupon as discounts already applied from redeem points.", delegate: nil, cancelButtonTitle: "OK").show()
            sender.enabled = true;
            return;
        }
        
        
        Helper.sharedInstance.validateCoupon(self.couponTextField.text!, completionHandler: { (response) -> () in
            sender.enabled = true;
            if let responseStatus = response as? String {
                if responseStatus == "max_redeem_limit"{
                    UIAlertView(title: "First Eat", message: "The coupon has already been used.", delegate: nil, cancelButtonTitle: "OK").show()
                } else {
                UIAlertView(title: "First Eat", message: responseStatus, delegate: nil, cancelButtonTitle: "OK").show()
                }
            } else if let responseStat = response as? NSDictionary{
                let couponName = responseStat.objectForKey("coupon_name") as? String
                let discountType = responseStat.objectForKey("discount_type") as? String
                let endDateStr = responseStat.objectForKey("end_date") as? String
                let dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                let endDate = dateFormatter.dateFromString(endDateStr!);
                let currentDate = dateFormatter.dateFromString(dateFormatter.stringFromDate(NSDate()));
                
                let result: NSComparisonResult  = (endDate?.compare(currentDate!))!
                if result == NSComparisonResult.OrderedAscending
                {
                    UIAlertView(title: "First Eat", message: "Coupon Expired.", delegate: nil, cancelButtonTitle: "OK").show()
                    return;
                }
                
                
                var discountValue : String?
                let maxDiscountAmount: String?
                if let discount_Value = responseStat.objectForKey("discount_value") as? NSNumber{
                    discountValue = discount_Value.stringValue;
                } else {
                    discountValue = responseStat.objectForKey("discount_value") as? String;
                }
                if let maxDiscount_Amount = responseStat.objectForKey("max_discount_amount") as? NSNumber{
                    maxDiscountAmount = maxDiscount_Amount.stringValue
                } else {
                    maxDiscountAmount = responseStat.objectForKey("max_discount_amount") as? String
                }
                
                let coupon = Coupon();
                if let couponID = responseStat.objectForKey("id") as? NSNumber{
                    coupon.couponid = couponID.stringValue;
                } else {
                    coupon.couponid = responseStat.objectForKey("id") as? String;
                }
                if let maxRede = responseStat.objectForKey("max_redeem") as? NSNumber{
                    coupon.maxredeem = maxRede.stringValue;
                } else {
                    coupon.maxredeem = responseStat.objectForKey("max_redeem") as? String;
                }
                coupon.couponname = couponName!;
                coupon.category = responseStat.objectForKey("category") as? String;
                coupon.discounttype = discountType!;
                coupon.discountvalue = discountValue!;
                coupon.maxdiscount = maxDiscountAmount!;
                coupon.startdate = responseStat.objectForKey("start_date") as? String;
                coupon.enddate = endDateStr!;
                
                Helper.sharedInstance.order?.couponsApplied.insert(coupon, atIndex: (Helper.sharedInstance.order?.couponsApplied.count)!)

                if discountType == "AMOUNT"{
                    Helper.sharedInstance.order?.discount = String(Int((Helper.sharedInstance.order?.discount)!)! + Int(Float(discountValue!)!))
                    if couponName == "TEAM250" {
                        let totAmnt = Int((Helper.sharedInstance.order?.totalAmount)!)
                        let couponDiscount = totAmnt! - 250
                        Helper.sharedInstance.order?.discount = String(couponDiscount); //maxDiscountAmount!;
                        discountValue = maxDiscountAmount;
                        coupon.discountvalue = discountValue!;
                    }
                    let amtPayable = Int((Helper.sharedInstance.order?.totalAmountPayable)!)
                    var totalAmtPay = amtPayable!-Int(Float(discountValue!)!)
                    if totalAmtPay < 0 {
                        discountValue = (Helper.sharedInstance.order?.totalAmount)
                        Helper.sharedInstance.order?.discount = discountValue!;
                        totalAmtPay = 0;
                    }
                    coupon.actualDiscount = (Helper.sharedInstance.order?.discount)!
                    Helper.sharedInstance.order?.totalAmountPayable = String(totalAmtPay)
                 
                    UIApplication.sharedApplication().sendAction("updateCartWithTotalAmountPayableWithDiscount:", to: nil, from: self, forEvent: nil)
                    let messg = "Coupon "+couponName!+" applied. "+"discount value: "+discountValue!
                    UIAlertView(title: "First Eat", message: messg, delegate: nil, cancelButtonTitle: "OK").show()
                } else {
                //percentage
                    let amtWithoutVATandSC = Int((Helper.sharedInstance.order?.totalAmount)!)

                    var discount = amtWithoutVATandSC! * Int(Float(discountValue!)!) / 100;
                    if discount > Int(maxDiscountAmount!)! {
                        discount = Int(maxDiscountAmount!)!
                    }
                    
                    Helper.sharedInstance.order?.discount = String(Int((Helper.sharedInstance.order?.discount)!)! + discount)
                    if couponName == "TEAM250" {
                        let totAmnt = Int((Helper.sharedInstance.order?.totalAmount)!)
                        let couponDiscount = totAmnt! - 250
                        Helper.sharedInstance.order?.discount = String(couponDiscount); //maxDiscountAmount!;
                        discount = Int(maxDiscountAmount!)!
                        coupon.discountvalue = String(discount);
                    }
                    let amtountPayable = Int((Helper.sharedInstance.order?.totalAmountPayable)!)
                    var totalAmtPay = amtountPayable!-discount
                    if totalAmtPay < 0 {
                        discount = Int((Helper.sharedInstance.order?.totalAmount)!)!
                        Helper.sharedInstance.order?.discount = String(discount);
                        totalAmtPay = 0;
                    }
                    coupon.actualDiscount = (Helper.sharedInstance.order?.discount)!

                    Helper.sharedInstance.order?.totalAmountPayable = String(totalAmtPay)
                  
                    UIApplication.sharedApplication().sendAction("updateCartWithTotalAmountPayableWithDiscount:", to: nil, from: self, forEvent: nil)

                    let messg = "Coupon "+couponName!+" applied. "+"discount value: "+String(discount)
                    UIAlertView(title: "First Eat", message: messg, delegate: nil, cancelButtonTitle: "OK").show()
                }
            }
            self.couponTextField.text = "";
        })

    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        return true
    }

}