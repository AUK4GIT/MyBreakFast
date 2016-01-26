//
//  OfferNotificationsVC.swift
//  MyBreakFast
//
//  Created by Uday Kiran Ailapaka on 07/01/16.
//  Copyright © 2016 AUK. All rights reserved.
//

import Foundation

class OfferNotificationsVC: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    var offersArray: NSArray = []
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.collectionView.
        
        let doneButton: UIButton = UIButton(type: .Custom)
        doneButton.frame = CGRectMake(0, 0, 60, 44)
        doneButton.setTitle("Done", forState: .Normal)
        doneButton.titleLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 18.0);
        doneButton.titleLabel?.adjustFontToRealIPhoneSize = true;
        doneButton.addTarget(self, action: "dismissController:", forControlEvents: .TouchUpInside)
        doneButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -20)
        
        self.navigationItem.title = "Offers";
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: doneButton)
        
        Helper.sharedInstance.getSpecialNotificationOffers { (response) -> () in
            
            if response as? String == "ERROR" {
                UIAlertView(title: "Error", message: "Please try again", delegate: nil, cancelButtonTitle: "OK").show()
            } else {
                if let offerArr = response["data"] as? NSArray{
                    self.offersArray = offerArr
                    self.collectionView.reloadData()
                } else {
                    UIAlertView(title: "First Eat", message: "Currently no offers available.", delegate: nil, cancelButtonTitle: "OK").show()
                }
            }

        }
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
       
    }
    @IBAction func dismissController(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    // MARK: UICollectionView delegates and datasources
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {

        if let cell = collectionView.cellForItemAtIndexPath(indexPath) {
            let label: UILabel = (cell.viewWithTag(5) as? UILabel)!
            var size = label.bounds.size
            size.width = cell.contentView.bounds.size.width
            return size;
        }
        
        return CGSizeMake(collectionView.bounds.size.width, 84);
    }
    
    
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.collectionView.collectionViewLayout.invalidateLayout()
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1;
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.offersArray.count;
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell: UICollectionViewCell = (collectionView.dequeueReusableCellWithReuseIdentifier("offerCell", forIndexPath: indexPath))
        cell.contentView.backgroundColor = UIColor.whiteColor()
        let label: UILabel = (cell.viewWithTag(5) as? UILabel)!
        let resDict = self.offersArray[indexPath.row] as? NSDictionary
        label.text = resDict!["content_text"] as? String
        return cell;
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        //        let modalVC : ItemPreViewVC = self.storyboard?.instantiateViewControllerWithIdentifier("ItemPreViewVC") as! ItemPreViewVC
        //        let item : Item = self.itemsArray[indexPath.item] as! Item
        //
        //        modalVC.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext
        //        self.presentViewController(modalVC, animated: true, completion: nil)
        //        modalVC.imageView.sd_setImageWithURL(NSURL(string: item.imageURL!), placeholderImage: UIImage(named: "menu_logo"), completed: nil)
        //        modalVC.descriptionView.text = item.itemDescription
    }

}