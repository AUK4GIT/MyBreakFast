//
//  MealSummaryVC.swift
//  MyBreakFast
//
//  Created by AUK on 01/07/16.
//  Copyright © 2016 AUK. All rights reserved.
//

import Foundation

class MealSummaryVC: UIViewController {
    
    @IBOutlet var planName: UILabel!
    @IBOutlet var timeSlot2: UILabel!
    @IBOutlet var timeSlot3: UILabel!
    @IBOutlet var addr1: UILabel!
    @IBOutlet var addr2: UILabel!
    @IBOutlet var addr3: UILabel!
    @IBOutlet var timeSlot1: UILabel!
    @IBOutlet var subscriptionId: UILabel!
    @IBOutlet var numberOfWeeks: UILabel!
    @IBOutlet var startDate: UILabel!
    @IBOutlet var nutritionistName: UILabel!
    
//    var addressArray: [AnyObject]?
//    var timeSlotsArray: [AnyObject]?
    var weeksArray: [NSDate] = []
    var mealsArray: [AnyObject]?
    let dateForm = NSDateFormatter();
    var satSelected: Bool = false;
    var sunSelected: Bool = false;
    var wmDateFormatter = NSDateFormatter();

    @IBOutlet var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.addressArray = []
//        self.timeSlotsArray = []
        self.mealsArray = []
        self.weeksArray = [];
        self.dateForm.dateFormat = "yyyy-MM-dd"
        self.wmDateFormatter.dateFormat = "EEE dd MMM";
        let doneButton: UIButton = UIButton(type: .Custom)
        doneButton.frame = CGRectMake(0, 0, 60, 44)
        doneButton.setTitle("Done", forState: .Normal)
        doneButton.titleLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 17.0);
        doneButton.titleLabel?.adjustFontToRealIPhoneSize = true;
        doneButton.addTarget(self, action: #selector(MyOrderDetailsVC.dismissViewController), forControlEvents: .TouchUpInside)
        doneButton.titleEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0)
        
        self.navigationItem.title = "My Subscription";
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: doneButton)
        
//        self.collectionView.registerClass(SummaryCell.self, forCellWithReuseIdentifier: "SummaryCell")
        
        self.collectionView.registerNib(UINib.init(nibName: "SummaryCell", bundle: nil), forCellWithReuseIdentifier: "SummaryCell")


    }
    
    func dismissViewController(){
        self.dismissViewControllerAnimated(true, completion: nil);
    }
    
    //MARK : UICollectionView Delegates
    
    // MARK: UICollectionView delegates and datasources
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        if indexPath.row%4 == 0 {
            return CGSizeMake(54, 50);
        }
        let twidth = (collectionView.bounds.width)/4
        return CGSizeMake(twidth+((twidth - 54)/3), 50);
    }
    
    func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath)   {
        let bgView = cell.contentView.viewWithTag(11);
        bgView?.alpha = 0;
        bgView?.transform = CGAffineTransformMakeScale(0.85, 0.85)
        
        UIView.animateWithDuration(0.6, delay: 0.3, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
            bgView?.alpha = 1.0;
            bgView?.transform = CGAffineTransformIdentity
            }, completion: nil)
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1;
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = ((self.mealsArray?.count) > 0) ? (self.weeksArray.count * 3)+self.weeksArray.count : 0;
        return count;
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell: SummaryCell = (collectionView.dequeueReusableCellWithReuseIdentifier("SummaryCell", forIndexPath: indexPath) as? SummaryCell)!
print(indexPath.row, self.weeksArray.count)
        if indexPath.row%4 == 0 {
            cell.mealLabel.text = "Mon"
//            cell.backgroundColor = UIColor(red: 240.0/255.0, green: 240.0/255.0, blue: 240.0/255.0, alpha: 1.0)
            cell.backgroundColor = UIColor.clearColor()

            cell.mealLabel.textColor = UIColor(red: 193/255.0, green: 207/255.0, blue: 89/255.0, alpha: 1.0)
            let index = Int(indexPath.row/4)
            if index >= self.weeksArray.count {
                cell.mealLabel.text = "---"
            } else {
            let week = self.weeksArray[index];
                cell.mealLabel.text = self.wmDateFormatter.stringFromDate((week ))
            }

        } else {
            cell.backgroundColor = UIColor.clearColor()
            cell.mealLabel.textColor = UIColor.darkGrayColor()
            let index = indexPath.row;
            let i = 3*(index/4)+(index%4)-1
            print(i)
            let meal = self.mealsArray![i] as? PlannedMeals;
            if let name =  meal!.name{
                cell.mealLabel.text = name
            } else {
                cell.mealLabel.text = "-----"
            }
        }
        return cell;
    }
    
    //Mark :
    
