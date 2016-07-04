//
//  SubscriptionVC.swift
//  MyBreakFast
//
//  Created by AUK on 10/06/16.
//  Copyright © 2016 AUK. All rights reserved.
//

import Foundation

class DieticiansDatasource: NSObject, UICollectionViewDelegate, UICollectionViewDataSource {
    
    // MARK: UICollectionView delegates and datasources
    var dieticiansList : [Dietician]?
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let width: CGFloat = 105.0
        let height: CGFloat = collectionView.bounds.size.height
        
        return CGSizeMake(width, height);
    }
    
    func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath)   {
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1;
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (self.dieticiansList?.count) ?? 0;
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("diticiancell", forIndexPath: indexPath) as? DietCell
        let dietician = self.dieticiansList![indexPath.row]
        cell?.nameLabel.text = dietician.firstName!
        cell?.recommendLabel.text = dietician.lastName!
        
        var url: String? = dietician.imgURL
        url = Constants.API.SubscrImgBaseURL+(url?.stringByAddingPercentEncodingWithAllowedCharacters( NSCharacterSet.URLQueryAllowedCharacterSet()))!
        cell!.imageV.sd_setImageWithURL(NSURL(string: url!), placeholderImage: UIImage(named: "Aboutus"), completed: nil)
        
        return cell!;
    }
    
    func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {

        if collectionView.indexPathsForSelectedItems()![0] == indexPath {
            UIApplication.sharedApplication().sendAction(#selector(SubscriptionVC.showDietciansDetails), to: nil, from: collectionView, forEvent: nil);
            return false;
        }
        else {
            return true;
        }
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        UIApplication.sharedApplication().sendAction(#selector(SubscriptionVC.setSelectionParameters), to: nil, from: collectionView, forEvent: nil);
    }

}

class SubscriptionVC: UIViewController, LocationPickerDelegate {
    
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var dieticiansList: UICollectionView!
    @IBOutlet var planImageView: UIImageView!
    let dieticiansDataSource = DieticiansDatasource();
    var plansList: [RegularPlan]?;
    @IBOutlet var mealPlanLabel: UILabel!

    @IBOutlet var mealDetailsView: MealDetailsView!
    @IBOutlet var customizedSubscrTable: UITableView!
    var planTitle: String?
    
    
    var searchButton: UIButton!
    
    override func beginAppearanceTransition(isAppearing: Bool, animated: Bool) {
        super.beginAppearanceTransition(isAppearing, animated: animated)
        let parentVC: ViewController = self.parentViewController?.parentViewController as! ViewController
        
        if isAppearing {
            self.initNavigationItemTitleView();
            
            let fadeTextAnimation: CATransition = CATransition();
            fadeTextAnimation.duration = 0.5;
            fadeTextAnimation.type = kCATransitionFade;
            
            parentVC.containerNavigationItem.leftBarButtonItem?.image = UIImage(named: "menu_icon.png");
            parentVC.containerNavigationItem.leftBarButtonItem?.action = #selector(ViewController.toggleSideView);
            parentVC.containerNavigationItem.leftBarButtonItem?.target = parentVC;
            parentVC.containerNavigationBar.layer.addAnimation(fadeTextAnimation, forKey: "fadeText");
            parentVC.containerNavigationItem.rightBarButtonItem = nil;
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
        
        let parentVC: ViewController = self.parentViewController?.parentViewController as! ViewController
        
        let searchcustomView = UIView()
        searchcustomView.frame = CGRectMake(0, 0, 240, 44);
        searchcustomView.backgroundColor = UIColor.clearColor()
        
        let width: CGFloat = Constants.DeviceConstants.IS_IPHONE_5_OR_LESS ? 190.0 : (Constants.DeviceConstants.IS_IPHONE_6 ? 240 : 242);
        let offset: CGFloat = 0;//Constants.DeviceConstants.IS_IPHONE_5_OR_LESS ? -10 : 0.0;
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
        searchButton.addTarget(self, action: #selector(MenuVC.showLocationPicker(_:)), forControlEvents: UIControlEvents.TouchUpInside);
        
    }
    
    func showLocationPicker(locationObj: AnyObject?) {
        
        self.searchButton.setTitle("", forState: .Normal)
        let locationPickVC : LocationPicker = self.storyboard?.instantiateViewControllerWithIdentifier("LocationPicker") as! LocationPicker
        locationPickVC.locationDelegate = self;
        self.presentViewController(locationPickVC, animated: true, completion: nil)
        //        return;
    }
    
    func didPickLocation(location: AnyObject?) {
        if let locationObj = location as? Locations {
            print(locationObj.locationId, locationObj.locationName);
            self.searchButton.setTitle(locationObj.locationName, forState: .Normal)
            Helper.sharedInstance.userLocation = locationObj.locationName;
            Helper.sharedInstance.saveToUserDefaults(forKey: Constants.UserdefaultConstants.LastSelectedLocationId, value: locationObj.locationId!)
//            self.didSelectDate(self.menuDate)
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

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Helper.sharedInstance.order = nil;
        Helper.sharedInstance.subscription = nil;
        
        self.customizedSubscrTable.hidden = true;
        self.dieticiansList.delegate = dieticiansDataSource;
        self.dieticiansList.dataSource = dieticiansDataSource;
        
        Helper.sharedInstance.getSubscriptionRegularPlan { (response) in
            if let json = response as? NSDictionary {
                Helper.sharedInstance.subscription = Subscription()
                Helper.sharedInstance.order = Order()
                Helper.sharedInstance.subscription?.saveData(json)
                self.dieticiansDataSource.dieticiansList = Helper.sharedInstance.subscription?.dieticians
                self.plansList = Helper.sharedInstance.subscription?.regplans
                self.dieticiansList.reloadData()
                self.collectionView.reloadData()
                
                let indexPath = NSIndexPath(forItem: 0, inSection: 0)
                self.collectionView.selectItemAtIndexPath(indexPath, animated: true, scrollPosition: .Left)
                self.dieticiansList.selectItemAtIndexPath(indexPath, animated: true, scrollPosition: .Left)

                self.setSelectionParameters()

//                let regularPlan = self.plansList![indexPath.row]
//                let dieticianSelected = self.dieticiansDataSource.dieticiansList![0]
//                var mealPlans = regularPlan.mealPlans!.filter({
//                    $0.dieticianId! == dieticianSelected.dieticianId
//                })
//                let mealPlan = mealPlans[0]
//
//                self.mealDetailsView.setDescription(mealPlan.planDescription)
//
//                var url: String? = mealPlan.imageURL
//                url = Constants.API.SubscrImgBaseURL+(url?.stringByAddingPercentEncodingWithAllowedCharacters( NSCharacterSet.URLQueryAllowedCharacterSet()))!
//                self.planImageView.sd_setImageWithURL(NSURL(string: url!), placeholderImage: UIImage(named: ""), completed: nil)

            }
        }
    }
    
    func showDietciansDetails(){
        let dIndexPath = self.dieticiansList.indexPathsForSelectedItems()![0]
        let dietician = Helper.sharedInstance.subscription?.dieticians![dIndexPath.row]
        
        let bioVC = self.storyboard?.instantiateViewControllerWithIdentifier("DieticianBioVC") as! DieticianBioVC
        self.presentViewController(bioVC, animated: true, completion: {(completion) in
            bioVC.showDieticianDescription(dietician?.biography)
        })
        print(dietician?.biography);
    }
    
    func setSelectionParameters(){
    
        let dIndexPath = self.dieticiansList.indexPathsForSelectedItems()![0]
        let pIndexPath = self.collectionView.indexPathsForSelectedItems()![0]

        let dietician = Helper.sharedInstance.subscription?.dieticians![dIndexPath.row]
        let regularPlan = self.plansList![pIndexPath.row]
        var mealPlans = regularPlan.mealPlans!.filter({
            $0.dieticianId! == dietician!.dieticianId
        })
        
        if mealPlans.count > 0 {
            let mealPlan = mealPlans[0]
            //        let dietcianname = (dietician?.firstName)!+" "+(dietician?.lastName)!
            self.planTitle = mealPlan.name;
            var url: String? = mealPlan.imageURL
            url = Constants.API.SubscrImgBaseURL+(url?.stringByAddingPercentEncodingWithAllowedCharacters( NSCharacterSet.URLQueryAllowedCharacterSet()))!
            self.planImageView.sd_setImageWithURL(NSURL(string: url!), placeholderImage: UIImage(named: "loading"), completed: nil)
            self.mealDetailsView.setDescription(mealPlan.planDescription)
            
            self.mealPlanLabel.text = mealPlan.selectionText!
            Helper.sharedInstance.subscription?.selectedPlanId = mealPlan.planId
            Helper.sharedInstance.order?.mealPlanId = mealPlan.planId;
            Helper.sharedInstance.subscription?.selectedDieticianId = dietician?.dieticianId
        } else {
        
            let warn = UIAlertController(title: "First Eat", message: "The dietician has no plans for the current selection. Please select another.", preferredStyle: UIAlertControllerStyle.Alert)
            warn.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(warn, animated: true, completion: nil);
        }
        
    }
    
    @IBAction func selectedPlan(sender: AnyObject) {
        
        if sender.tag == 1 {
            //regular
            UIView.animateWithDuration(0.3, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
                self.customizedSubscrTable.alpha = 0.0;
                }, completion: { (completion) in
                    self.customizedSubscrTable.hidden = true;
            })
        } else {
            self.customizedSubscrTable.hidden = false;
            self.customizedSubscrTable.alpha = 0.0;

            UIView.animateWithDuration(0.3, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
                self.customizedSubscrTable.alpha = 1.0;
                }, completion: { (completion) in
            })
        }
    }
    
    @IBAction func subscribeAction(sender: AnyObject) {
        
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
                
                if let _ = Helper.sharedInstance.subscription?.selectedDieticianId, let _ = Helper.sharedInstance.subscription?.selectedPlanId {
                    
                    let parentVC = self.parentViewController?.parentViewController as! ViewController
                    let vc = (self.storyboard?.instantiateViewControllerWithIdentifier("SubscriptionDetailsVC")) as? SubscriptionDetailsVC
                    vc?.planTitle = self.planTitle
                    parentVC.cycleFromViewController(nil, toViewController: vc!)
                } else {
                    
                }
            }
  
    }
    
    // MARK: UICollectionView delegates and datasources
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let width: CGFloat = 120.0
        let height: CGFloat = self.collectionView.bounds.size.height
        return CGSizeMake(width, height);
    }
    func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath)   {
    }
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1;
    }
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.plansList?.count ?? 0;
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("plancell", forIndexPath: indexPath) as? PlanCell
        
        let regularPlan = self.plansList![indexPath.row]
        cell?.nameLabel.text = regularPlan.name
        cell?.priceLabel.text = "Plan"//regularPlan.price
        return cell!;
    }
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
//        let regularPlan = self.plansList![indexPath.row]
//
//        let dieticianId = Helper.sharedInstance.subscription?.selectedDieticianId
//        var mealPlans = regularPlan.mealPlans!.filter({
//            $0.dieticianId! == dieticianId
//        })
//        let mealPlan = mealPlans[0]
//        var url: String? = mealPlan.imageURL
//        url = Constants.API.SubscrImgBaseURL+(url?.stringByAddingPercentEncodingWithAllowedCharacters( NSCharacterSet.URLQueryAllowedCharacterSet()))!
//        self.planImageView.sd_setImageWithURL(NSURL(string: url!), placeholderImage: UIImage(named: ""), completed: nil)
//        self.mealDetailsView.setDescription(mealPlan.planDescription)
        self.setSelectionParameters();
    }
    
    // MARK: Subscription Table view
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5;
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("customsubscriptioncell")
        return cell!
    }
}