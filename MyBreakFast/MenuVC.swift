//
//  MenuVC.swift
//  MyBreakFast
//
//  Created by Uday Kiran Ailapaka on 29/10/15.
//  Copyright © 2015 AUK. All rights reserved.
//

import Foundation
import UIKit
import SDWebImage
import TIPBadgeManager


class MenuVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, DatePickerVCDelegate, LocationPickerVCDelegate, UIAlertViewDelegate, LocationPickerDelegate {
    @IBOutlet var collectionView: UICollectionView!
    
    @IBOutlet weak var dateTableView: UITableView!
    var datesArray: [NSDate] = []
    @IBOutlet weak var numberOfItemsLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UIBarButtonItem!
     var searchButton: UIButton!
    var itemsArray : [AnyObject] = [];
    let dateFormatter = NSDateFormatter()
    @IBOutlet weak var topToolbar: UIToolbar!
    var cartButtonIcon: UIButton?
    var itemQuantities = 0;
    var menuDate = NSDate();
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.fetchAddressess();
        
        Helper.sharedInstance.userLocation = nil;
        Helper.sharedInstance.order = nil;
        Helper.sharedInstance.quantities = nil;
        
        self.dateTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.dateTableView.hidden = true;
        self.dateTableView.rowHeight = 44.0;

        UINavigationBar.appearance().setBackgroundImage(UIImage(named: "normalsegment.png"), forBarMetrics: UIBarMetrics.Default);
        UINavigationBar.appearance().shadowImage = UIImage();
        
        self.datesArray.append(NSDate())
        
//        let dayComponent: NSDateComponents = NSDateComponents();
//        dayComponent.day = 1;
//        
//        let theCalendar: NSCalendar = NSCalendar.currentCalendar();
//        let nextDate: NSDate = theCalendar.dateByAddingComponents(dayComponent, toDate: NSDate(), options: .MatchFirst)!
//        

        
        self.datesArray.append(NSDate().dateByAddingTimeInterval(60*60*24))

        self.dateFormatter.locale = NSLocale(localeIdentifier: "en_US")
        self.dateFormatter.doesRelativeDateFormatting = true;
        self.dateFormatter.timeStyle = NSDateFormatterStyle.NoStyle;
        self.dateFormatter.dateStyle = NSDateFormatterStyle.FullStyle;

        let collectionViewLayoutVertical = UICollectionViewFlowLayout()
        collectionViewLayoutVertical.scrollDirection = UICollectionViewScrollDirection.Vertical
        collectionViewLayoutVertical.minimumLineSpacing = 20;
        collectionViewLayoutVertical.sectionInset = UIEdgeInsetsMake(10, 0, 50, 0)
        self.collectionView.setCollectionViewLayout(collectionViewLayoutVertical, animated: true)
        self.collectionView.registerNib(UINib.init(nibName: "MenuItemCell", bundle: NSBundle.mainBundle()), forCellWithReuseIdentifier: "item")
        
        self.performSelector("fetchMenuData", withObject: nil, afterDelay: 1.0)
        
        let dtFormat = NSDateFormatter()
        dtFormat.dateFormat = "EEEE dd, MMM"
        let date = NSDate()
        self.dateLabel.title = self.dateFormatter.stringFromDate(date)+" ("+dtFormat.stringFromDate(date)+")"
        self.dateLabel.tintColor = UIColor.darkGrayColor()
        
        if let locId = Helper.sharedInstance.getDataFromUserDefaults(forKey: Constants.UserdefaultConstants.LastSelectedLocationId) {
            let locations = Helper.sharedInstance.getLocationsForLocationId(locId as! String);
            if locations.count > 0 {
                let locationObj = locations[0] as? Locations
                Helper.sharedInstance.userLocation = locationObj?.locationName;
            } else {
                self.performSelector("showDeliveryLocationPopUp", withObject: nil, afterDelay: 1.0);
            }
        } else {
            self.performSelector("showDeliveryLocationPopUp", withObject: nil, afterDelay: 1.0);
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.collectionView.collectionViewLayout.invalidateLayout()
    }
    
    func fetchMenuData(){
        Helper.sharedInstance.isOrderForTomorrow = false;
        self.didSelectDate(NSDate());
    }
    
