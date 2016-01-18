//
//  UserOrderDetails.swift
//  MyBreakFast
//
//  Created by Uday Kiran Ailapaka on 22/11/15.
//  Copyright © 2015 AUK. All rights reserved.
//

import Foundation
import UIKit

class UserOrderDetails: UIViewController {
    
    @IBOutlet weak var totalBillLabel: UIBarButtonItem!
    @IBOutlet var toolbar: UIToolbar!
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var collectionViewLayout: UICollectionViewFlowLayout!
    let sectionHeaders: [String] = ["DELIVERY ADDRESS", "TIME", "DELIVERY PRODUCTS"];
    var itemsArray : [AnyObject] = [];
    var offeroftheday: Offer?

    @IBOutlet weak var offerofthedayView: UIView!
    @IBOutlet weak var todaysOfferButton: UIButton!
    @IBOutlet weak var todaysOfferAmountLabel: UILabel!
    @IBOutlet weak var todaysOfferLabel: UILabel!

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if let addrID = Helper.sharedInstance.getDataFromUserDefaults(forKey: Constants.UserdefaultConstants.LastSelectedAddressId) as? String {
            Helper.sharedInstance.order?.addressId = addrID
            if let userAddr = Helper.sharedInstance.fetchLastUserAddressesForId(addrID) {
                let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(1 * Double(NSEC_PER_SEC)))
                dispatch_after(delayTime, dispatch_get_main_queue()) {
                    let collectionCell = self.collectionView.cellForItemAtIndexPath(NSIndexPath(forItem: 0, inSection: 0)) as? Yourdetails
                    collectionCell?.secondLine.text = userAddr.linetwo
                    collectionCell?.firstLine.text = userAddr.lineone
                }
            }
        } else {
            let userLoginStatus = Helper.sharedInstance.getDataFromUserDefaults(forKey: Constants.UserdefaultConstants.UserLoginStatus) as? Bool
             if userLoginStatus != nil {
                self.showAddAddressVC();
            }
        }
    }
    
    override func beginAppearanceTransition(isAppearing: Bool, animated: Bool) {
        super.beginAppearanceTransition(isAppearing, animated: animated)
        if isAppearing {
            let fadeTextAnimation: CATransition = CATransition();
            fadeTextAnimation.duration = 0.5;
            fadeTextAnimation.type = kCATransitionFade;
            
            if let parentVC = self.parentViewController as? ViewController {
//                parentVC.containerNavigationItem.leftBarButtonItem?.image = UIImage(named: "menu_icon.png");
                parentVC.containerNavigationItem.leftBarButtonItem?.image = UIImage(named: "back.png");
                parentVC.containerNavigationItem.leftBarButtonItem?.action = "backToMenu";
                parentVC.containerNavigationBar.layer.addAnimation(fadeTextAnimation, forKey: "fadeText");
                parentVC.setNavBarTitle("CART")
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

        self.collectionViewLayout.sectionInset = UIEdgeInsetsMake(0, 0, 30, 0)
        self.collectionView.collectionViewLayout = self.collectionViewLayout
        
        self.itemsArray = Helper.sharedInstance.getOrderItems()
        
        self.updateCartToolbar()
        
        self.offeroftheday = Helper.sharedInstance.getOfferoftheDay()
        self.todaysOfferButton.layer.borderColor = UIColor.whiteColor().CGColor
        self.todaysOfferButton.layer.borderWidth = 1;

        if self.offeroftheday != nil {
            self.offerofthedayView.hidden = false;
            self.todaysOfferLabel.text = "Today's best offer ("+(self.offeroftheday?.offername)!+")"
            self.todaysOfferAmountLabel.text = "₹ "+(self.offeroftheday?.price!)!+"/-"
        } else {
            self.offerofthedayView.hidden = true;
        }
        }
    @IBAction func toggleOfferOftheDay(sender: UIButton) {
        if sender.selected {
            sender.selected = false;
            let index = Helper.sharedInstance.order?.offers.indexOf(self.offeroftheday!)
            Helper.sharedInstance.order?.offers.removeAtIndex(index!)

        } else {
            sender.selected = true;
            Helper.sharedInstance.order?.offers.append(self.offeroftheday!)

        }
        self.updateCartToolbar()
    }
    
    func saveData() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func moveToNextScreen(sender: AnyObject) {
        
        if Helper.sharedInstance.order?.timeSlotId == nil {
            UIAlertView(title: "First Eat", message: "Please select a timeslot", delegate: nil, cancelButtonTitle: "OK").show()
            return;
        }
        
        let parentVC = self.parentViewController as! ViewController
        parentVC.cycleFromViewController(nil, toViewController: (self.storyboard?.instantiateViewControllerWithIdentifier("CartVC"))!)
    }
    
    func changeAddress(){
    
    }
    
    func updateCartToolbar(){
        Helper.sharedInstance.getOrderCountandPrice { (count, price) -> () in
            self.totalBillLabel.title = "Total Amount ₹ "+String(price)+" /-"
        }
    }
    
    // MARK: UICollectionView delegates and datasources
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let width: CGFloat = ((UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Phone) ? collectionView.bounds.size.width : 600.0);
        var height: CGFloat = (UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Phone) ? 75.0 : 100.0;
        height = indexPath.section == 2 ? 120.0: height;
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
        return 3;
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return section==2 ? self.itemsArray.count : 1;
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
             cell = collectionView.dequeueReusableCellWithReuseIdentifier("yourdetails", forIndexPath: indexPath)
//             let bgView: UIView = (cell?.viewWithTag(6))!;
//             bgView.layer.shadowOpacity = 0.8;
//             bgView.layer.shadowColor = UIColor.grayColor().CGColor;
//             bgView.layer.shadowOffset = CGSizeMake(1, 1);
            break;
        case 1 :
            
            cell = collectionView.dequeueReusableCellWithReuseIdentifier("deliverytime", forIndexPath: indexPath)
//            let bgView: UIView = (cell?.viewWithTag(6))!;
//            bgView.layer.shadowOpacity = 0.8;
//            bgView.layer.shadowColor = UIColor.grayColor().CGColor;
//            bgView.layer.shadowOffset = CGSizeMake(1, 1);

            break;
        case 2 :
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("productscell", forIndexPath: indexPath) as! ProductsCell
//            let bgView: UIView = (cell.viewWithTag(6))!;
//            bgView.layer.shadowOpacity = 0.8;
//            bgView.layer.shadowColor = UIColor.grayColor().CGColor;
//            bgView.layer.shadowOffset = CGSizeMake(1, 1);
            
            let item : Item = self.itemsArray[indexPath.item] as! Item
            cell.item = item;
            cell.orderItem = Helper.sharedInstance.order?.orders[indexPath.row]
            cell.setItemContent();
            return cell;
        /*case 3 :
             cell = collectionView.dequeueReusableCellWithReuseIdentifier("deliveryaddress", forIndexPath: indexPath)

            break;
        case 4 :
            cell = collectionView.dequeueReusableCellWithReuseIdentifier("deliverylocation", forIndexPath: indexPath)

            break;*/
        default:
            cell = collectionView.dequeueReusableCellWithReuseIdentifier("yourdetails", forIndexPath: indexPath)

            break;
        }
        
        return cell!;
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.collectionViewLayout.invalidateLayout()
    }

    func showAddAddressVC(){
//        AddAddressVC
        self.presentViewController((self.storyboard?.instantiateViewControllerWithIdentifier("AddAddressNVC"))!, animated: true) { () -> Void in
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
}