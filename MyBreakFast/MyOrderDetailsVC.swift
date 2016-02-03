//
//  MyOrderDetailsVC.swift
//  MyBreakFast
//
//  Created by Uday Kiran Ailapaka on 11/01/16.
//  Copyright © 2016 AUK. All rights reserved.
//

import Foundation

class MyOrderDetailsVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var addrineOne: UILabel!
    @IBOutlet weak var addrineTwo: UILabel!
    @IBOutlet weak var addrineThree: UILabel!
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var time: UILabel!

    @IBOutlet weak var subtotal: UILabel!
    @IBOutlet weak var vat: UILabel!
    @IBOutlet weak var surcharge: UILabel!
    @IBOutlet weak var shipping: UILabel!
    @IBOutlet weak var discount: UILabel!
    @IBOutlet weak var ordertotal: UILabel!
    
    var orderDetails: NSMutableArray = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let doneButton: UIButton = UIButton(type: .Custom)
        doneButton.frame = CGRectMake(0, 0, 60, 44)
        doneButton.setTitle("Done", forState: .Normal)
        doneButton.titleLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 17.0);
        doneButton.titleLabel?.adjustFontToRealIPhoneSize = true;
        doneButton.addTarget(self, action: "dismissViewController", forControlEvents: .TouchUpInside)
        doneButton.titleEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0)
        
        self.navigationItem.title = "MyOrder";
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: doneButton)
        
