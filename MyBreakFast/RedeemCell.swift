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
        self.activity?.color = UIColor(red: 200.0/255.0, green: 5.0/255.0, blue: 15.0/255.0, alpha: 1.0)
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
        
            Helper.sharedInstance.redeemPoints(self.redeemPoints, completionHandler: { (response) -> () in
                
                dispatch_async(dispatch_get_main_queue()) { () -> Void in
                let responseStatus = (response as? String) ?? ""

                if responseStatus == "ERROR"{
                    
                } else {
                    let responseStat = (response as? NSDictionary)
                    var balancePoints: AnyObject?
                    var discount: AnyObject?
                    var message: AnyObject?
                    var pointsRedeemed: AnyObject?
                    if let balance = responseStat?.objectForKey("balance_points") as? NSNumber {
                         balancePoints = String(balance);
                    } else {
                        balancePoints = responseStat?.objectForKey("balance_points") as? String
                    }
                    
                    if let discountP = responseStat?.objectForKey("discount") as? NSNumber {
                        discount = String(discountP);
                    } else {
                        discount = responseStat?.objectForKey("discount") as? String
                    }
                    
                    message = responseStat?.objectForKey("msg") as? String
                    
                    if let balance = responseStat?.objectForKey("points_redeemed") as? NSNumber {
                        pointsRedeemed = String(balance);
                    } else {
                        pointsRedeemed = responseStat?.objectForKey("points_redeemed") as? String
                    }
                    let msg = "Redeem "+(message as? String)!
                    let messg = "Points redeemed: "+(pointsRedeemed as? String)!+" discount: "+(discount as? String)!+" balance: "+(balancePoints as? String)!
                    UIAlertView(title: msg, message: messg, delegate: nil, cancelButtonTitle: "OK").show()
                    
                    Helper.sharedInstance.order?.discount = discount as! String
                    
                    let disc = Int(discount as! String)
                    let amtPayable = Int((Helper.sharedInstance.order?.totalAmountPayable)!)
                    let totalAmtPay = amtPayable!-disc!

                    Helper.sharedInstance.order?.totalAmountPayable = String(totalAmtPay)
                    self.redeemLabel.text = "You have "+(balancePoints as! String)+" points to redeem"
                    UIApplication.sharedApplication().sendAction("updateCartWithTotalAmountPayableWithDiscount:", to: nil, from: self, forEvent: nil)
                    Helper.sharedInstance.order?.hasRedeemedPoints = true;
                }
            }
            })
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