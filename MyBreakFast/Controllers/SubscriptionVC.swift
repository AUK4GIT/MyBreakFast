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
        print(dietician.firstName);
        return cell!;
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        UIApplication.sharedApplication().sendAction(#selector(SubscriptionVC.setSelectionLabel), to: nil, from: collectionView, forEvent: nil);
    }

}

class SubscriptionVC: UIViewController {
    
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var dieticiansList: UICollectionView!
    @IBOutlet var planImageView: UIImageView!
    let dieticiansDataSource = DieticiansDatasource();
    var plansList: [RegularPlan]?;
    @IBOutlet var mealPlanLabel: UILabel!

    @IBOutlet var customizedSubscrTable: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.customizedSubscrTable.hidden = true;
        self.dieticiansList.delegate = dieticiansDataSource;
        self.dieticiansList.dataSource = dieticiansDataSource;
        
        Helper.sharedInstance.getSubscriptionRegularPlan { (response) in
            if let json = response as? NSDictionary {
                Helper.sharedInstance.subscription = Subscription()
                Helper.sharedInstance.subscription?.saveData(json)
                self.dieticiansDataSource.dieticiansList = Helper.sharedInstance.subscription?.dieticians
                self.plansList = Helper.sharedInstance.subscription?.regplans
                self.dieticiansList.reloadData()
                self.collectionView.reloadData()
                
                let indexPath = NSIndexPath(forItem: 0, inSection: 0)
                self.collectionView.selectItemAtIndexPath(indexPath, animated: true, scrollPosition: .Left)
                self.dieticiansList.selectItemAtIndexPath(indexPath, animated: true, scrollPosition: .Left)

                self.setSelectionLabel()

                let regularPlan = self.plansList![indexPath.row]

                let url: String? = regularPlan.imageURL
                (url?.stringByAddingPercentEncodingWithAllowedCharacters( NSCharacterSet.URLQueryAllowedCharacterSet()))
                self.planImageView.sd_setImageWithURL(NSURL(string: url!), placeholderImage: UIImage(named: ""), completed: nil)

            }
        }
    }
    
    func setSelectionLabel(){
    
        let dIndexPath = self.dieticiansList.indexPathsForSelectedItems()![0]
        let pIndexPath = self.collectionView.indexPathsForSelectedItems()![0]

        let dietician = Helper.sharedInstance.subscription?.dieticians![dIndexPath.row]
        let regularPlan = self.plansList![pIndexPath.row]
        
        let dietcianname = (dietician?.firstName)!+" "+(dietician?.lastName)!
        self.mealPlanLabel.text = "You have selected the meal plan recommended by "+dietcianname+" to "+regularPlan.name!
        
        Helper.sharedInstance.subscription?.selectedPlanId = regularPlan.planId
        Helper.sharedInstance.subscription?.selectedDieticianId = dietician?.dieticianId
        
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
        let width: CGFloat = 100.0
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
        
        let regularPlan = self.plansList![indexPath.row]

        let url: String? = regularPlan.imageURL
        (url?.stringByAddingPercentEncodingWithAllowedCharacters( NSCharacterSet.URLQueryAllowedCharacterSet()))
        self.planImageView.sd_setImageWithURL(NSURL(string: url!), placeholderImage: UIImage(named: ""), completed: nil)
        
        self.setSelectionLabel();
        

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