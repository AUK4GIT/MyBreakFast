//
//  MySubscriptions.swift
//  MyBreakFast
//
//  Created by AUK on 30/06/16.
//  Copyright © 2016 AUK. All rights reserved.
//

import Foundation

class MySubscriptions: UIViewController {
    @IBOutlet var tableView: UITableView!
    let dateFormatter = NSDateFormatter()
    let dayFormatter = NSDateFormatter()
    let timeFormatter = NSDateFormatter()
    var addressess: NSArray?
    var contentArray : NSArray = []
    var check : Int = 0;
    
    var dieticiansList : [Dietician] = [];
    var mealPlansList: NSArray = [];
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.registerNib(UINib(nibName: "MySubscriptionCell", bundle: nil), forCellReuseIdentifier: "MySubscriptionCell")
        self.tableView.rowHeight = 100.0;
        self.dateFormatter.dateFormat = "yyyy-MM-dd"
        self.dayFormatter.dateFormat = "EEE MMM dd,  yyyy"
        self.timeFormatter.dateFormat = "hh:mm a"
        self.timeFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        
        //        self.addressess = Helper.sharedInstance.getUserAddresses()
        self.tableView.contentInset = UIEdgeInsetsMake(20, 0, 0, 0)
        
    }

    override func beginAppearanceTransition(isAppearing: Bool, animated: Bool) {
        super.beginAppearanceTransition(isAppearing, animated: animated)
        if isAppearing {
            let fadeTextAnimation: CATransition = CATransition();
            fadeTextAnimation.duration = 0.5;
            fadeTextAnimation.type = kCATransitionFade;
            
            let parentVC: ViewController = self.parentViewController as! ViewController
            parentVC.setNavBarTitle("My Subscriptions")
            parentVC.containerNavigationBar.layer.addAnimation(fadeTextAnimation, forKey: "fadeText");
        }
    }
    override func endAppearanceTransition() {
        super.endAppearanceTransition()
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        let userLoginStatus = Helper.sharedInstance.getDataFromUserDefaults(forKey: Constants.UserdefaultConstants.UserLoginStatus) as? Bool
        let userRegistrationStatus = Helper.sharedInstance.getDataFromUserDefaults(forKey: Constants.UserdefaultConstants.UserRegistration) as? Bool
        
        if userLoginStatus == nil {
            let vc: AppSignInVC = (self.storyboard?.instantiateViewControllerWithIdentifier("AppSignInVC")) as! AppSignInVC
            self.presentViewController(vc, animated: true, completion: nil)
            vc.completionHandler = {dict in
                print(dict);
                vc.dismissViewControllerAnimated(true, completion: { () -> Void in
                    //                    if let obj = dict.object
                })
            };
        } else if userRegistrationStatus == nil {
            
            let vc: AppSignInVC = (self.storyboard?.instantiateViewControllerWithIdentifier("AppSignInVC")) as! AppSignInVC
            self.presentViewController(vc, animated: true, completion: nil)
            vc.completionHandler = {dict in
                print(dict);
                vc.dismissViewControllerAnimated(true, completion: { () -> Void in
                    //                    if let obj = dict.object
                })
            };
            
        } else {
            
            if check > 0{return; } else{ check += 1;}
            self.getAllDieticiansandMealPlans()
        }
        
    }
    
    func getAllDieticiansandMealPlans(){
    
        Helper.sharedInstance.getSubscriptionRegularPlan { (response) in
            if let json = response as? NSDictionary {
                Helper.sharedInstance.subscription = Subscription()
                Helper.sharedInstance.order = Order()
                Helper.sharedInstance.subscription?.saveData(json)
                self.dieticiansList = (Helper.sharedInstance.subscription?.dieticians)!
                self.mealPlansList = (Helper.sharedInstance.subscription?.regplans)!
            }
            self.getMySubscriptions();

        }
    }
    
    func getMySubscriptions(){
        Helper.sharedInstance.getMySubscriptions() { (response) -> () in
            
            if let responseObj = response as? NSDictionary {
                //                    self.addressess = responseObj.objectForKey("addresses") as? NSArray;
                let contentArr = responseObj.objectForKey("data") as? NSArray
                if contentArr != nil {
                    self.contentArray = contentArr!
                    let dateFormatter = NSDateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                    dateFormatter.locale = NSLocale(localeIdentifier: "en_US")
                    self.contentArray = self.contentArray.sortedArrayUsingComparator({ (dict1, dict2) -> NSComparisonResult in
                        print(dict1["ordered_at"], dict2["ordered_at"]);
                        let date1 = dateFormatter.dateFromString((dict1["ordered_at"] as? String)!)
                        let date2 = dateFormatter.dateFromString((dict2["ordered_at"] as? String)!)
                        
                        return (date2?.compare(date1!))!
                    })
                    self.tableView.reloadData()
                } else {
                    UIAlertView(title: "First Eat", message: "No Orders Found", delegate: nil, cancelButtonTitle: "OK").show()
                }
                
            } else {
                UIAlertView(title: "First Eat", message: "No Orders Found", delegate: nil, cancelButtonTitle: "OK").show()
            }
            
        }
    }
    
    // MARK: Tableview delegates & datasources
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let nvc: UINavigationController = self.storyboard?.instantiateViewControllerWithIdentifier("MealSummaryNVC") as! UINavigationController
        
        self.presentViewController(nvc, animated: true) { () -> Void in
            
            let vc: MealSummaryVC = nvc.topViewController as! MealSummaryVC
            
            let orderDict = self.contentArray[indexPath.row] as? NSDictionary
            if let orderId = orderDict?.objectForKey("id") as? NSNumber {
                vc.getContentForItemId(orderId.stringValue)
            } else {
                vc.getContentForItemId(orderDict?.objectForKey("id") as! String)
            }
            
            for regPlans in (self.mealPlansList as! [RegularPlan]) {
                if let mealPlans = regPlans.mealPlans as [MealPlan]? {
                    if let mealId = orderDict?.objectForKey("meal_plan_id") as? String {
                        let mealObj = mealPlans.filter{ $0.planId == mealId }.first
                        if mealObj != nil {
                        vc.planName.text = (mealObj?.name)!
                        if let dietId = mealObj?.dieticianId {
                            let dietObject = self.dieticiansList.filter{ $0.dieticianId == dietId }.first
                            vc.nutritionistName.text = (dietObject?.firstName ?? "---")
                            return;
                        }
                        }
                    } else {
                        let mealId = orderDict?.objectForKey("meal_plan_id") as? NSNumber
                        let mealObj = mealPlans.filter{ $0.planId == mealId?.stringValue }.first
                        if mealObj != nil {
                        vc.planName.text = (mealObj?.name)!
                        if let dietId = mealObj?.dieticianId {
                            let dietObject = self.dieticiansList.filter{ $0.dieticianId == dietId }.first
                            vc.nutritionistName.text = (dietObject?.firstName ?? "---")
                            return;
                        }
                    }
                    }
                }
            }
            
        }
   
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.contentArray.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell: MySubscriptionCell = tableView.dequeueReusableCellWithIdentifier("MySubscriptionCell")! as! MySubscriptionCell
        cell.backgroundColor = UIColor.clearColor()
        
        let orderDict = self.contentArray[indexPath.row] as? NSDictionary       
        if let orderId = orderDict?.objectForKey("id") as? NSNumber {
            cell.orderId.text = "Subscription ID: "+orderId.stringValue
        } else {
            cell.orderId.text = "Subscription ID: "+((orderDict?.objectForKey("id"))! as! String)
        }
        let date = dateFormatter.dateFromString((orderDict!.objectForKey("start_date") as? String)!)
        cell.dateLabel.text = "Start Date: "+self.dayFormatter.stringFromDate(date!)
        cell.timeLabel.text = "Duration: "+((orderDict!.objectForKey("weeks") as? String)!)+" Week(s)"
        cell.totalLabel.text = "₹ \(orderDict?.objectForKey("total_amount"))"
        if let totalAmt = orderDict?.objectForKey("total_amount") as? NSNumber {
            cell.totalLabel.text = "₹ \(totalAmt.stringValue)"
        } else {
            cell.totalLabel.text = "₹ \(orderDict?.objectForKey("total_amount") as! String)"
        }
        cell.addressLabel.text = "----";
        cell.deliveryStatus.text = "By Nutritionist: "

            for regPlans in (self.mealPlansList as? [RegularPlan])! {
            if let mealPlans = regPlans.mealPlans as [MealPlan]? {
                if let mealId = orderDict?.objectForKey("meal_plan_id") as? String {
                    let mealObj = mealPlans.filter{ $0.planId == mealId }.first
                    if mealObj != nil {
                    print(mealObj, mealId);
                    cell.addressLabel.text = "Diet Plan: "+(mealObj?.name)!
                    if let dietId = mealObj?.dieticianId {
                        let dietObject = self.dieticiansList.filter{ $0.dieticianId == dietId }.first
                        cell.deliveryStatus.text = "By Nutritionist: "+(dietObject?.firstName ?? "---")
                        break;
                    }
                }
                } else {
                    let mealId = orderDict?.objectForKey("meal_plan_id") as? NSNumber
                    let mealObj = mealPlans.filter{ $0.planId == mealId?.stringValue }.first
                    cell.addressLabel.text = "Diet Plan: "+(mealObj?.name)!
                    if let dietId = mealObj?.dieticianId {
                        let dietObject = self.dieticiansList.filter{ $0.dieticianId == dietId }.first
                        cell.deliveryStatus.text = "By Nutritionist: "+(dietObject?.firstName ?? "---")
                        break;
                    }
                }
                }
            }

        return cell
    }

   
}