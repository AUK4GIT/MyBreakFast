//
//  Yourdetails.swift
//  MyBreakFast
//
//  Created by Uday Kiran Ailapaka on 22/11/15.
//  Copyright © 2015 AUK. All rights reserved.
//

import Foundation
class Yourdetails: UICollectionViewCell {
    
    
    @IBOutlet weak var firstLine: UILabel!
    @IBOutlet weak var secondLine: UITextField!
    @IBOutlet weak var locationButton: UIButton!
    @IBOutlet weak var addChnageButton: UIButton!
    
    var i: Int = 0
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let userLoginStatus = Helper.sharedInstance.getDataFromUserDefaults(forKey: Constants.UserdefaultConstants.UserLoginStatus) as? Bool

        if (userLoginStatus != nil) {
//            self.fetchAddressess();
        }
        self.firstLine.text = Helper.sharedInstance.userLocation;
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override func prepareForReuse() {
        
    }
    
//    func fetchAddressess() {
//        if i==2 { return;}
//        i++;
//        Helper.sharedInstance.fetchUserAddressess { (response) -> () in
//            let responseStatus = (response as? String) ?? ""
//            if responseStatus == "ERROR"{
//                self.fetchAddressess();
//            } else {
//                
//                let responseStat = (response as? [AnyObject]) ?? []
//                for obj in responseStat {
//                    if let dict = obj as? NSDictionary {
//                        let userAddressObj = Helper.sharedInstance.getUserAddressObject() as? UserAddress
//                    
//                        if let obj = dict.objectForKey("address_id") as? NSNumber{
//                            userAddressObj?.addressId = obj.stringValue
//                        } else {
//                            userAddressObj?.addressId = dict.objectForKey("address_id") as? String;
//                        }
//                    
//                        let dictionary = dict.objectForKey("addresses")
//                        userAddressObj?.lineone = dictionary!.objectForKey("0") as? String;
//                        userAddressObj?.linetwo = dictionary!.objectForKey("1") as? String;
//                        userAddressObj?.category = dictionary!.objectForKey("category") as? String;
//                        userAddressObj?.cluster = dictionary!.objectForKey("cluster") as? String;
//                        Helper.sharedInstance.saveContext()
//                        Helper.sharedInstance.order?.addressId = userAddressObj?.addressId
//                        self.firstLine.text = userAddressObj?.lineone;
//                        self.secondLine.text = userAddressObj?.linetwo;
//                        //self.secondLine.enabled = false;
//                        self.activity?.stopAnimating()
//                    } else {
//                        //self.secondLine.enabled = true;
//                        self.activity?.stopAnimating()
//                    }
//                }
//            }
//        }
//    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.endEditing(true)
        return true
    }
    
    
    @IBAction func addorChangeAddress(sender: UIButton) {
        
        sender.sendAction("showAddAddressVC", to: nil, forEvent: nil)
        return;
        
        let dict: [String:String] = ["line1":self.firstLine.text!,"line2":self.secondLine.text!,"line3":"Gurgoan","category":"Home"];
//         self.activity?.startAnimating()
        Helper.sharedInstance.uploadAddress(dict) { (response) -> () in
//             self.activity?.stopAnimating()
            let responseStatus = (response as? String) ?? ""
            if responseStatus == "ERROR"{
                UIAlertView(title: "First Eat", message: "Error adding address. Try again.", delegate: nil, cancelButtonTitle: "OK").show()
            } else {
                if let dict = response as? NSDictionary {
                    if let addid = dict.objectForKey("address_id") as? NSNumber{
                        Helper.sharedInstance.order?.addressId = addid.stringValue;
                    } else {
                        Helper.sharedInstance.order?.addressId =  dict.objectForKey("address_id") as? String
                    }
                }
            }
        }
    }
    
}