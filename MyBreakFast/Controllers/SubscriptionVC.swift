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
        return 5;
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("diticiancell", forIndexPath: indexPath)
        return cell;
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
    }

}

class SubscriptionVC: UIViewController {
    
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var dieticiansList: UICollectionView!
    let dieticiansDataSource = DieticiansDatasource();

    @IBOutlet var customizedSubscrTable: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.customizedSubscrTable.hidden = true;
        self.dieticiansList.delegate = dieticiansDataSource;
        self.dieticiansList.dataSource = dieticiansDataSource;
        self.dieticiansList.reloadData()
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
        let parentVC = self.parentViewController?.parentViewController as! ViewController
        parentVC.cycleFromViewController(nil, toViewController: (self.storyboard?.instantiateViewControllerWithIdentifier("SubscriptionDetailsVC"))!)
    }
    
    // MARK: UICollectionView delegates and datasources
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let width: CGFloat = 140.0
        let height: CGFloat = self.collectionView.bounds.size.height
        return CGSizeMake(width, height);
    }
    func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath)   {
    }
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1;
    }
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5;
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("plancell", forIndexPath: indexPath)
        return cell;
    }
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
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