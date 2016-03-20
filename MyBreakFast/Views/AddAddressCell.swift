//
//  AddAddressCell.swift
//  MyBreakFast
//
//  Created by Uday Kiran Ailapaka on 17/01/16.
//  Copyright © 2016 AUK. All rights reserved.
//

import Foundation
class AddAddressCell: UICollectionViewCell {
    
    
    @IBOutlet  var secondLine: UITextView!
    @IBOutlet  var locationButton: UIButton!
    @IBOutlet  var addChnageButton: UIButton!
    var activity: UIActivityIndicatorView?

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.activity = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
        self.activity?.frame = CGRectMake(0, 0, 50, 50);
        self.activity?.center = CGPointMake(self.bounds.width/2, self.bounds.height/2);
        self.addSubview(self.activity!);
        self.activity?.color = Constants.StaticContent.AppThemeColor;
//        self.activity?.startAnimating()
        self.activity?.hidesWhenStopped = true;
        
        if let usrLoc = Helper.sharedInstance.userLocation {
            self.locationButton.setTitle(usrLoc, forState: UIControlState.Normal)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.endEditing(true)
        return true
    }
    
    @IBAction func showLocationPicker(sender: UIButton) {
//        sender.sendAction("showLocationPicker:", to: nil, forEvent: nil)
    }
    
    @IBAction func addorChangeAddress(sender: UIButton) {
        
        if self.secondLine.text.characters.count == 0 {
            UIAlertView(title: "First Eat", message: "Address field cannot be empty.", delegate: nil, cancelButtonTitle: "OK").show()

            return;
        }
        
        let lineOne = Helper.sharedInstance.userLocation
        
        let locId = Helper.sharedInstance.getDataFromUserDefaults(forKey: Constants.UserdefaultConstants.LastSelectedLocationId) as? String ?? ""
        let cluster = Helper.sharedInstance.fetchClusterFromLocationForId(locId);

        let dict: [String:String] = ["line1":lineOne!,"line2":self.secondLine.text!,"line3":"Gurgoan","category":"Home","cluster":cluster!];
            self.activity?.startAnimating()
        Helper.sharedInstance.uploadAddress(dict) { (response) -> () in
            
            let responseStatus = (response as? String) ?? ""
            if responseStatus == "ERROR"{
                UIAlertView(title: "First Eat", message: "Error adding address. Try again.", delegate: nil, cancelButtonTitle: "OK").show()
            } else {
                if let dict = response as? NSDictionary {
                    
                    let userAddressObj = Helper.sharedInstance.getUserAddressObject() as? UserAddress
                    userAddressObj?.lineone = lineOne!;
                    userAddressObj?.linetwo = self.secondLine.text!;
                    userAddressObj?.category = "Home";
                    userAddressObj?.cluster = "Gurgoan";
                    
                    if let addid = dict.objectForKey("address_id") as? NSNumber{
                        Helper.sharedInstance.order?.addressId = addid.stringValue;
                        userAddressObj?.addressId = addid.stringValue
                        Helper.sharedInstance.saveToUserDefaults(forKey: Constants.UserdefaultConstants.LastSelectedAddressId, value: addid.stringValue)
                        Helper.sharedInstance.saveContext()

                    } else {
                        let addrId = dict.objectForKey("address_id") as? String
                        Helper.sharedInstance.order?.addressId =  addrId
                        userAddressObj?.addressId = addrId
                        Helper.sharedInstance.saveToUserDefaults(forKey: Constants.UserdefaultConstants.LastSelectedAddressId, value: addrId!)
                        Helper.sharedInstance.saveContext()

                    }
                    UIApplication.sharedApplication().sendAction("dismissViewAfterAddingAddress", to: nil, from: self, forEvent: nil);
                }
            }
            self.activity?.stopAnimating()
        }
    }
    
}