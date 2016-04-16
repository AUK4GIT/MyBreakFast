//
//  AddAddressVC.swift
//  MyBreakFast
//
//  Created by Uday Kiran Ailapaka on 17/01/16.
//  Copyright © 2016 AUK. All rights reserved.
//

import Foundation

class AddAddressVC: UIViewController, LocationPickerVCDelegate {
    
    @IBOutlet var collectionView: UICollectionView!
    var itemsArray : [AnyObject] = [];
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let doneButton: UIButton = UIButton(type: .Custom)
        doneButton.frame = CGRectMake(0, 0, 60, 44)
        doneButton.setTitle("Back", forState: .Normal)
        doneButton.titleLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 18.0);
        doneButton.titleLabel?.adjustFontToRealIPhoneSize = true;
        doneButton.addTarget(self, action: "dismissViewController", forControlEvents: .TouchUpInside)
        doneButton.titleEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0)
        
        self.navigationItem.title = "Add Address";
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: doneButton)
//        self.collectionView.registerClass(AddressCell.self, forCellWithReuseIdentifier: "AddressCell")
        self.fetchAddressess();
    }
    
    func dismissViewController(){
        self.dismissViewControllerAnimated(true, completion: nil);
    }
    
    func showLocationPicker(sender: UIButton) {
        let locationPickVC : LocationPickerVC = self.storyboard?.instantiateViewControllerWithIdentifier("LocationPickerVC") as! LocationPickerVC
        locationPickVC.delegate = self;
        locationPickVC.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext
        self.presentViewController(locationPickVC, animated: true, completion: nil)
    }
    
    func didSelectLocation(location:AnyObject) {
        let locationObj: Locations = location as! Locations
//        self.locationButton.setTitle(locationObj.locationName, forState: .Normal)
        Helper.sharedInstance.userLocation = locationObj.locationName;
        //        Helper.sharedInstance.order?.addressId = locationObj.locationId;
        
        let cell = self.collectionView.cellForItemAtIndexPath(NSIndexPath(forItem: 0, inSection: 0)) as! AddAddressCell
        cell.locationButton.setTitle(locationObj.locationName, forState: UIControlState.Normal)
        
    }
    
    func fetchAddressess() {
        Helper.sharedInstance.fetchUserAddressess { (response) -> () in
            let responseStatus = (response as? String) ?? ""
            if responseStatus == "ERROR"{
                UIAlertView(title: "First Eat", message: "Error fetching addresses. Please try again.", delegate: nil, cancelButtonTitle: "OK").show()
            } else {
                
                let responseStat = (response as? [AnyObject]) ?? []
                if responseStat.count > 0 {
                    Helper.sharedInstance.deleteData("UserAddress");
                    Helper.sharedInstance.saveContext()
                }
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
                        self.itemsArray.append(userAddressObj!)
                    } else {
                    }
                }
                Helper.sharedInstance.saveContext()
                self.collectionView.reloadSections(NSIndexSet(index: 1))
            }
        }
    }
    
    
    // MARK: UICollectionView delegates and datasources
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let width: CGFloat = ((UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Phone) ? collectionView.bounds.size.width : 600.0);
        var height: CGFloat = (UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Phone) ? 75.0 : 100.0;
        height = indexPath.section == 0 ? 156.0: height;
        return CGSizeMake(width, height);
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
        return 2;
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return section==0 ? 1: self.itemsArray.count;
    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        
        let reusableview: UICollectionReusableView?;
        
        if kind == UICollectionElementKindSectionHeader {
            reusableview = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier: "CartHeaderView", forIndexPath: indexPath)
            let label: UILabel = reusableview?.viewWithTag(5) as! UILabel
            label.text = "Add a new address"
            if indexPath.section == 1 {
                label.text = "Choose a delivery location"
            }
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
            cell = collectionView.dequeueReusableCellWithReuseIdentifier("yourdetailsFixed", forIndexPath: indexPath)
            break;
        case 1 :
            
            let cell: AddressCell = collectionView.dequeueReusableCellWithReuseIdentifier("AddressCell", forIndexPath: indexPath) as! AddressCell
            let userAddr = self.itemsArray[indexPath.row] as? UserAddress
            cell.firstLine.text = userAddr?.linetwo
            cell.secondLine.text = userAddr?.lineone
            
            let bView = UIView(frame: cell.bounds)
            bView.backgroundColor = UIColor(red: 200.0/255.0, green: 200.0/255.0, blue: 200.0/255.0, alpha: 1.0)
            cell.selectedBackgroundView = bView

            
            return cell;

        default:
            cell = collectionView.dequeueReusableCellWithReuseIdentifier("AddressCell", forIndexPath: indexPath)
            break;
        }
        
        return cell!;
    }
    
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        collectionView.deselectItemAtIndexPath(indexPath, animated: true)
        
        if indexPath.section == 0 {
            return;
        }
        
        let userAddr = self.itemsArray[indexPath.row] as? UserAddress

        Helper
        .sharedInstance.saveToUserDefaults(forKey: Constants.UserdefaultConstants.LastSelectedAddressId, value: (userAddr?.addressId)!)
        Helper.sharedInstance.order?.addressId = (userAddr?.addressId)!
        
        self.dismissViewController()

    }
    
    func dismissViewAfterAddingAddress(){
        self.dismissViewController()

    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.collectionView.collectionViewLayout.invalidateLayout()
    }
}