    func fetchAddressess() {
        Helper.sharedInstance.fetchUserAddressess { (response) -> () in
            let responseStatus = (response as? String) ?? ""
            if responseStatus == "ERROR"{
            } else {
                
                let responseStat = (response as? [AnyObject]) ?? []
                for obj in responseStat {
                    if let dict = obj as? NSDictionary {
                        let userAddressObj = Helper.sharedInstance.getUserAddressObject() as? UserAddress
                        
                        if let obj = dict.objectForKey("address_id") as? NSNumber{
                            userAddressObj?.addressId = obj.stringValue
                        } else {
                            userAddressObj?.addressId = dict.objectForKey("address_id") as? String;
                        }
                        
                        let dictionary = dict.objectForKey("addresses")
                        userAddressObj?.lineone = dictionary!.objectForKey("0") as? String;
                        userAddressObj?.linetwo = dictionary!.objectForKey("1") as? String;
                        userAddressObj?.category = dictionary!.objectForKey("category") as? String;
                        userAddressObj?.cluster = dictionary!.objectForKey("cluster") as? String;

                    } else {

                    }
                }
                Helper.sharedInstance.saveContext()

            }
        }
    }

    
    func segmentAction(sender: UIButton) {
    
    }
    

    
    @IBAction func proceedtoConfirmOrder(sender: AnyObject) {
        
        let userLoginStatus = Helper.sharedInstance.getDataFromUserDefaults(forKey: Constants.UserdefaultConstants.UserLoginStatus) as? Bool
        
        let userRegistrationStatus = Helper.sharedInstance.getDataFromUserDefaults(forKey: Constants.UserdefaultConstants.UserRegistration) as? Bool
        if ((Helper.sharedInstance.userLocation) == nil) {
            UIAlertView(title: "First Eat", message: "Please choose a delivery location", delegate: nil, cancelButtonTitle: "OK").show()
        } else if self.itemQuantities == 0{
            UIAlertView(title: "First Eat", message: "Please choose an item from the menu", delegate: nil, cancelButtonTitle: "OK").show()
        }
        else if userLoginStatus == nil {
            let vc: AppSignInVC = (self.storyboard?.instantiateViewControllerWithIdentifier("AppSignInVC")) as! AppSignInVC
            self.presentViewController(vc, animated: true, completion: nil)
            vc.completionHandler = {dict in
                print(dict);
                vc.dismissViewControllerAnimated(true, completion: { () -> Void in
                    //                    if let obj = dict.object
                })
            };
        } else if userRegistrationStatus == nil {
            //            Helper.sharedInstance.doUserRegistration({ (anyObject) -> () in
            //                print("$$$$$$$$$$$$$$$$: ",anyObject);
            //            })
            let vc: AppSignInVC = (self.storyboard?.instantiateViewControllerWithIdentifier("AppSignInVC")) as! AppSignInVC
            self.presentViewController(vc, animated: true, completion: nil)
            vc.completionHandler = {dict in
                print(dict);
                vc.dismissViewControllerAnimated(true, completion: { () -> Void in
                    //                    if let obj = dict.object
                })
            };
            
        } else {
                let parentVC = self.parentViewController as! ViewController
                parentVC.cycleFromViewController(nil, toViewController: (self.storyboard?.instantiateViewControllerWithIdentifier("UserOrderDetails"))!)
        }

    }
    
