//
//  SubscriptionDetailsVC.swift
//  MyBreakFast
//
//  Created by AUK on 12/06/16.
//  Copyright © 2016 AUK. All rights reserved.
//

import Foundation
import Calendar_iOS

class SubscriptionDetailsVC: UIViewController, CalendarViewDelegate, AddressProtocol {
    @IBOutlet var calendarCollectionView: UICollectionView!
    var calendarModelSource = CalendarModelDataSource();
    
    @IBOutlet var mealPlanLabel: UILabel!
    @IBOutlet var addressLabelForMeal: UILabel!
    @IBOutlet var sunButton: UIButton!
    @IBOutlet var satButton: UIButton!
    @IBOutlet var calendarView: CalendarView!
    @IBOutlet var calendarBGView: UIView!
    @IBOutlet var MealsSegmentControl: CustomSegmentControl!

    @IBOutlet var mealDetailsView: MealPlanDetailsView!
    var planTitle: String?
    var planDetails: PlanDetails?
    var planSlots: [MealSlot]?
    var mealPlans: [PlannedMeals]?
    
    var weekDatesArray: [NSDate] = []
    var selectedStartDate = NSDate();
    var selectedWeekDay: Int = 1;
    @IBOutlet var priceLabel: UIButton!
    @IBOutlet var repeatCountLabel: UILabel!
    var repeatCount: Int?
    var lastSelectedMealType: Int = 1;
    var planPricePerWeek: Int = 0;
    
    
    @IBOutlet var timeSlotPicker: TimeSlotPickerView!
    @IBOutlet var timeSlotTableBGView: UIView!
    @IBOutlet var timeSlotTableView: UITableView!
    @IBOutlet var timeSlotPickerLeadingConstraint: NSLayoutConstraint!
    var slotsArray: [AnyObject]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.timeSlotTableBGView.layer.cornerRadius = 10.0;
        self.timeSlotTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "timeSlotcell")
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
                
                if self.planDetails?.meal1Exists == "0" {
                    self.MealsSegmentControl.disableSegmentAtIndex(0)
                    Helper.sharedInstance.order?.address1 = ""
                }
                if self.planDetails?.meal2Exists == "0" {
                    self.MealsSegmentControl.disableSegmentAtIndex(1)
                    Helper.sharedInstance.order?.address2 = ""
                }
                if self.planDetails?.meal3Exists == "0" {
                    self.MealsSegmentControl.disableSegmentAtIndex(2)
                    Helper.sharedInstance.order?.address3 = ""
                }
                
                self.mealPlanLabel.text = self.planDetails?.selectionText
                
                let priceLbl = "Pay ₹ "+(self.planDetails?.price)!
                self.planPricePerWeek = Int((self.planDetails?.price)!)!
                self.priceLabel.setTitle(priceLbl, forState: .Normal)
                Helper.sharedInstance.order?.totalAmount = (self.planDetails?.price)!
                
                self.repeatCount = Int((self.planDetails?.minweek)!);
                self.repeatCountLabel.text = self.planDetails?.minweek
                Helper.sharedInstance.order?.weeks = self.planDetails?.minweek

                
                self.calendarCollectionView.selectItemAtIndexPath(NSIndexPath(forItem: 0, inSection: 0), animated: true, scrollPosition: .Left)
                self.selectedWeekDay = 1;
                
                self.showDetailsForDayandMealType(1);
                self.setInitialDefaultsTimeslotsasFirstslot();
            } else {
                let warn = UIAlertController(title: "First Eat", message: "Error! Please try again.", preferredStyle: UIAlertControllerStyle.Alert)
                warn.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(warn, animated: true, completion: nil);
            }
            
        }
    }
    
    func setInitialDefaultsTimeslotsasFirstslot(){
    
        let slot1 = self.planSlots![0]
        var timeSlot = slot1.mealSlots![0]
        Helper.sharedInstance.order?.slot1 = timeSlot.slotId
        var slot = timeSlot.startTime!+" to "+timeSlot.endTime!

        self.MealsSegmentControl.setSelectedSlot(slot, forIndex: 0)

        let slot2 = self.planSlots![1]
         timeSlot = slot2.mealSlots![0]
        Helper.sharedInstance.order?.slot2 = timeSlot.slotId
        slot = timeSlot.startTime!+" to "+timeSlot.endTime!
        self.MealsSegmentControl.setSelectedSlot(slot, forIndex: 1)

        let slot3 = self.planSlots![2]
         timeSlot = slot3.mealSlots![0]
        Helper.sharedInstance.order?.slot3 = timeSlot.slotId
        slot = timeSlot.startTime!+" to "+timeSlot.endTime!
        self.MealsSegmentControl.setSelectedSlot(slot, forIndex: 2)

        self.MealsSegmentControl.selectedIndex = 0;
        self.mealSelectedType(self.MealsSegmentControl);
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let vc = self.parentViewController as! ViewController
//        let regularPlan = Helper.sharedInstance.subscription?.regplans
        vc.setNavBarTitle(self.planTitle!)
    }
    
    func calculateWeekDaysFrom(date: NSDate?){
        var cDate = date;
        guard let _ = date else {
            cDate = NSDate();
            return;
        }
        let dateForm = NSDateFormatter();
        dateForm.dateFormat = "yyyy-MM-dd"
        Helper.sharedInstance.order?.subscriptionDate = dateForm.stringFromDate(cDate!)
        print(Helper.sharedInstance.order?.subscriptionDate)
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
    
    
    @IBAction func showCalendar() {
        self.calendarBGView.hidden = false;
        UIView.animateWithDuration(0.3, animations: {
            self.calendarBGView.alpha = 1.0
            }, completion: { (completion) in
        })
    }
    
    @IBAction func includeSaturday(sender: UIButton) {
        
        var priceLbl = "Pay ₹ "
        var price = 0;
        if sender.selected {
            sender.selected = false
            price = Int((self.planDetails?.price)!)!
            Helper.sharedInstance.order?.satIncluded = "0"
        } else {
            sender.selected = true;
            price = Int((self.planDetails?.priceSat)!)!
            Helper.sharedInstance.order?.satIncluded = "1"
        }
        self.planPricePerWeek = price;
        price = price*self.repeatCount!;
        priceLbl = priceLbl+String(price)

        self.calculateWeekDaysFrom(self.selectedStartDate)
        self.calendarModelSource.datesArray = self.weekDatesArray
        self.calendarCollectionView.reloadData()
        
        self.priceLabel.setTitle(priceLbl, forState: .Normal)
        Helper.sharedInstance.order?.totalAmount = String(price)

    }
    
    @IBAction func checkOut(sender: AnyObject) {
        if (Helper.sharedInstance.order?.address1 == nil) || (Helper.sharedInstance.order?.address2 == nil) || (Helper.sharedInstance.order?.address3 == nil) || (Helper.sharedInstance.order?.slot1 == nil) || (Helper.sharedInstance.order?.slot2 == nil) || (Helper.sharedInstance.order?.slot3 == nil){
            
            let warn = UIAlertController(title: "First Eat", message: "Please select timeslot and address for each meal type.", preferredStyle: UIAlertControllerStyle.Alert)
            warn.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(warn, animated: true, completion: nil);
        } else {
        
            let parentVC = self.parentViewController as! ViewController
            parentVC.cycleFromViewController(nil, toViewController: (self.storyboard?.instantiateViewControllerWithIdentifier("CartVC"))!)
        }
    }
    
    func setSelectedWeekDay(){
        let indexPath = self.calendarCollectionView.indexPathsForSelectedItems()![0]
        self.selectedWeekDay = indexPath.row+1;
        print(self.selectedWeekDay);
        self.showDetailsForDayandMealType(self.lastSelectedMealType)
    }
    
    func showDetailsForDayandMealType(mealTypeSelected: Int){
        let mealIndex = mealTypeSelected * self.selectedWeekDay;
        let mealPlan = self.mealPlans![mealIndex]
        self.mealDetailsView.setMealDetails(mealPlan);
        switch mealTypeSelected {
        case 1:
            if let addressId = Helper.sharedInstance.order?.address1{
                if let userAddr = Helper.sharedInstance.fetchLastUserAddressesForId(addressId) {
                    print(userAddr.lineone, userAddr.linetwo)
                    self.addressLabelForMeal.text = userAddr.lineone!+", "+userAddr.linetwo!
                }
            } else {
                self.addressLabelForMeal.text = "Add address"
            }
            break;
        case 2:
            if let addressId = Helper.sharedInstance.order?.address2{
                if let userAddr = Helper.sharedInstance.fetchLastUserAddressesForId(addressId) {
                    print(userAddr.lineone, userAddr.linetwo)
                    self.addressLabelForMeal.text = userAddr.lineone!+", "+userAddr.linetwo!
                }
            } else {
                self.addressLabelForMeal.text = "Add address"
            }
            break;
        case 3:
            if let addressId = Helper.sharedInstance.order?.address3{
                if let userAddr = Helper.sharedInstance.fetchLastUserAddressesForId(addressId) {
                    print(userAddr.lineone, userAddr.linetwo)
                    self.addressLabelForMeal.text = userAddr.lineone!+", "+userAddr.linetwo!
                }
            }else {
                self.addressLabelForMeal.text = "Add address"
            }
            break;
        default:
            break;
        }
    }
    
    @IBAction func mealSelectedType(mealSegmentControl: CustomSegmentControl) {
        let mealSelected = mealSegmentControl.selectedIndex;
        print(self.lastSelectedMealType)
        if mealSelected == (self.lastSelectedMealType-1) {
            self.showTimeSlotsForMealType(mealSelected);
        } else {
            self.showDetailsForDayandMealType(mealSelected+1);
        }
        self.lastSelectedMealType = mealSelected+1;
    }
    
    @IBAction func showSubscriptionView(sender: AnyObject) {
        let parentVC = self.parentViewController as! ViewController
        parentVC.cycleFromViewController(nil, toViewController: (self.storyboard?.instantiateViewControllerWithIdentifier("SubscriptionMenuVC"))!)

    }
    @IBAction func incrementRepeatCount(sender: AnyObject) {
        self.repeatCount = self.repeatCount!+1
        self.repeatCountLabel.text = String(self.repeatCount!)
        Helper.sharedInstance.order?.weeks = String(self.repeatCount!);
        var priceLbl = "Pay ₹ "
        let price = self.repeatCount! * self.planPricePerWeek;
        priceLbl = priceLbl+String(price)
        self.priceLabel.setTitle(priceLbl, forState: .Normal)
        Helper.sharedInstance.order?.totalAmount = String(price)

    }
    
    @IBAction func decrementRepeatCount(sender: AnyObject) {
        if self.repeatCount > Int((self.planDetails?.minweek)!){
            self.repeatCount = self.repeatCount!-1
            self.repeatCountLabel.text = String(self.repeatCount!)
            Helper.sharedInstance.order?.weeks = String(self.repeatCount!);

            var priceLbl = "Pay ₹ "
            let price = self.repeatCount! * self.planPricePerWeek;
            priceLbl = priceLbl+String(price)
            self.priceLabel.setTitle(priceLbl, forState: .Normal)
            Helper.sharedInstance.order?.totalAmount = String(price)
        }
    }
    
    //MARK: Calendar delegates
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
                let warn = UIAlertController(title: "First Eat", message: "Please select only future dates.", preferredStyle: UIAlertControllerStyle.Alert)
                warn.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(warn, animated: true, completion: nil);
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
                    self.calendarCollectionView.selectItemAtIndexPath(NSIndexPath(forItem: 0, inSection: 0), animated: true, scrollPosition: .Left)
                    self.selectedWeekDay = 1;
            })
        }
    }
    
    //MARK: TimeSlotPicker methods
    
    func showTimeSlotsForMealType(mealType: Int){
        let slot = self.planSlots![mealType]
        self.slotsArray = slot.mealSlots
        self.timeSlotTableView.reloadData()
        let width = self.MealsSegmentControl.bounds.size.width/3
        self.timeSlotPickerLeadingConstraint.constant = width*CGFloat(mealType)+1.0
        self.presentTimeSlotPicker()
    }
    
    func dismissTimeSlotPicker(){
        UIView.animateWithDuration(0.3, animations: { 
            self.timeSlotPicker.alpha = 0.0
            }) { (completion) in
            self.timeSlotPicker.hidden = true;
            self.view.sendSubviewToBack(self.timeSlotPicker)
        }
    }
    
    func presentTimeSlotPicker(){
        self.timeSlotPicker.hidden = false;
        self.timeSlotPicker.alpha = 0.0;
        self.view.bringSubviewToFront(self.timeSlotPicker)
        UIView.animateWithDuration(0.3, animations: {
            self.timeSlotPicker.alpha = 1.0
            self.view.layoutIfNeeded()

        }) { (completion) in
        }
    }
    
    //MARK: TimeSlot Picker Table Delegates
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let timeSlot = self.slotsArray![indexPath.row] as? TimeSlot {
            print("slotid: ",timeSlot.slotId);
            let slot = timeSlot.startTime!+" to "+timeSlot.endTime!
            self.MealsSegmentControl.setSelectedSlot(slot, forIndex: self.lastSelectedMealType-1)
            
            switch self.lastSelectedMealType {
            case 1:
                Helper.sharedInstance.order?.slot1 = timeSlot.slotId;
                break;
            case 2:
                Helper.sharedInstance.order?.slot2 = timeSlot.slotId;

                break;
            case 3:
                Helper.sharedInstance.order?.slot3 = timeSlot.slotId;
                break;
            default:
                Helper.sharedInstance.order?.slot1 = timeSlot.slotId;
                Helper.sharedInstance.order?.slot2 = timeSlot.slotId;
                Helper.sharedInstance.order?.slot3 = timeSlot.slotId;

                break;
            }
        }
        self.dismissTimeSlotPicker();
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.slotsArray != nil) ? (self.slotsArray?.count)! : 0;
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("timeSlotcell")
        cell?.textLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 10.0)
        cell?.textLabel?.adjustFontToRealIPhoneSize = true;
        cell?.contentView.backgroundColor = UIColor.clearColor()
        cell?.backgroundColor = UIColor.clearColor()
        if let timeSlot = self.slotsArray![indexPath.row] as? TimeSlot {
            cell?.textLabel?.text = (((timeSlot.startTime)! as NSString).substringToIndex(5))+" - "+(((timeSlot.endTime)! as NSString).substringToIndex(5))
        }
        return cell!
    }
    
    //MARK: Adresss Picker Delegate
    func didPickAddress(addrId: String?) {
        if let addressId = addrId{
            if let userAddr = Helper.sharedInstance.fetchLastUserAddressesForId(addressId) {
                print(userAddr.lineone, userAddr.linetwo)
                self.addressLabelForMeal.text = userAddr.lineone!+", "+userAddr.linetwo!
                
                switch self.lastSelectedMealType {
                case 1:
                    Helper.sharedInstance.order?.address1 = addressId;
                    break;
                case 2:
                    Helper.sharedInstance.order?.address2 = addressId;
                    break;
                case 3:
                    Helper.sharedInstance.order?.address3 = addressId;
                    break;
                default:
                    break;
                }
            }
        }
    }
    
    func showAddAddressVC(){
        //        AddAddressVC
        let addrNVC: UINavigationController = (self.storyboard?.instantiateViewControllerWithIdentifier("AddAddressNVC")) as! UINavigationController
        let addrVC = addrNVC.viewControllers[0] as! AddAddressVC
        addrVC.delegate = self;
        self.presentViewController(addrNVC, animated: true) { () -> Void in
        }
    }
    
    @IBAction func changeUserAddress(sender: AnyObject) {
        self.showAddAddressVC()
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