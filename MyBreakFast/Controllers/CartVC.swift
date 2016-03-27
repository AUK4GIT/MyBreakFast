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
    let sectionHeaders: [String] = ["TOTAL AMOUNT", "REEDEM POINTS", "COUPON CODE", "PAYMENT METHOD", "BRING ME CHANGE OF"];
    var totalAmount: Int?
    
    override func beginAppearanceTransition(isAppearing: Bool, animated: Bool) {
        super.beginAppearanceTransition(isAppearing, animated: animated)
        if isAppearing {
            let fadeTextAnimation: CATransition = CATransition();
            fadeTextAnimation.duration = 0.5;
            fadeTextAnimation.type = kCATransitionFade;
            
            if let parentVC = self.parentViewController as? ViewController {
                parentVC.containerNavigationItem.leftBarButtonItem?.image = UIImage(named: "menu_icon.png");
                parentVC.containerNavigationItem.leftBarButtonItem?.image = UIImage(named: "back.png");
                parentVC.containerNavigationItem.leftBarButtonItem?.action = "backToMenu";
                parentVC.containerNavigationBar.layer.addAnimation(fadeTextAnimation, forKey: "fadeText");
                parentVC.setNavBarTitle("CHECKOUT")
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
    }
    
    func saveData() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func updateCartWithTotalAmountPayableWithDiscount(sender: AnyObject) {
        Helper.sharedInstance.getTotalPrice { (price) -> () in
            self.totalAmount = price
            self.payableAmountLabel.text = "Payable Amount ₹ "+String(self.totalAmount!);
        }
    }
    
    @IBAction func showOrderStatus(sender: AnyObject) {
        
        if let paymentMode = Helper.sharedInstance.order!.modeOfPayment {
            if paymentMode == paymentType.COD {
                Helper.sharedInstance.placeOrder { (response) -> () in
                    if response as? String == "ERROR" {
                        UIAlertView(title: "Error", message: "Please try again", delegate: nil, cancelButtonTitle: "OK").show()
                    } else {
                        
                        let resDict = response as! NSDictionary
                        if let orderId = resDict.objectForKey("order_id") as? NSNumber {
                            Helper.sharedInstance.order?.orderId = String(orderId);
                        } else {
                            Helper.sharedInstance.order?.orderId = resDict.objectForKey("order_id") as? String;
                        }
                        
                        self.updateOrderWithMenuIds()
                    }
                    
                }
            } else {
                        let storyboard: UIStoryboard = UIStoryboard(name: "Citrus_flow", bundle: nil);
                        let nvc: UIViewController = storyboard.instantiateInitialViewController()!
                        self.presentViewController(nvc, animated: true, completion: nil)
                
            }
        
        } else {
        
        }
        

    }

    func updateOrderWithMenuIds() {
        
        Helper.sharedInstance.sendMenuIdstoOrder { (response) -> () in
            
            if response as? String == "ERROR" {
                UIAlertView(title: "Error", message: "Please try again", delegate: nil, cancelButtonTitle: "OK").show()
            } else {
                self.updateOrderWithOfferIds()
            }

        }
    
    }
    
    
    func updateOrderWithOfferIds() {
        
        Helper.sharedInstance.sendOfferIdsToOrder { (response) -> () in
            
            if response as? String == "ERROR" {
                UIAlertView(title: "Error", message: "Please try again", delegate: nil, cancelButtonTitle: "OK").show()
            } else {
                self.updateOrderWithBill()
            }
        }
    }
    
    func updateOrderWithBill() {
        Helper.sharedInstance.updateOrderWithBillDetails { (response) -> () in
            
            if response as? String == "ERROR" {
                UIAlertView(title: "Error", message: "Please try again", delegate: nil, cancelButtonTitle: "OK").show()
            } else {
                
                Helper.sharedInstance.showActivity()
                if Helper.sharedInstance.order?.hasRedeemedPoints == true {
                    Helper.sharedInstance.redeemPoints((Helper.sharedInstance.order?.pointsToRedeem)!, completionHandler: { (responseS) -> () in
                        
                        dispatch_async(dispatch_get_main_queue()) { () -> Void in
                            let responseStatus = (responseS as? String) ?? ""
                            if responseStatus == "ERROR"{
                                UIAlertView(title: "Error redeeming points!", message: "Please try again", delegate: nil, cancelButtonTitle: "OK").show()
                            } else {
                            }
                            let parentVC = self.parentViewController as! ViewController
                            let statusVC = (self.storyboard?.instantiateViewControllerWithIdentifier("OrderStatusVC")) as! OrderStatusVC
                            parentVC.cycleFromViewController(nil, toViewController: statusVC)
                            statusVC.setData(response as! NSDictionary);
                            Helper.sharedInstance.hideActivity()
                            
                        }
                    })
                } else {
                    Helper.sharedInstance.hideActivity()
                    let parentVC = self.parentViewController as! ViewController
                    let statusVC = (self.storyboard?.instantiateViewControllerWithIdentifier("OrderStatusVC")) as! OrderStatusVC
                    parentVC.cycleFromViewController(nil, toViewController: statusVC)
                    statusVC.setData(response as! NSDictionary);

                }
            }

        }
    
    }
    
    // MARK: UICollectionView delegates and datasources
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let width: CGFloat = ((UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Phone) ? collectionView.bounds.size.width : 600.0);
        let height: CGFloat = (UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Phone) ? 75.0 : 100.0;
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
        return sectionHeaders.count;
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