//
//  CouponCodeCell.swift
//  MyBreakFast
//
//  Created by Uday Kiran Ailapaka on 04/01/16.
//  Copyright © 2016 AUK. All rights reserved.
//

import Foundation

class CouponCodeCell: UICollectionViewCell {
    
    @IBOutlet weak var couponTextField: UITextField!
    @IBAction func couponAction(sender: AnyObject) {
        self.couponTextField.resignFirstResponder()
        
        if self.couponTextField.text?.characters.count == 0 {
            UIAlertView(title: "First Eat", message: "Coupon code cannot be empty.", delegate: nil, cancelButtonTitle: "OK").show()
            return;
        }
        
        self.couponTextField.text = self.couponTextField.text?.uppercaseString
        
//        let coupons = (Helper.sharedInstance.order?.couponsApplied.filter() { $0.couponname == self.couponTextField.text! })!
        let coupons = Helper.sharedInstance.order?.couponsApplied 

        if coupons!.count > 0 {
//            UIAlertView(title: "First Eat", message: "Coupon code already applied.", delegate: nil, cancelButtonTitle: "OK").show()
            UIAlertView(title: "First Eat", message: "Only one coupon can be applied per order.", delegate: nil, cancelButtonTitle: "OK").show()

            return;
        }
        
        if Helper.sharedInstance.order?.hasRedeemedPoints == true {
            UIAlertView(title: "First Eat", message: "Cannot apply coupon as discounts already applied from redeem points.", delegate: nil, cancelButtonTitle: "OK").show()
            return;
        }
        
        
        Helper.sharedInstance.validateCoupon(self.couponTextField.text!, completionHandler: { (response) -> () in
            
            if let responseStatus = response as? String {
                UIAlertView(title: "First Eat", message: responseStatus, delegate: nil, cancelButtonTitle: "OK").show()
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
                
                
                let discountValue : String?
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
                    coupon.actualDiscount = (Helper.sharedInstance.order?.discount)!
                    let amtPayable = Int((Helper.sharedInstance.order?.totalAmountPayable)!)
                    let totalAmtPay = amtPayable!-Int(Float(discountValue!)!)
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
                    coupon.actualDiscount = (Helper.sharedInstance.order?.discount)!
                    let amtountPayable = Int((Helper.sharedInstance.order?.totalAmountPayable)!)
                    let totalAmtPay = amtountPayable!-discount
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