    @IBAction func showDatePicker(sender: AnyObject) {
        
        self.dateTableView.alpha = 0.0;
        self.dateTableView.hidden = false;

        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.dateTableView.alpha = 1.0;
            }) { (completed) -> Void in
        }
        
    }
    
    func showDeliveryLocationPopUp() {

        let imageView = UIImageView(frame: CGRectMake(85, 22, 12, 16))
        imageView.image = UIImage(named: "location.png");
        
        let alertController = UIAlertController(title: "First Eat", message: "Please select a delivery location", preferredStyle: .Alert)
        let searchAction = UIAlertAction(title: "OK", style: .Default) { (_) in
            self.showLocationPicker(nil);
        }
        alertController.addAction(searchAction)
        alertController.view.addSubview(imageView)

        self.presentViewController(alertController, animated: true) {
            alertController.view.tintColor = Constants.StaticContent.AppThemeColor;

        }

    }
    
    func didSelectDate(date: AnyObject){
        let selectedDate = date as! NSDate
        self.menuDate = selectedDate;
        print(self.dateFormatter.stringFromDate(selectedDate))
        Helper.sharedInstance.getMenuFor(selectedDate, completionHandler: {
            self.itemsArray = Helper.sharedInstance.getTodaysItems();
            Helper.sharedInstance.order = Order();
            let maxCount = max((self.itemsArray.count-1), 0)
            for _ in 0...maxCount {
                Helper.sharedInstance.order?.orders.append(OrderItem());
                }
            self.collectionView.reloadData()
        })
    }
    
    func showLocationPicker(locationObj: AnyObject?) {
        
        self.searchButton.setTitle("", forState: .Normal)
        let locationPickVC : LocationPicker = self.storyboard?.instantiateViewControllerWithIdentifier("LocationPicker") as! LocationPicker
        locationPickVC.locationDelegate = self;
        self.presentViewController(locationPickVC, animated: true, completion: nil)
//        return;
    }
    
    func didSelectLocation(location:AnyObject) {
        let locationObj: Locations = location as! Locations
        self.searchButton.setTitle(locationObj.locationName, forState: .Normal)
        Helper.sharedInstance.userLocation = locationObj.locationName;
//        Helper.sharedInstance.order?.addressId = locationObj.locationId;

    }
    

    func didPickLocation(location: AnyObject?) {
        if let locationObj = location as? Locations {
            print(locationObj.locationId, locationObj.locationName);
            self.searchButton.setTitle(locationObj.locationName, forState: .Normal)
            Helper.sharedInstance.userLocation = locationObj.locationName;
            Helper.sharedInstance.saveToUserDefaults(forKey: Constants.UserdefaultConstants.LastSelectedLocationId, value: locationObj.locationId!)
            self.didSelectDate(self.menuDate)
        } else {
            if let locId = Helper.sharedInstance.getDataFromUserDefaults(forKey: Constants.UserdefaultConstants.LastSelectedLocationId) {
                let locations = Helper.sharedInstance.getLocationsForLocationId(locId as! String);
                if locations.count > 0 {
                    let locationObj = locations[0] as? Locations
                    Helper.sharedInstance.userLocation = locationObj?.locationName;
                    self.searchButton.setTitle(locationObj?.locationName, forState: .Normal)
                } else {
                    self.searchButton.setTitle("Search for locations", forState: .Normal)
                }
            } else {
                self.searchButton.setTitle("Search for locations", forState: .Normal)
            }
        }
    }

    
    override func beginAppearanceTransition(isAppearing: Bool, animated: Bool) {
        super.beginAppearanceTransition(isAppearing, animated: animated)
        let parentVC: ViewController = self.parentViewController as! ViewController

        if isAppearing {
            self.initNavigationItemTitleView();
            
            let fadeTextAnimation: CATransition = CATransition();
            fadeTextAnimation.duration = 0.5;
            fadeTextAnimation.type = kCATransitionFade;
            
            parentVC.containerNavigationItem.leftBarButtonItem?.image = UIImage(named: "menu_icon.png");
            parentVC.containerNavigationItem.leftBarButtonItem?.action = "toggleSideView";
            parentVC.containerNavigationItem.leftBarButtonItem?.target = parentVC;
            parentVC.containerNavigationBar.layer.addAnimation(fadeTextAnimation, forKey: "fadeText");
        } else {
            parentVC.containerNavigationItem.rightBarButtonItem = nil;
        }
        
        if let title = Helper.sharedInstance.userLocation {
            self.searchButton.setTitle(title, forState: UIControlState.Normal)
        }

    }
    override func endAppearanceTransition() {
        super.endAppearanceTransition()
    }
    
    private func initNavigationItemTitleView() {
        
        let parentVC: ViewController = self.parentViewController as! ViewController

        let searchcustomView = UIView()
        searchcustomView.frame = CGRectMake(0, 0, 240, 44);
        searchcustomView.backgroundColor = UIColor.clearColor()
        
        let width: CGFloat = Constants.DeviceConstants.IS_IPHONE_5_OR_LESS ? 200.0 : 240.0;
        let offset: CGFloat = Constants.DeviceConstants.IS_IPHONE_5_OR_LESS ? -10 : 0.0;
        let height: CGFloat = Constants.DeviceConstants.IS_IPHONE_5_OR_LESS ? 27.0 : 30.0;

        self.searchButton = UIButton(type: UIButtonType.Custom)
        searchButton.frame = CGRectMake(offset, 6, width, height);
        searchButton.setBackgroundImage(UIImage(named: "searchbg.png"), forState: UIControlState.Normal)
        searchButton.setTitle("Search for locations", forState: UIControlState.Normal)
        searchButton.titleEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 20);
        searchButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        searchButton.titleLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 14.0);
        searchButton.titleLabel?.textAlignment = NSTextAlignment.Center
        searchcustomView.addSubview(searchButton);
        parentVC.containerNavigationItem.title = nil;
        parentVC.containerNavigationItem.titleView = searchcustomView//self.titleView
        searchButton.addTarget(self, action: "showLocationPicker:", forControlEvents: UIControlEvents.TouchUpInside);
        
        let cartButton: UIButton = UIButton(type: .Custom);
        cartButton.frame = CGRectMake(5, 0, 32, 32);
        cartButton.setBackgroundImage(UIImage(named: "bell.png"), forState: .Normal)
        
        let customView = UIView()
        customView.frame = CGRectMake(0, 0, 40, 35);
        customView.backgroundColor = UIColor.clearColor()
        customView.addSubview(cartButton)
        cartButton.addTarget(self, action: "cartClicked:", forControlEvents: UIControlEvents.TouchUpInside)
        self.cartButtonIcon = cartButton
        let useItem: UIBarButtonItem = UIBarButtonItem(customView: customView);
        parentVC.containerNavigationItem.setRightBarButtonItem(useItem, animated: true);

    }
    
    func updateToolbar() {
        Helper.sharedInstance.getOrderCountandPrice { (count, price) -> () in
            print(count, price)
            self.itemQuantities = count;
            self.numberOfItemsLabel.text = String(count)+" items selected"
        }
    }
    
    func cartClicked(sender: AnyObject) {
        
        let vc = self.storyboard?.instantiateViewControllerWithIdentifier("OfferNotificationsVC")
        self.presentViewController(vc!, animated: true, completion: nil)
       
    }
   
    // MARK: UICollectionView delegates and datasources
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let width: CGFloat = ((UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Phone) ? collectionView.bounds.size.width-10 : 600.0);
        let height: CGFloat = (UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Phone) ? 340.0 : 400.0;

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
        return 1;
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.itemsArray.count;
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell: MenuItemCell = (collectionView.dequeueReusableCellWithReuseIdentifier("item", forIndexPath: indexPath) as? MenuItemCell)!
        let item : Item = self.itemsArray[indexPath.item] as! Item
        cell.item = item;
        cell.orderItem = Helper.sharedInstance.order?.orders[indexPath.row] 
        cell.setItemContent();
        return cell;
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
    }
    
    //MARK: Date Picker TableView Delegates
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        self.dateLabel.title = cell?.textLabel?.text;
        if indexPath.row == 0 {
            Helper.sharedInstance.isOrderForTomorrow = false;
        } else {
            Helper.sharedInstance.isOrderForTomorrow = true;
        }
        
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.dateTableView.alpha = 0.0;
            }) { (completed) -> Void in
                self.didSelectDate(self.datesArray[indexPath.row])
                self.dateTableView.hidden = true;
        }

    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.datesArray.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier("cell")! 
cell.textLabel?.textColor = UIColor.darkGrayColor()//Constants.StaticContent.AppThemeColor;
//        cell.textLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 16.0)
        let dtFormat = NSDateFormatter()
        dtFormat.dateFormat = "EEEE dd, MMM"
        let date = self.datesArray[indexPath.row] as NSDate
        cell.textLabel?.text = self.dateFormatter.stringFromDate(date)+" ("+dtFormat.stringFromDate(date)+")"
        
        return cell
    }
//    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
//        self.dateTableView.hidden = true;
//        self.dateTableView.alpha = 0;
//
//    }
}