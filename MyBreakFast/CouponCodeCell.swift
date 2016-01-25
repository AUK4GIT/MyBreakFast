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
        
        if ((Helper.sharedInstance.order?.couponsApplied.indexOf(self.couponTextField.text!)) != nil) {
            UIAlertView(title: "First Eat", message: "Coupon code already applied.", delegate: nil, cancelButtonTitle: "OK").show()
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
                dateFormatter.dateFormat = "YYYY-MM-DD"
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

                if discountType == "AMOUNT"{
                    Helper.sharedInstance.order?.discount = String(Int((Helper.sharedInstance.order?.discount)!)! + Int(Float(discountValue!)!))
                    let amtPayable = Int((Helper.sharedInstance.order?.totalAmountPayable)!)
                    let totalAmtPay = amtPayable!-Int(Float(discountValue!)!)
                    Helper.sharedInstance.order?.totalAmountPayable = String(totalAmtPay)
                    UIApplication.sharedApplication().sendAction("updateCartWithTotalAmountPayableWithDiscount:", to: nil, from: self, forEvent: nil)
                    let messg = "Coupon "+couponName!+" applied. "+"discount value: "+discountValue!
                    UIAlertView(title: "First Eat", message: messg, delegate: nil, cancelButtonTitle: "OK").show()
                } else {
                //percentage
//                    let amtPayable = Int((Helper.sharedInstance.order?.totalAmountPayable)!)
                    let amtWithoutVATandSC = Int((Helper.sharedInstance.order?.totalAmount)!)

                    var discount = amtWithoutVATandSC! * Int(Float(discountValue!)!) / 100;
                    if discount > Int(maxDiscountAmount!)! {
                        discount = Int(maxDiscountAmount!)!
                    }
                    
                    Helper.sharedInstance.order?.discount = String(Int((Helper.sharedInstance.order?.discount)!)! + discount)
                    let amtountPayable = Int((Helper.sharedInstance.order?.totalAmountPayable)!)
                    let totalAmtPay = amtountPayable!-discount
                    Helper.sharedInstance.order?.totalAmountPayable = String(totalAmtPay)
                    UIApplication.sharedApplication().sendAction("updateCartWithTotalAmountPayableWithDiscount:", to: nil, from: self, forEvent: nil)

                    let messg = "Coupon "+couponName!+" applied. "+"discount value: "+String(discount)
                    UIAlertView(title: "First Eat", message: messg, delegate: nil, cancelButtonTitle: "OK").show()
                }
                Helper.sharedInstance.order?.couponsApplied.insert(self.couponTextField.text!, atIndex: (Helper.sharedInstance.order?.couponsApplied.count)!)
            }
            self.couponTextField.text = "";
        })

    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        return true
    }

}