//        self.tableView.registerClass(MyOrdersDetailsCell.self, forCellReuseIdentifier: "MyOrdersDetailsCell")
        self.tableView.registerNib(UINib(nibName: "MyOrdersDetailsCell", bundle: nil), forCellReuseIdentifier: "MyOrdersDetailsCell")

    }
    
    func dismissViewController(){
        self.dismissViewControllerAnimated(true, completion: nil);
    }
    
    func setDetails(dict: NSDictionary, addressDict: NSDictionary?){
    
        let dateFormatter = NSDateFormatter()
        let dayFormatter = NSDateFormatter()
        let timeFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dayFormatter.dateFormat = "EEE MMM dd,  yyyy"
        timeFormatter.dateFormat = "hh:mm a"
        timeFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")

        if let discountval = dict.objectForKey("discount") as? NSNumber {
            self.discount.text =  "₹ "+discountval.stringValue;
        } else {
            self.discount.text =  "₹ "+(dict.objectForKey("discount") as? String)!
        }
        
        if let sub_total = dict.objectForKey("sub_total") as? NSNumber {
            self.subtotal.text =  "₹ "+sub_total.stringValue;
        } else {
            self.subtotal.text =  "₹ "+(dict.objectForKey("sub_total") as? String)!
        }
        
        if let surcharge = dict.objectForKey("surcharge") as? NSNumber {
            self.surcharge.text =  "₹ "+surcharge.stringValue;
        } else {
            self.surcharge.text =  "₹ "+(dict.objectForKey("surcharge") as? String)!
        }
        
        if let total_amount = dict.objectForKey("total_amount") as? NSNumber {
            self.ordertotal.text =  "₹ "+total_amount.stringValue;
        } else {
            self.ordertotal.text =  "₹ "+(dict.objectForKey("total_amount") as? String)!
        }
        
        if let vat = dict.objectForKey("vat") as? NSNumber {
            self.vat.text =  "₹ "+vat.stringValue;
        } else {
            self.vat.text =  "₹ "+(dict.objectForKey("vat") as? String)!
        }
        
        if let discountval = dict.objectForKey("discount") as? NSNumber {
            self.discount.text =  "₹ "+discountval.stringValue;
        } else {
            self.discount.text =  "₹ "+(dict.objectForKey("discount") as? String)!
        }
        
        self.shipping.text = "₹ "+"0"
        
        if let orderDictArray = dict.objectForKey("orderStatuses") as? NSArray {
            let orderStatusDict = orderDictArray.lastObject as? NSDictionary
            let status = orderStatusDict?.objectForKey("order_status") as? String
            if status == "Pending"{
                self.status.textColor = UIColor.redColor();
            } else if status == "Delivered"{
                self.status.textColor = UIColor(red: 0, green: 128.0/255.0, blue: 0, alpha: 1.0)
            } else if status == "Dispatched"{
                self.status.textColor = UIColor(red: 1.0, green: 0, blue: 1.0, alpha: 1.0)
            } else {
                self.status.textColor = UIColor.blueColor();
            }
            self.status.text = orderStatusDict?.objectForKey("order_status") as? String
            
            let date = dateFormatter.dateFromString((orderStatusDict!.objectForKey("status_date") as? String)!)
            
            self.date.text = dayFormatter.stringFromDate(date!)
            self.time.text = timeFormatter.stringFromDate(date!)
            
        }
        
        if addressDict != nil{
        self.addrineOne.text = addressDict?.objectForKey("address_line_one") as? String
            self.addrineOne.text = addressDict?.objectForKey("address_line_one") as? String
            self.addrineTwo.text = addressDict?.objectForKey("address_line_two") as? String
            self.addrineThree.text = addressDict?.objectForKey("address_line_three") as? String
        }
        
        if let ordid = dict.objectForKey("id") as? NSNumber {
            self.getContentForItemId(ordid.stringValue);
        } else {
            self.getContentForItemId((dict.objectForKey("id") as? String)!);
        }

    }
    
    func getContentForItemId(itemId: String){
        Helper.sharedInstance.getItemDetailsForId(itemId) { (response) -> Void in
//            self.activity?.stopAnimating()
            
            let responseStatus = (response as? String) ?? ""
            if responseStatus == "ERROR" {
                UIAlertView(title: "Error!", message: "Please try again.", delegate: nil, cancelButtonTitle: "OK").show()
                
            } else {
                let responseS = (response as? NSDictionary)
                let responsestatus = responseS?.objectForKey("data")
                
                if let meuArray = responsestatus?.objectForKey("menu_details") as? NSArray{
                    self.orderDetails.addObjectsFromArray(meuArray as! [NSDictionary])
                }
                if let meuArray = responsestatus?.objectForKey("offers") as? NSArray{
                    self.orderDetails.addObjectsFromArray(meuArray as! [NSDictionary])
                }
               
                let orArray = self.orderDetails.filteredArrayUsingPredicate(NSPredicate(block: { (dict, _: [String : AnyObject]?) -> Bool in
                    print(dict.objectForKey("menu"));
                    if let _ = dict.objectForKey("menu") as? NSDictionary {
                        return true;
                    } else {
                        return false;
                    }
                }))
                self.orderDetails = NSMutableArray(array: orArray);
                
//                self.setDetails((responsestatus?.objectForKey("order"))! as! NSDictionary, addressDict: (responsestatus?.objectForKey("address"))! as! NSDictionary)
            }
            self.tableView.reloadData()
        }
        
    }
    
    
    func setOrderDetailsFromConfirmationDetails(dict: NSDictionary, addressDict: NSDictionary?){
        
        let dateFormatter = NSDateFormatter()
        let dayFormatter = NSDateFormatter()
        let timeFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dayFormatter.dateFormat = "EEE MMM dd,  yyyy"
        timeFormatter.dateFormat = "hh:mm a"
        
        if let discountval = dict.objectForKey("discount") as? NSNumber {
            self.discount.text =  "₹ "+discountval.stringValue;
        } else {
            self.discount.text =  "₹ "+(dict.objectForKey("discount") as? String)!
        }
        
        if Helper.sharedInstance.order?.hasRedeemedPoints == true {
            let discount: String = (Helper.sharedInstance.order?.discount)!
            self.discount.text =  "₹ \(discount)"
        }
        
        if let sub_total = dict.objectForKey("sub_total") as? NSNumber {
            self.subtotal.text =  "₹ "+sub_total.stringValue;
        } else {
            self.subtotal.text =  "₹ "+(dict.objectForKey("sub_total") as? String)!
        }
        
        if let surcharge = dict.objectForKey("surcharge") as? NSNumber {
            self.surcharge.text =  "₹ "+surcharge.stringValue;
        } else {
            self.surcharge.text =  "₹ "+(dict.objectForKey("surcharge") as? String)!
        }
        
        if let total_amount = dict.objectForKey("total_amount") as? NSNumber {
            self.ordertotal.text =  "₹ "+total_amount.stringValue;
        } else {
            self.ordertotal.text =  "₹ "+(dict.objectForKey("total_amount") as? String)!
        }
        
        if let vat = dict.objectForKey("vat") as? NSNumber {
            self.vat.text =  "₹ "+vat.stringValue;
        } else {
            self.vat.text =  "₹ "+(dict.objectForKey("vat") as? String)!
        }
        
//        if let discountval = dict.objectForKey("discount") as? NSNumber {
//            self.discount.text =  "₹ "+discountval.stringValue;
//        } else {
//            self.discount.text =  "₹ "+(dict.objectForKey("discount") as? String)!
//        }
        
        self.shipping.text = "₹ "+"0"
        
        if let orderDictArray = dict.objectForKey("orderStatuses") as? NSArray {
            let orderStatusDict = orderDictArray.lastObject as? NSDictionary
            let status = orderStatusDict?.objectForKey("order_status") as? String
            if status == "Pending"{
                self.status.textColor = UIColor.redColor();
            } else if status == "Delivered"{
                self.status.textColor = UIColor(red: 0, green: 128.0/255.0, blue: 0, alpha: 1.0)
            } else if status == "Dispatched"{
                self.status.textColor = UIColor(red: 1.0, green: 0, blue: 1.0, alpha: 1.0)
            } else {
                self.status.textColor = UIColor.blueColor();
            }
            self.status.text = orderStatusDict?.objectForKey("order_status") as? String
            
            let date = dateFormatter.dateFromString((orderStatusDict!.objectForKey("status_date") as? String)!)
            
            self.date.text = dayFormatter.stringFromDate(date!)
            self.time.text = timeFormatter.stringFromDate(date!)
            
        }
        
        if addressDict != nil{
            self.addrineOne.text = addressDict?.objectForKey("address_line_one") as? String
            self.addrineOne.text = addressDict?.objectForKey("address_line_one") as? String
            self.addrineTwo.text = addressDict?.objectForKey("address_line_two") as? String
            self.addrineThree.text = addressDict?.objectForKey("address_line_three") as? String
        }
        
//        if let ordid = dict.objectForKey("id") as? NSNumber {
//            self.getContentForItemId(ordid.stringValue);
//        } else {
//            self.getContentForItemId((dict.objectForKey("id") as? String)!);
//        }
        
    }
    
    func getOrderDetailsFromConfirmationScreenForItemId(itemId: String){
        Helper.sharedInstance.getItemDetailsForId(itemId) { (response) -> Void in
            //            self.activity?.stopAnimating()
            
            let responseStatus = (response as? String) ?? ""
            if responseStatus == "ERROR" {
                UIAlertView(title: "Error!", message: "Please try again.", delegate: nil, cancelButtonTitle: "OK").show()
                
            } else {
                let responseS = (response as? NSDictionary)
                let responsestatus = responseS?.objectForKey("data")
                
                if let meuArray = responsestatus?.objectForKey("menu_details") as? NSArray{
                    self.orderDetails.addObjectsFromArray(meuArray as! [NSDictionary])
                }
                if let meuArray = responsestatus?.objectForKey("offers") as? NSArray{
                    self.orderDetails.addObjectsFromArray(meuArray as! [NSDictionary])
                }
                
                self.setOrderDetailsFromConfirmationDetails((responsestatus?.objectForKey("order"))! as! NSDictionary, addressDict: (responsestatus?.objectForKey("address"))! as? NSDictionary)
            }
            self.tableView.reloadData()
        }
        
    }
    
    
    // MARK: Tableview delegates & datasources
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.orderDetails.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        
        let cell:MyOrdersDetailsCell =
        (tableView.dequeueReusableCellWithIdentifier("MyOrdersDetailsCell") as? MyOrdersDetailsCell)!

        let dict = self.orderDetails[indexPath.row] as? NSDictionary
        
        if let menu = dict?.objectForKey("menu") as? NSDictionary{
            
                if let menuid = menu.objectForKey("item_name") as? NSNumber {
                    cell.customtextLabel?.text = "Item name: "+menuid.stringValue
                } else {
                    cell.customtextLabel?.text = "Item name: "+(menu.objectForKey("item_name") as? String)!
                }
                if let menuid = dict?.objectForKey("qty") as? NSNumber {
                    cell.customdetailTextLabel?.text = "Quantity: "+menuid.stringValue
                } else {
                    cell.customdetailTextLabel?.text = "Quantity: "+(dict?.objectForKey("qty") as? String)!
                }
                if let menuid = menu.objectForKey("price") as? NSNumber {
                    cell.amountLabel?.text = "₹ "+menuid.stringValue
                } else {
                    cell.amountLabel?.text = "₹ "+(menu.objectForKey("price") as? String)!
                }

        
        } else if let dict = dict?.objectForKey("offer") as? NSDictionary {
        

            if let menuid = dict.objectForKey("offer_name") as? NSNumber {
                cell.customtextLabel?.text = "Offer name: "+menuid.stringValue
            } else {
                cell.customtextLabel?.text = "Offer name: "+(dict.objectForKey("offer_name") as? String)!
            }
            if let menuid = dict.objectForKey("qty") as? NSNumber {
                cell.customdetailTextLabel?.text = "Quantity: "+menuid.stringValue
            } else {
                cell.customdetailTextLabel?.text = "Quantity: "+(dict.objectForKey("qty") as? String)!
            }
            if let menuid = dict.objectForKey("price") as? NSNumber {
                cell.amountLabel?.text = "₹ "+menuid.stringValue
            } else {
                cell.amountLabel?.text = "₹ "+(dict.objectForKey("price") as? String)!
            }
        }

        
        cell.contentView.backgroundColor = UIColor.clearColor()
        cell.backgroundColor = UIColor.clearColor()

        return cell;
    }
}