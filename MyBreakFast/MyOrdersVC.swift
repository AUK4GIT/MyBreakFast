//
//  MyOrdersVC.swift
//  MyBreakFast
//
//  Created by Uday Kiran Ailapaka on 29/10/15.
//  Copyright © 2015 AUK. All rights reserved.
//

import Foundation
import UIKit

class MyOrdersVC: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    let dateFormatter = NSDateFormatter()
    let dayFormatter = NSDateFormatter()
    let timeFormatter = NSDateFormatter()
    var addressess: NSArray?
    var contentArray : NSArray = []
    var check : Int = 0;
    override func beginAppearanceTransition(isAppearing: Bool, animated: Bool) {
        super.beginAppearanceTransition(isAppearing, animated: animated)
        if isAppearing {
            let fadeTextAnimation: CATransition = CATransition();
            fadeTextAnimation.duration = 0.5;
            fadeTextAnimation.type = kCATransitionFade;
            
            let parentVC: ViewController = self.parentViewController as! ViewController
            parentVC.setNavBarTitle("Orders")
            parentVC.containerNavigationBar.layer.addAnimation(fadeTextAnimation, forKey: "fadeText");
        }
    }
    override func endAppearanceTransition() {
        super.endAppearanceTransition()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.registerNib(UINib(nibName: "MyOrderCell", bundle: nil), forCellReuseIdentifier: "MyOrderCell")
        self.tableView.rowHeight = 100.0;
        self.dateFormatter.dateFormat = "YYYY-MM-DD HH:mm:ss"
        self.dayFormatter.dateFormat = "EEE MMM DD,  YYYY"
        self.timeFormatter.dateFormat = "hh:mm a"
//        self.addressess = Helper.sharedInstance.getUserAddresses()
        self.tableView.contentInset = UIEdgeInsetsMake(20, 0, 0, 0)
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
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
            
            if check > 0{return; } else{ check++;}
            
            Helper.sharedInstance.getMyOrders() { (response) -> () in
                
                if let responseObj = response as? NSDictionary {
                    self.addressess = responseObj.objectForKey("addresses") as? NSArray;
                    let contentArr = responseObj.objectForKey("data") as? NSArray
                    if contentArr != nil {
                    self.contentArray = contentArr!
                    let dateFormatter = NSDateFormatter()
                    dateFormatter.dateFormat = "YYYY-MM-DD HH:mm:ss"
                    dateFormatter.locale = NSLocale(localeIdentifier: "en_US")
                    self.contentArray = self.contentArray.sortedArrayUsingComparator({ (dict1, dict2) -> NSComparisonResult in
                        print(dict1["ordered_at"], dict2["ordered_at"]);
                        let date1 = dateFormatter.dateFromString((dict1["ordered_at"] as? String)!)
                        let date2 = dateFormatter.dateFromString((dict2["ordered_at"] as? String)!)

                        return (date2?.compare(date1!))!
                    })
//                    self.contentArray.sorted(self.contentArray, {
//                        (dict1: NSDictionary, dict2: NSDictionary) -> Bool in
////                        return str1.toInt() < str2.toInt()
//                    })
//                    self.contentArray.sort({ $0["ordered_at"].compare($1["ordered_at"]) == .OrderedAscending })

                    self.tableView.reloadData()
                    } else {
                        UIAlertView(title: "First Eat", message: "No Orders Found", delegate: nil, cancelButtonTitle: "OK").show()
                    }
                    
                } else {
                    UIAlertView(title: "First Eat", message: "No Orders Found", delegate: nil, cancelButtonTitle: "OK").show()
                }
                
            }

        }

    }
    
    // MARK: Tableview delegates & datasources
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        
        let vc: UINavigationController = self.storyboard?.instantiateViewControllerWithIdentifier("MyOrderDetails") as! UINavigationController
        self.presentViewController(vc, animated: true) { () -> Void in
            
            let orderdetailsVC: MyOrderDetailsVC = vc.topViewController as! MyOrderDetailsVC
            
            let orderDict = self.contentArray[indexPath.row] as? NSDictionary
            var addressDict: NSDictionary?
            
            if let addrDictArray = orderDict?.objectForKey("orderAddresses") as? NSArray {
                addressDict = addrDictArray.count>0 ? addrDictArray[0] as? NSDictionary : nil
            }

            let filtered = self.addressess?.filter({
                if let addid = addressDict?.objectForKey("address_id") as? String{
                    if let addrid = $0["id"] as? NSNumber {
                        return addrid  == Int(addid)
                    } else {
                        return $0["id"] as? String  == addid
                    }
                } else {
                    if let addrid = $0["id"] as? NSNumber {
                        return addrid  == addressDict?.objectForKey("address_id") as? NSNumber
                    } else {
                        return $0["id"] as? NSNumber  == addressDict?.objectForKey("address_id") as? NSNumber
                    }
                }
                
            })
            let addressDictionary : NSDictionary?
            if filtered?.count>0 {
                addressDictionary = filtered![0] as? NSDictionary
            } else {
                addressDictionary = nil
            }
            
            orderdetailsVC.setDetails(orderDict!, addressDict: addressDictionary)
        }
        

        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.contentArray.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell: MyOrderCell = tableView.dequeueReusableCellWithIdentifier("MyOrderCell")! as! MyOrderCell
        cell.backgroundColor = UIColor.clearColor()

        let orderDict = self.contentArray[indexPath.row] as? NSDictionary
        var addressDict: NSDictionary?
        var orderStatusDict: NSDictionary?
