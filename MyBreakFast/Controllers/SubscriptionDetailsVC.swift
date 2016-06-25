//
//  SubscriptionDetailsVC.swift
//  MyBreakFast
//
//  Created by AUK on 12/06/16.
//  Copyright © 2016 AUK. All rights reserved.
//

import Foundation
import Calendar_iOS

class SubscriptionDetailsVC: UIViewController, CalendarViewDelegate {
    @IBOutlet var calendarCollectionView: UICollectionView!
    var calendarModelSource = CalendarModelDataSource();
    
    @IBOutlet var mealPlanLabel: UILabel!
    @IBOutlet var addressLabelForMeal: UILabel!
    @IBOutlet var sunButton: UIButton!
    @IBOutlet var satButton: UIButton!
    @IBOutlet var calendarView: CalendarView!
    @IBOutlet var calendarBGView: UIView!
    @IBOutlet var MealsSegmentControl: CustomSegmentControl!

    
    var planDetails: PlanDetails?
    var planSlots: [MealSlot]?
    var mealPlans: [PlannedMeals]?
    
    var weekDatesArray: [NSDate] = []
    var selectedStartDate = NSDate();
    var selectedWeekDay: Int = 1;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.calendarView.selectionColor = Constants.AppColors.green.color
        self.calendarView.fontHeaderColor = Constants.AppColors.green.color
        self.calendarView.calendarDelegate = self;
        self.calendarView.shouldShowHeaders = true;
        self.calendarView.shouldMarkToday = false;

        self.calendarView.refresh()
        self.calendarCollectionView.delegate = self.calendarModelSource
        self.calendarCollectionView.dataSource = self.calendarModelSource
        self.calculateWeekDaysFrom(NSDate())
        self.calendarModelSource.datesArray = self.weekDatesArray
        self.calendarCollectionView.reloadData()
        
        Helper.sharedInstance.getSubscriptionMealsForaPlan((Helper.sharedInstance.subscription?.selectedPlanId)!) { (response) in
            if let dict = response as? NSDictionary {
                Helper.sharedInstance.subscription?.saveSubscrDetails(dict.objectForKey("data") as! NSDictionary)
                
                self.planDetails = Helper.sharedInstance.subscription?.planDetails
                self.planSlots = Helper.sharedInstance.subscription?.planSlots
                self.mealPlans = Helper.sharedInstance.subscription?.mealPlans
                
                if self.planDetails?.sat == "0" {
                    self.satButton.enabled = false;
                    self.sunButton.userInteractionEnabled = false;
                }
                //For Now Sunday is Disabled
//                if self.planDetails?.sun == "0" {
                    self.sunButton.enabled = false;
                self.sunButton.userInteractionEnabled = false;
//                }
                
//                self.setAddress();
            }
        }
    }
    
    func setAddress(){
    
        if let addrID = Helper.sharedInstance.getDataFromUserDefaults(forKey: Constants.UserdefaultConstants.LastSelectedAddressId) as? String {
            Helper.sharedInstance.order?.addressId = addrID
            if let userAddr = Helper.sharedInstance.fetchLastUserAddressesForId(addrID) {
                print(userAddr.lineone, userAddr.linetwo)
                self.addressLabelForMeal.text = userAddr.lineone!+", "+userAddr.linetwo!
            }
        } else {
            let userLoginStatus = Helper.sharedInstance.getDataFromUserDefaults(forKey: Constants.UserdefaultConstants.UserLoginStatus) as? Bool
            if userLoginStatus != nil {
                self.showAddAddressVC();
            }
        }
    }
    
    func calculateWeekDaysFrom(date: NSDate?){
        var cDate = date;
        guard let _ = date else {
            cDate = NSDate();
            return;
        }
        self.weekDatesArray.removeAll(keepCapacity: false)
        let calendar: NSCalendar = NSCalendar.currentCalendar();

        let order = calendar.compareDate(cDate!, toDate: NSDate(),
                                                             toUnitGranularity: .Day)
        if order == NSComparisonResult.OrderedSame {
            cDate = cDate!.dateByAddingTimeInterval(NSTimeInterval(60*60*24*1))
        }
        for i in 0...6 {
            let aDate = cDate!.dateByAddingTimeInterval(NSTimeInterval(60*60*24*i));
            let components: NSDateComponents = calendar.components(.Weekday, fromDate: aDate);
            let weekdayOfDate: Int = components.weekday;
            
            if !(weekdayOfDate == 1 || (weekdayOfDate == 7 && !self.satButton.selected)) {
                print("weekdayOfDate-> ", aDate, weekdayOfDate)
                self.weekDatesArray.append(aDate)
            }
        }
    }
    
    func didChangeCalendarDate(date: NSDate)
    {
        print("didChangeCalendarDate: ", date);
    }
    
    func didChangeCalendarDate(date: NSDate!, withType type: Int, withEvent event: Int) {
        if event == 1 {
            
            let calendar: NSCalendar = NSCalendar.currentCalendar();
            let order = calendar.compareDate(date, toDate: NSDate(),
                                             toUnitGranularity: .Day)
            
            if order == NSComparisonResult.OrderedAscending{
                return;
            }
            self.selectedStartDate = date;
            UIView.animateWithDuration(0.3, animations: { 
                self.calendarBGView.alpha = 0.0
                }, completion: { (completion) in
                    self.calendarBGView.hidden = true;
                    self.calculateWeekDaysFrom(date)
                    self.calendarModelSource.datesArray = self.weekDatesArray
                    self.calendarCollectionView.reloadData()
            })
        }
    }
    
    @IBAction func showCalendar() {
        self.calendarBGView.hidden = false;
        UIView.animateWithDuration(0.3, animations: {
            self.calendarBGView.alpha = 1.0
            }, completion: { (completion) in
        })
    }
    
    @IBAction func includeSaturday(sender: UIButton) {
        
        sender.selected = !sender.selected;
        self.calculateWeekDaysFrom(self.selectedStartDate)
        self.calendarModelSource.datesArray = self.weekDatesArray
        self.calendarCollectionView.reloadData()
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
    
    func setSelectedWeekDay(){
        let indexPath = self.calendarCollectionView.indexPathsForSelectedItems()![0]
        self.selectedWeekDay = indexPath.row;
    }
    
    
    @IBAction func mealSelectedType(sender: AnyObject) {
        print(sender)
    }
}

class CalendarModelDataSource: NSObject, UICollectionViewDataSource, UICollectionViewDelegate {
    
    let dateFormatter = NSDateFormatter()
    var datesArray : [NSDate]?

    override init() {
        dateFormatter.dateFormat = "EEE dd MMM";
    }
    // MARK: UICollectionView delegates and datasources
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let width: CGFloat = 100.0
        let height: CGFloat = collectionView.bounds.size.height
        
        return CGSizeMake(width, height);
    }
    
    func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath)   {
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1;
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (self.datesArray?.count)!;
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("calendarcell", forIndexPath: indexPath) as! CalendarWeeksCell
         cell.dateLabel.text = self.dateFormatter.stringFromDate(self.datesArray![indexPath.row] )

        return cell;
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        UIApplication.sharedApplication().sendAction(#selector(SubscriptionDetailsVC.setSelectedWeekDay), to: nil, from: collectionView, forEvent: nil);

    }
}