//
//  OrderStatusVC.swift
//  MyBreakFast
//
//  Created by Uday Kiran Ailapaka on 02/11/15.
//  Copyright © 2015 AUK. All rights reserved.
//

import Foundation
import UIKit

class OrderStatusVC: UIViewController {
    @IBOutlet weak var orderId: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var orderedAt: UILabel!
    @IBOutlet weak var orderDate: UILabel!
    @IBOutlet weak var orderTime: UILabel!
    @IBOutlet weak var orderAmount: UILabel!
    let dateFormatter = NSDateFormatter()
    let dayFormatter = NSDateFormatter()
    let timeFormatter = NSDateFormatter()
    
    @IBOutlet weak var successLabel: UILabel!
    override func beginAppearanceTransition(isAppearing: Bool, animated: Bool) {
        super.beginAppearanceTransition(isAppearing, animated: animated)
        if isAppearing {
            let fadeTextAnimation: CATransition = CATransition();
            fadeTextAnimation.duration = 0.5;
            fadeTextAnimation.type = kCATransitionFade;
            
            let parentVC: ViewController = self.parentViewController as! ViewController
            parentVC.containerNavigationItem.leftBarButtonItem?.image = UIImage(named: "back.png");
            parentVC.containerNavigationItem.leftBarButtonItem?.action = "backToMenu";
            parentVC.setNavBarTitle("Order status")
            parentVC.containerNavigationBar.layer.addAnimation(fadeTextAnimation, forKey: "fadeText");
        }
    }
    override func endAppearanceTransition() {
        super.endAppearanceTransition()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dateFormatter.dateFormat = "YYYY-MM-DD"
        self.dayFormatter.dateFormat = "EEE MMM DD,  YYYY"
        self.timeFormatter.dateFormat = "hh:mm a"
        
        self.orderId.text = "Order ID: "+(Helper.sharedInstance.order?.orderId)!
    }
    
    func setData(dict: NSDictionary){
        let orderDict = dict.objectForKey("data")
        var addressDict: NSDictionary?

        if let addrDictArray = orderDict?.objectForKey("address") as? NSArray {
            addressDict = addrDictArray.count>0 ? addrDictArray[0]["address"] as? NSDictionary : nil
        }
        
        let lineOne = addressDict?.objectForKey("address_line_one") as? String ?? ""
        let lineTwo = addressDict?.objectForKey("address_line_two") as? String ?? ""

        let lineThree = addressDict?.objectForKey("address_line_three") as? String ?? ""

        
        self.address.text = lineOne+" "+lineTwo+" "+lineThree
        self.status.text = "Ordered"
        self.status.textColor = UIColor(red: 200.0/255.0, green: 15.0/255.0, blue: 5.0/255.0, alpha: 1.0)

        let date = self.dateFormatter.dateFromString(Helper.sharedInstance.orderDate!)
        let dateStr = dayFormatter.stringFromDate(date!)
        self.orderedAt.text = "Ordered at: "
        self.orderDate.text = dateStr;
        self.orderAmount.text = "₹ "+(Helper.sharedInstance.order?.totalAmountPayable)!
        
        if let timeSlotObj = Helper.sharedInstance.fetchTimeSlotObjectForId() {
            let timeFormtter = NSDateFormatter()
            timeFormtter.dateFormat = "HH:mm:ss"
            timeFormtter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
            let startTime = timeFormtter.dateFromString(timeSlotObj.starttime!);
            let endTime = timeFormtter.dateFromString(timeSlotObj.endtime!);
            timeFormtter.dateFormat = "hh:mm a"
            self.orderTime.text = timeFormtter.stringFromDate(startTime!)+" - "+timeFormtter.stringFromDate(endTime!)

        }
        
        self.orderTime.text = ""

           }
    
    @IBAction func gotomenu(sender: AnyObject) {
        let parentVC = self.parentViewController as! ViewController
        parentVC.cycleFromViewController(nil, toViewController: (self.storyboard?.instantiateViewControllerWithIdentifier("MenuVC"))!)
    }
    
    @IBAction func gotoMyOrders(sender: AnyObject) {
        let parentVC = self.parentViewController as! ViewController
        parentVC.cycleFromViewController(nil, toViewController: (self.storyboard?.instantiateViewControllerWithIdentifier("MyOrdersVC"))!)
    }

}