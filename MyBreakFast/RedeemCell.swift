//
//  RedeemCell.swift
//  MyBreakFast
//
//  Created by Uday Kiran Ailapaka on 04/01/16.
//  Copyright © 2016 AUK. All rights reserved.
//

import Foundation

class RedeemCell: UICollectionViewCell {
    
    @IBOutlet weak var redeemLabel: UILabel!
    var activity: UIActivityIndicatorView?
    var redeemPoints = "0";

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.activity = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
        self.activity?.frame = CGRectMake(0, 0, 40, 40);
        self.activity?.center = CGPointMake(self.bounds.width/2, self.bounds.height/2);
        self.addSubview(self.activity!);
        self.activity?.color = Constants.StaticContent.AppThemeColor;
        self.activity?.startAnimating()
        self.activity?.hidesWhenStopped = true;

        self.fetchRedeemPoints()
    }
    
    @IBAction func redeemAction(sender: AnyObject) {
        
        if Int(self.redeemPoints)>0 {
            if Helper.sharedInstance.order?.couponsApplied.count > 0 {
                UIAlertView(title: "First Eat", message: "Cannot redeem points as discounts already applied from coupons.", delegate: nil, cancelButtonTitle: "OK").show()
                return;
            }
            if Helper.sharedInstance.order?.hasRedeemedPoints == true {
                UIAlertView(title: "First Eat", message: "Already redeemed Points.", delegate: nil, cancelButtonTitle: "OK").show()
                return;
            }
            
//            let totalPayableAmount = Int((Helper.sharedInstance.order?.totalAmountPayable)!);
            let totalPayable = Int((Helper.sharedInstance.order?.totalAmount)!);

            let totalRedeemValue = floor((Double(self.redeemPoints)!*Helper.sharedInstance.redeemValue));
            if totalPayable >= Int(totalRedeemValue) {
//                Helper.sharedInstance.order?.totalAmountPayable = String(totalPayable! - Int(totalRedeemValue))
                self.redeemLabel.text = "You have 0 points to redeem"
                Helper.sharedInstance.order?.hasRedeemedPoints = true;
                let redeemPoi = self.redeemPoints
                Helper.sharedInstance.order?.pointsToRedeem = redeemPoi;
                self.redeemPoints = "0";
                Helper.sharedInstance.order?.discount = String(Int(Double(totalRedeemValue)));
                let messg = "Points redeemed: "+redeemPoi+" discount: ₹ "+String(totalRedeemValue)+" balance points: 0"
                UIAlertView(title: "First Eat", message: messg, delegate: nil, cancelButtonTitle: "OK").show()
                
                UIApplication.sharedApplication().sendAction("updateCartWithTotalAmountPayableWithDiscount:", to: nil, from: self, forEvent: nil)


            } else {
//                Helper.sharedInstance.order?.totalAmountPayable = "0"
                let balancePoints = ceil(Double(self.redeemPoints)! - ceil(Double(totalPayable!)/Helper.sharedInstance.redeemValue))
                Helper.sharedInstance.order?.pointsToRedeem = String(Int(self.redeemPoints)! - Int(balancePoints));
                self.redeemLabel.text = "You have "+String(balancePoints)+" points to redeem"
                Helper.sharedInstance.order?.hasRedeemedPoints = true;
                let discount = Int(Double((Helper.sharedInstance.order?.pointsToRedeem)!)!*Double(Helper.sharedInstance.redeemValue))
                let pointstoredeem: String = (Helper.sharedInstance.order?.pointsToRedeem)!
                Helper.sharedInstance.order?.discount = String(discount)

                let messg = "Points redeemed: "+pointstoredeem+" discount: ₹ "+String(discount)+" balance points: "+String(balancePoints)
                UIAlertView(title: "First Eat", message: messg, delegate: nil, cancelButtonTitle: "OK").show()
                
                UIApplication.sharedApplication().sendAction("updateCartWithTotalAmountPayableWithDiscount:", to: nil, from: self, forEvent: nil)


            }
           
        }
        
    }
    func fetchRedeemPoints() {
        Helper.sharedInstance.fetchUserRedeemPoints { (response) -> () in
            
            dispatch_async(dispatch_get_main_queue()) { () -> Void in

            let responseStatus = (response as? String) ?? ""
            if responseStatus == "ERROR"{

            } else {
                
                let responseStat = (response as? NSDictionary)
                let pointsDict = responseStat?.objectForKey("points") as? NSDictionary
                var points: AnyObject?
                if let pointsStr = pointsDict?.objectForKey("total_points") as? NSNumber {
                    points = String(pointsStr)
                } else {
                    points = pointsDict?.objectForKey("total_points") as? String
                }
                let userpoints = points ?? "0";
                self.redeemPoints = (userpoints as? String)!
                self.redeemLabel.text = "You have "+self.redeemPoints+" points to redeem"
            }
            self.activity?.stopAnimating()
        }

        }
    }
}