//        var detailsArray: NSArray?
        if let addrDictArray = orderDict?.objectForKey("orderAddresses") as? NSArray {
            addressDict = addrDictArray.count>0 ? addrDictArray[0] as? NSDictionary : nil
        }
//        if let addrDictArray = orderDict?.objectForKey("orderDetails") as? NSArray {
//            detailsArray = addrDictArray
//        }
        if let orderDictArray = orderDict?.objectForKey("orderStatuses") as? NSArray {
            orderStatusDict = orderDictArray.lastObject as? NSDictionary
        }
        let status = orderStatusDict?.objectForKey("order_status") as? String
        if status == "Pending"{
            cell.deliveryStatus.textColor = UIColor.redColor();
        } else if status == "Delivered"{
            cell.deliveryStatus.textColor = UIColor(red: 0, green: 128.0/255.0, blue: 0, alpha: 1.0)
        } else if status == "Dispatched"{
            cell.deliveryStatus.textColor = UIColor(red: 1.0, green: 0, blue: 1.0, alpha: 1.0)
        } else {
            cell.deliveryStatus.textColor = UIColor.blueColor();
        }
        cell.deliveryStatus.text = orderStatusDict?.objectForKey("order_status") as? String
        if let orderId = orderStatusDict?.objectForKey("order_id") as? NSNumber {
            cell.orderId.text = "Order ID: "+orderId.stringValue
        } else {
            cell.orderId.text = "Order ID: "+((orderStatusDict?.objectForKey("order_id"))! as! String)
        }
        let date = dateFormatter.dateFromString((orderStatusDict!.objectForKey("status_date") as? String)!)

        cell.dateLabel.text = "Ordered at: "+self.dayFormatter.stringFromDate(date!)
        cell.timeLabel.text = self.timeFormatter.stringFromDate(date!)
        cell.totalLabel.text = "₹ \(orderDict?.objectForKey("total_amount"))"
        if let totalAmt = orderDict?.objectForKey("total_amount") as? NSNumber {
            cell.totalLabel.text = "₹ \(totalAmt.stringValue)"
        } else {
            cell.totalLabel.text = "₹ \(orderDict?.objectForKey("total_amount") as! String)"
        }
        let filtered = self.addressess?.filter({
            if let addid = addressDict?.objectForKey("address_id") as? String{
                if let addrid = $0["id"] as? NSNumber {
                    return addrid  == Int(addid)
                } else {
                    return $0["id"] as? String  == addid
                }
            } else {
                if let addrid = $0["id"] as? NSNumber {
                    return addrid  == addressDict?.objectForKey("address_id") as? NSNumber
                } else {
                    return $0["id"] as? NSNumber  == addressDict?.objectForKey("address_id") as? NSNumber
                }
            }
            
        })
        if filtered?.count>0 {
            let addressObj = filtered![0] as? NSDictionary
            let lineOne = addressObj!["address_line_one"] as? String ?? " ---------"
            cell.addressLabel.text = Helper.sharedInstance.getUserName()+" "+lineOne
        } else {
            cell.addressLabel.text = Helper.sharedInstance.getUserName()+" "+" ---------"
        }

        return cell
    }

}