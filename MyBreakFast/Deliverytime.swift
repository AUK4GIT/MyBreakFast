//
//  Deliverytime.swift
//  MyBreakFast
//
//  Created by Uday Kiran Ailapaka on 22/11/15.
//  Copyright © 2015 AUK. All rights reserved.
//

import Foundation
class Deliverytime: UICollectionViewCell {
    @IBOutlet var collectionView: UICollectionView!
    var slotsArray: [AnyObject] = [];
    @IBOutlet var collectionViewLayout: UICollectionViewFlowLayout!
    var activity: UIActivityIndicatorView?


    func fetchSlots() {
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateFromString = dateFormatter.dateFromString(Helper.sharedInstance.orderDate!);
        
        Helper.sharedInstance.fetchTimeSolts(forDate: dateFromString!) { (response) -> () in
            let responseStatus = (response as? String) ?? ""
            if responseStatus == "ERROR"{
//                self.fetchSlots();
            } else {
                
                let responseStat = (response as? [AnyObject]) ?? []
                for obj in responseStat {
                    if let dict = obj as? NSDictionary {
                        let timeSlotsObj = Helper.sharedInstance.getTimeSlotsObject() as? TimeSlots
                        
                        if let obj = dict.objectForKey("kitchen_id") as? NSNumber{
                            timeSlotsObj?.kitchenid = obj.stringValue
                        } else {
                            timeSlotsObj?.kitchenid = dict.objectForKey("kitchen_id") as? String;
                        }
                        if let obj = dict.objectForKey("order_limit") as? NSNumber{
                            timeSlotsObj?.orderlimit = obj.stringValue
                        } else {
                            timeSlotsObj?.orderlimit = dict.objectForKey("order_limit") as? String;
                        }
                        if let obj = dict.objectForKey("present_orders") as? NSNumber{
                            timeSlotsObj?.presentorders = obj.stringValue
                        } else {
                            timeSlotsObj?.presentorders = dict.objectForKey("present_orders") as? String;
                        }
                        if let obj = dict.objectForKey("id") as? NSNumber{
                            timeSlotsObj?.slotid = obj.stringValue
                        } else {
                            timeSlotsObj?.slotid = dict.objectForKey("id") as? String;
                        }
                        
                        timeSlotsObj?.slot = dict.objectForKey("slot") as? String;
                        timeSlotsObj?.starttime = dict.objectForKey("start_time") as? String;
                        timeSlotsObj?.endtime = dict.objectForKey("end_time") as? String;
                        timeSlotsObj?.status = dict.objectForKey("status") as? String;
                        self.slotsArray.append(timeSlotsObj!);
                        Helper.sharedInstance.saveContext()
                    } else {
                        
                    }
                }
                self.collectionView.reloadData()
            }
            self.activity?.stopAnimating()

        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.activity = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
        self.activity?.frame = CGRectMake(0, 0, 50, 50);
        self.activity?.center = CGPointMake(self.bounds.width/2, self.bounds.height/2);
        self.addSubview(self.activity!);
        self.activity?.color = UIColor(red: 200.0/255.0, green: 5.0/255.0, blue: 15.0/255.0, alpha: 1.0)
        self.activity?.startAnimating()
        self.activity?.hidesWhenStopped = true;
        
        let userLoginStatus = Helper.sharedInstance.getDataFromUserDefaults(forKey: Constants.UserdefaultConstants.UserLoginStatus) as? Bool
        if (userLoginStatus != nil) {
            self.fetchSlots();
        }
        self.collectionViewLayout.minimumLineSpacing = 1;
        self.collectionView.collectionViewLayout = self.collectionViewLayout
    }
    
    // MARK: UICollectionView delegates and datasources
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let width: CGFloat = 150//((UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Phone) ? collectionView.bounds.size.width/4 : collectionView.bounds.size.width/4);
        let height: CGFloat = (UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Phone) ? 44.0 : 44.0;
        
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
        return self.slotsArray.count;
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell: TimeSlotCell = collectionView.dequeueReusableCellWithReuseIdentifier("timeslot", forIndexPath: indexPath) as! TimeSlotCell
        let slotObj = self.slotsArray[indexPath.item] as? TimeSlots;
        cell.setContent(slotObj!);
        return cell;
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let slotObj = self.slotsArray[indexPath.item] as? TimeSlots;
        if slotObj?.status != "Active"{
            collectionView.deselectItemAtIndexPath(indexPath, animated: true)
            Helper.sharedInstance.order?.timeSlotId = nil;
            Helper.sharedInstance.order?.slot = nil;
        } else {
            Helper.sharedInstance.order?.timeSlotId = slotObj?.slotid;
            Helper.sharedInstance.order?.slot = slotObj?.slot;
        }

    }

}