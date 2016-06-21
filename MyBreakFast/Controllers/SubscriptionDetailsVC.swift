//
//  SubscriptionDetailsVC.swift
//  MyBreakFast
//
//  Created by AUK on 12/06/16.
//  Copyright © 2016 AUK. All rights reserved.
//

import Foundation

class SubscriptionDetailsVC: UIViewController {
    @IBOutlet var calendarCollectionView: UICollectionView!
    var calendarModelSource = CalendarModelDataSource();
    
    @IBOutlet var mealPlanLabel: UILabel!
    @IBOutlet var addressLabelForMeal: UILabel!
    @IBOutlet var sunButton: UIButton!
    @IBOutlet var satButton: UIButton!
    
    var planDetails: PlanDetails?
    var planSlots: [MealSlot]?
    var mealPlans: [PlannedMeals]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.calendarCollectionView.delegate = self.calendarModelSource
        self.calendarCollectionView.dataSource = self.calendarModelSource
        Helper.sharedInstance.getSubscriptionMealsForaPlan((Helper.sharedInstance.subscription?.selectedPlanId)!) { (response) in
            if let dict = response as? NSDictionary {
                Helper.sharedInstance.subscription?.saveSubscrDetails(dict.objectForKey("data") as! NSDictionary)
                
                self.planDetails = Helper.sharedInstance.subscription?.planDetails
                self.planSlots = Helper.sharedInstance.subscription?.planSlots
                self.mealPlans = Helper.sharedInstance.subscription?.mealPlans
                
                if self.planDetails?.sat == "0" {
                    self.satButton.enabled = false;
                }
                if self.planDetails?.sun == "0" {
                    self.sunButton.enabled = false;
                }
                
                if let addrID = Helper.sharedInstance.getDataFromUserDefaults(forKey: Constants.UserdefaultConstants.LastSelectedAddressId) as? String {
                    Helper.sharedInstance.order?.addressId = addrID
                    if let userAddr = Helper.sharedInstance.fetchLastUserAddressesForId(addrID) {
                        print(userAddr.lineone, userAddr.linetwo)
                    }
                } else {
                    let userLoginStatus = Helper.sharedInstance.getDataFromUserDefaults(forKey: Constants.UserdefaultConstants.UserLoginStatus) as? Bool
                    if userLoginStatus != nil {
                        self.showAddAddressVC();
                    }
                }
                
                
            }
        }
    }
    
    func showAddAddressVC(){
        //        AddAddressVC
        self.presentViewController((self.storyboard?.instantiateViewControllerWithIdentifier("AddAddressNVC"))!, animated: true) { () -> Void in
        }
    }
    
    @IBAction func changeUserAddress(sender: AnyObject) {
    }
    
    @IBAction func checkOut(sender: AnyObject) {
    }
}

class CalendarModelDataSource: NSObject, UICollectionViewDataSource, UICollectionViewDelegate {
    
    // MARK: UICollectionView delegates and datasources
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let width: CGFloat = 60.0
        let height: CGFloat = collectionView.bounds.size.height
        
        return CGSizeMake(width, height);
    }
    
    func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath)   {
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1;
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 7;
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("calendarcell", forIndexPath: indexPath)
        return cell;
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
    }
}