func getContentForItemId(itemId: String){
    
    Helper.sharedInstance.getSubscriptionOrderDetails(itemId) { (response) -> Void in
        let responseStatus = (response as? String) ?? ""
        if responseStatus == "ERROR" {
            UIAlertView(title: "Error!", message: "Please try again.", delegate: nil, cancelButtonTitle: "OK").show()
            
        } else {
            let responseS = (response as? NSDictionary)
            let responsestatus = responseS?.objectForKey("data")
            
            let address1 = responsestatus?.objectForKey("address1")
            let address2 = responsestatus?.objectForKey("address2")
            let address3 = responsestatus?.objectForKey("address3")
//            self.addressArray = [address1!, address2!, address3!];
            if let str = address1 as? NSDictionary {
                self.addr1.text = str.objectForKey("address_line_one") as? String
            }
            if let str = address2 as? NSDictionary {
                self.addr2.text = str.objectForKey("address_line_one") as? String;
            }
            if let str = address3 as? NSDictionary {
                self.addr3.text = str.objectForKey("address_line_one") as? String;
            }

            let slot1 = responsestatus?.objectForKey("slot1")
            let slot2 = responsestatus?.objectForKey("slot2")
            let slot3 = responsestatus?.objectForKey("slot3")
//            self.timeSlotsArray = [slot1!, slot2!, slot3!];
            
            self.timeSlot1.text = (((slot1!.objectForKey("start_time"))! as! NSString).substringToIndex(5))+" - "+(((slot1!.objectForKey("end_time"))! as! NSString).substringToIndex(5))
            
            self.timeSlot2.text = (((slot2!.objectForKey("start_time"))! as! NSString).substringToIndex(5))+" - "+(((slot2!.objectForKey("end_time"))! as! NSString).substringToIndex(5))

            
            self.timeSlot3.text = (((slot3!.objectForKey("start_time"))! as! NSString).substringToIndex(5))+" - "+(((slot3!.objectForKey("end_time"))! as! NSString).substringToIndex(5))


            let order = responsestatus?.objectForKey("order")
            let startDate = order?.objectForKey("start_date")
            let satIncluded = order!.objectForKey("sat_inc")
            let sunIncluded = order!.objectForKey("sun_inc")

            if let satSel = satIncluded as? NSNumber{
                if satSel == 1{
                    self.satSelected = true;
                } else {
                    self.satSelected = false;
                }
            } else {
                let satSel = satIncluded as? String
                if satSel == "1"{
                    self.satSelected = true;
                } else {
                    self.satSelected = false;
                }
            }
            
            if let sunSel = sunIncluded as? NSNumber{
                if sunSel == 1{
                    self.sunSelected = true;
                } else {
                    self.sunSelected = false;
                }
            } else {
                let sunSel = sunIncluded as? String
                if sunSel == "1"{
                    self.sunSelected = true;
                } else {
                    self.sunSelected = false;
                }
            }
            
            self.startDate.text = startDate as? String
            self.calculateWeekDaysFrom(self.dateForm.dateFromString(startDate as! String));
            if let week = order?.objectForKey("week") as? NSNumber{
                self.numberOfWeeks.text = week.stringValue
            } else {
                self.numberOfWeeks.text = order?.objectForKey("weeks") as? String
            }

            if let subscriptionId = order?.objectForKey("id") as? NSNumber{
                self.subscriptionId.text = subscriptionId.stringValue
            } else {
                self.subscriptionId.text = order?.objectForKey("id") as? String
            }
            
            if let mealPlanId = order?.objectForKey("meal_plan_id") as? NSNumber{
                self.loadMealPlanForMealId(mealPlanId.stringValue)
            } else {
                self.loadMealPlanForMealId(order?.objectForKey("meal_plan_id") as? String)
            }

        }
        self.collectionView.reloadData()
    }
}
    
    func loadPlanNameandNutritionname(){
        for regPlans in (Helper.sharedInstance.subscription?.regplans)! {
            if let mealPlans = regPlans.mealPlans as [MealPlan]? {
                if let mealId = Helper.sharedInstance.subscription?.selectedPlanId {
                    let mealObj = mealPlans.filter{ $0.planId == mealId }.first
                    if mealObj != nil {
                        self.planName.text = (mealObj?.name)!
                        if let dietId = mealObj?.dieticianId {
                            let dietObject = Helper.sharedInstance.subscription?.dieticians!.filter{ $0.dieticianId == dietId }.first
                            self.nutritionistName.text = (dietObject?.firstName ?? "---")
                            return;
                        }
                    }
                }
            }
        }
    }
    
    
    func loadMealPlanForMealId(planId: String?){
    
        Helper.sharedInstance.getSubscriptionMealsForaPlan(planId!, completionHandler: { (response) in
            
            if let dict = response as? NSDictionary {
                
                print(dict)
                guard let dataObj = dict.objectForKey("data") else {
                    return;
                }
//                if let dicti = dataObj.objectForKey("meal_plan") as? NSDictionary{
//                    
//                    self.planName.text = dicti.objectForKey("name") as? String;
//                    var dieticianId = ""
//                    if let dietician = dicti.objectForKey("dietician") as? NSNumber{
//                        dieticianId = dietician.stringValue
//                    } else {
//                        dieticianId = (dicti.objectForKey("dietician") as? String)!
//                    }
//                }
                
                if let dicti = dataObj.objectForKey("meals") as? NSArray{
                    self.mealsArray = []
                    for dict in dicti {
                        if let dict = dict as? NSDictionary {
                            let plannedMeal = PlannedMeals()
                            plannedMeal.saveData(dict)
                            self.mealsArray?.append(plannedMeal)
                        } else {
                            // inorder to show null as empty
                            let plannedMeal = PlannedMeals()
                            self.mealsArray?.append(plannedMeal)
                        }
                    }
                }
                self.collectionView.reloadData()
            } else {
                let warn = UIAlertController(title: "First Eat", message: "Error! Please try again.", preferredStyle: UIAlertControllerStyle.Alert)
                warn.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(warn, animated: true, completion: nil);
            }
        })

    }
    
    func calculateWeekDaysFrom(date: NSDate?){
        var cDate = date;
        guard let _ = date else {
            cDate = NSDate();
            return;
        }
        self.weeksArray.removeAll(keepCapacity: false)
        let calendar: NSCalendar = NSCalendar.currentCalendar();
        
        for i in 0...6 {
            let aDate = cDate!.dateByAddingTimeInterval(NSTimeInterval(60*60*24*i));
            let components: NSDateComponents = calendar.components(.Weekday, fromDate: aDate);
            let weekdayOfDate: Int = components.weekday;
            
            if !(weekdayOfDate == 1 || (weekdayOfDate == 7 && !self.satSelected)) {
                print("weekdayOfDate-> ", aDate, weekdayOfDate)
                self.weeksArray.append(aDate)
            }
        }
    }
}