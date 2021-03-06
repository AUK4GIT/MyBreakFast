//
//  CartVC.swift
//  MyBreakFast
//
//  Created by Uday Kiran Ailapaka on 31/10/15.
//  Copyright © 2015 AUK. All rights reserved.
//

import Foundation
import UIKit

class CartVC: UIViewController {
    
    @IBOutlet  var payableAmountLabel: UILabel!
    @IBOutlet var toolbar: UIToolbar!
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var collectionViewLayout: UICollectionViewFlowLayout!
    let sectionHeaders: [String] = ["TOTAL AMOUNT", "REEDEM POINTS", "COUPON CODE", "PAYMENT METHODS", "BRING ME CHANGE OF"];
    let sectionHeaderImages: [String] = ["total-bill-icon","redeem points","coupon code icon","payment method icon","noimage"];
    var totalAmount: Int?
    var response: AnyObject?
    var isFromSubscription = false;
    
    override func beginAppearanceTransition(isAppearing: Bool, animated: Bool) {
        super.beginAppearanceTransition(isAppearing, animated: animated)
        if isAppearing {
            let fadeTextAnimation: CATransition = CATransition();
            fadeTextAnimation.duration = 0.5;
            fadeTextAnimation.type = kCATransitionFade;
            
            if let parentVC = self.parentViewController as? ViewController {
                parentVC.containerNavigationItem.leftBarButtonItem?.image = UIImage(named: "menu_icon.png");
                parentVC.containerNavigationItem.leftBarButtonItem?.image = UIImage(named: "back.png");
                parentVC.containerNavigationItem.leftBarButtonItem?.action = #selector(ViewController.backToMenu);
                parentVC.containerNavigationBar.layer.addAnimation(fadeTextAnimation, forKey: "fadeText");
                parentVC.setNavBarTitle("CHECKOUT")
                parentVC.containerNavigationItem.rightBarButtonItem = nil;

            } else {
                self.view.backgroundColor = UIColor.whiteColor()
                self.toolbar.hidden = true;
            }
        }
    }
    override func endAppearanceTransition() {
        super.endAppearanceTransition()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(self.collectionViewLayout)
        self.collectionViewLayout.minimumLineSpacing = 5;
        self.collectionViewLayout.minimumInteritemSpacing = 5;
        self.collectionViewLayout.headerReferenceSize = CGSizeMake(self.collectionView.bounds.width, 35);
        self.collectionViewLayout.footerReferenceSize = CGSizeZero;
        
        self.collectionViewLayout.sectionInset = UIEdgeInsetsMake(0, 0, 10, 0)
        self.collectionView.collectionViewLayout = self.collectionViewLayout
        
        Helper.sharedInstance.getTotalPrice { (price) -> () in
            self.totalAmount = price
            self.payableAmountLabel.text = "Payable Amount ₹ "+String(self.totalAmount!);
            self.collectionView.reloadSections(NSIndexSet(index: 0))
        }
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(CartVC.PaymentFinished(_:)), name: "PaymentFinished", object: nil)
    }
    
    func didPickPaymentType() {
        self.collectionView.reloadData()
    }
    
    deinit{
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func PaymentFinished(infoDict: NSNotification){
        self.dismissViewControllerAnimated(true) { () -> Void in
            if infoDict.userInfo != nil {
                self.placeOrder({
                    self.verifyPayment(infoDict);
                })
            } else {
                Helper.sharedInstance.hideActivity()
                UIAlertView(title: "Error", message: "Please try again", delegate: nil, cancelButtonTitle: "OK").show()
            }
        }
    }
    
    func verifyPayment(txDict: NSNotification?){
        if let tsDictionary = txDict {
            Helper.sharedInstance.verifyPaymentForTransaction(tsDictionary.userInfo!) { (response) -> () in
                if response as? String == "ERROR" {
                    Helper.sharedInstance.hideActivity()
                    UIAlertView(title: "Error", message: "Please try again", delegate: nil, cancelButtonTitle: "OK").show()
                } else {
                    
                    if let status = response.objectForKey("status") {
                        if status as? String == "1" || status as? NSNumber == 1 {
                            
                            let parentVC = self.parentViewController as! ViewController
                            if self.isFromSubscription {
                                let statusVC = (self.storyboard?.instantiateViewControllerWithIdentifier("MealSummaryVC")) as! MealSummaryVC
                                parentVC.cycleFromViewController(nil, toViewController: statusVC)

                                statusVC.performSelector(#selector(MealSummaryVC.getContentForItemId), withObject: (Helper.sharedInstance.order?.orderId)!, afterDelay: 0.6)

                                statusVC.performSelector(#selector(MealSummaryVC.loadPlanNameandNutritionname), withObject: nil, afterDelay: 1.0)
                            } else {
                                let statusVC = (self.storyboard?.instantiateViewControllerWithIdentifier("OrderStatusVC")) as! OrderStatusVC
                                parentVC.cycleFromViewController(nil, toViewController: statusVC)
                                statusVC.setData(self.response as! NSDictionary);
                            }
                            
                        } else {
                            UIAlertView(title: "Error", message: "Please try again", delegate: nil, cancelButtonTitle: "OK").show()
                        }
                    }
                }
            }
        } else {
            Helper.sharedInstance.hideActivity()
            UIAlertView(title: "Error", message: "Please try again", delegate: nil, cancelButtonTitle: "OK").show()
        }
    }
    
    func saveData() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func updateCartWithTotalAmountPayableWithDiscount(sender: AnyObject) {
        Helper.sharedInstance.getTotalPrice { (price) -> () in
//            self.totalAmount = price
            self.payableAmountLabel.text = "Payable Amount ₹ "+String(price);
        }
    }
    
    @IBAction func showOrderStatus(sender: AnyObject) {
        
        if Helper.sharedInstance.order!.modeOfPayment == PaymentType.COD {
            self.placeOrder({ (response) in
                let parentVC = self.parentViewController as! ViewController
                if self.isFromSubscription {
                    let statusVC = (self.storyboard?.instantiateViewControllerWithIdentifier("MealSummaryVC")) as? MealSummaryVC
                    parentVC.cycleFromViewController(nil, toViewController: statusVC!)

                    statusVC!.performSelector(#selector(MealSummaryVC.getContentForItemId), withObject: (Helper.sharedInstance.order?.orderId)!, afterDelay: 0.6)
                    
                    statusVC!.performSelector(#selector(MealSummaryVC.loadPlanNameandNutritionname), withObject: nil, afterDelay: 1.0)
//                    statusVC.setData(self.response as! NSDictionary);

                }else{
                let statusVC = (self.storyboard?.instantiateViewControllerWithIdentifier("OrderStatusVC")) as! OrderStatusVC
                parentVC.cycleFromViewController(nil, toViewController: statusVC)
                statusVC.setData(self.response as! NSDictionary);
                }
            })
        } else if Helper.sharedInstance.order!.modeOfPayment == PaymentType.PAYTM{
            
             let storyboard: UIStoryboard = UIStoryboard(name: "PayTM_flow", bundle: nil);
             let nvc: UIViewController = storyboard.instantiateInitialViewController()!
             self.presentViewController(nvc, animated: true, completion: nil)
            
        } else if Helper.sharedInstance.order!.modeOfPayment == PaymentType.CITRUS {
            let storyboard: UIStoryboard = UIStoryboard(name: "Citrus_flow", bundle: nil);
            let nvc: UIViewController = storyboard.instantiateInitialViewController()!
            self.presentViewController(nvc, animated: true, completion: nil)
        } else if Helper.sharedInstance.order!.modeOfPayment == PaymentType.CARDS || Helper.sharedInstance.order!.modeOfPayment == PaymentType.NB {
            let storyboard: UIStoryboard = UIStoryboard(name: "Citrus_flow", bundle: nil);
            let vc: UIViewController = storyboard.instantiateViewControllerWithIdentifier("CardsViewController")
            vc.setValue(Helper.sharedInstance.order?.totalAmountPayable, forKey: "amount")
            vc.setValue(1, forKey: "landingScreen")

            let nvc: UINavigationController = UINavigationController(rootViewController: vc)
            self.presentViewController(nvc, animated: true, completion: nil)

        } else {
            UIAlertView(title: "First eat", message: "Please select a mode of payment", delegate: nil, cancelButtonTitle: "OK").show()
        }
        
    }
    
    func placeOrder(completionHandler: () -> ()){
    
        let paymentStr = (Helper.sharedInstance.order!.modeOfPayment == PaymentType.COD) ? "COD" : "Online"
        Helper.sharedInstance.showActivity()
        
        if let _ = Helper.sharedInstance.subscription {
            
            Helper.sharedInstance.placeSubscriptionOrder (paymentStr, completionHandler: { (response) -> () in
                if response as? String == "ERROR" {
                    Helper.sharedInstance.hideActivity()
                    UIAlertView(title: "Error", message: "Please try again", delegate: nil, cancelButtonTitle: "OK").show()
                } else {
                    Helper.sharedInstance.hideActivity()
                    if let orderResDict = response.objectForKey("new_order_response") {
                        let orderResDataDict = orderResDict.objectForKey("data");
                        if orderResDict.objectForKey("status") as? NSNumber == 0 || orderResDict.objectForKey("status") as? String == "0"{
                            
                            if let orderResDataDetails = orderResDataDict as? NSDictionary{
                                    if let orderId = orderResDataDetails.objectForKey("order_id") as? NSNumber {
                                        Helper.sharedInstance.order?.orderId = String(orderId);
                                    } else {
                                        Helper.sharedInstance.order?.orderId = orderResDataDetails.objectForKey("order_id") as? String;
                                    }
                                self.response = response.objectForKey("update_order_response");
                                completionHandler();
                            } else {
                                UIAlertView(title: "Error", message: "Please try again", delegate: nil, cancelButtonTitle: "OK").show()
                                return;
                            }
                        }
                    }
                }
            })
            
        } else {
        Helper.sharedInstance.placeOrder (paymentStr, completionHandler: { (response) -> () in
            if response as? String == "ERROR" {
                Helper.sharedInstance.hideActivity()
                UIAlertView(title: "Error", message: "Please try again", delegate: nil, cancelButtonTitle: "OK").show()
            } else {
                Helper.sharedInstance.hideActivity()
                if let orderResDict = response.objectForKey("update_order_response") {
                    let orderResDataDict = orderResDict.objectForKey("data");
                    if orderResDict.objectForKey("status") as? NSNumber == 0 || orderResDict.objectForKey("status") as? String == "0"{
                        if let orderResDataDetails = orderResDataDict!.objectForKey("details") as? NSArray{
                            if orderResDataDetails.count>0 {
                                let dict = orderResDataDetails[0]
                                if let orderId = dict.objectForKey("order_id") as? NSNumber {
                                    Helper.sharedInstance.order?.orderId = String(orderId);
                                } else {
                                    Helper.sharedInstance.order?.orderId = dict.objectForKey("order_id") as? String;
                                }
                            } else {
                                UIAlertView(title: "Error", message: "Please try again", delegate: nil, cancelButtonTitle: "OK").show()
                                return;
                            }
                            self.response = response.objectForKey("update_order_response");
                            completionHandler();
                        }
                    }
                }
            }
        })
    }

    }
    
    // MARK: UICollectionView delegates and datasources
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let width: CGFloat = ((UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Phone) ? collectionView.bounds.size.width : 600.0);
        var height: CGFloat = (UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Phone) ? 75.0 : 100.0;
        height = indexPath.section == 3 ? 200.0: height;
        print("indexPath.row: %@ --> %@",indexPath.section, height);
        return CGSizeMake(width, height);
    }
    
    func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath)   {
        let bgView = cell.viewWithTag(11);
        bgView?.alpha = 0;
        bgView?.transform = CGAffineTransformMakeScale(0.95, 0.95)
        
        UIView.animateWithDuration(0.6, delay: 0.3, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
            bgView?.alpha = 1.0;
            bgView?.transform = CGAffineTransformIdentity
            }, completion: nil)
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        if Helper.sharedInstance.order!.modeOfPayment == PaymentType.COD
        {
            return sectionHeaders.count;

        } else {
            return sectionHeaders.count-1;
        }
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1;
    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        
        let reusableview: UICollectionReusableView?;
        
        if kind == UICollectionElementKindSectionHeader {
            reusableview = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier: "CartHeaderView", forIndexPath: indexPath)
            let label: UILabel = reusableview?.viewWithTag(5) as! UILabel
            label.text = sectionHeaders[indexPath.section];
            
            let imgView: UIImageView = reusableview?.viewWithTag(6) as! UIImageView
            imgView.image = UIImage(named: sectionHeaderImages[indexPath.section]);

            return reusableview!;
        } else {
            reusableview = nil;
        }
        return reusableview!;
        
    }
    
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell: UICollectionViewCell?
        
        switch indexPath.section {
        case 0 :
            cell = collectionView.dequeueReusableCellWithReuseIdentifier("totalbill", forIndexPath: indexPath) as! TotalBill
            if let totalPrice = self.totalAmount {
                (cell as! TotalBill).billLabel.text = "₹ "+String(totalPrice)
            }
            
            break;
        case 1 :
            
            cell = collectionView.dequeueReusableCellWithReuseIdentifier("redeempoints", forIndexPath: indexPath)
            
            
            break;
        case 2 :
            cell = collectionView.dequeueReusableCellWithReuseIdentifier("couponcode", forIndexPath: indexPath)
            
            
            break;
        case 3 :
            
            cell = collectionView.dequeueReusableCellWithReuseIdentifier("paymentmethod", forIndexPath: indexPath)
            
            break;
        case 4 :
            
            cell = collectionView.dequeueReusableCellWithReuseIdentifier("change", forIndexPath: indexPath)

            break;
        default:
            cell = collectionView.dequeueReusableCellWithReuseIdentifier("change", forIndexPath: indexPath)
            
            break;
        }
        
        return cell!;
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.collectionViewLayout.invalidateLayout()
    }
    
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}