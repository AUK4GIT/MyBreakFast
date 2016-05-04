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
        self.addSubview(self.activity!);
        self.activity?.color = Constants.StaticContent.AppThemeColor;
        self.activity?.hidesWhenStopped = true;
        self.activity?.translatesAutoresizingMaskIntoConstraints = false;

        if let usrLoc = Helper.sharedInstance.userLocation {
            self.locationButton.setTitle(usrLoc, forState: UIControlState.Normal)
        }

        self.addConstraint(NSLayoutConstraint(item: self.activity!, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.CenterX, multiplier: 1.0, constant: 0.0));
        self.addConstraint(NSLayoutConstraint(item: self.activity!, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.CenterY, multiplier: 1.0, constant: 0.0));

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

        let dict: [String:String] = ["line1":self.secondLine.text!,"line2":lineOne!,"line3":"Gurgoan","category":"Home","cluster":cluster!];
            self.activity?.startAnimating()

        Helper.sharedInstance.uploadAddress(dict) { (response) -> () in
            
            let responseStatus = (response as? String) ?? ""
            if responseStatus == "ERROR"{
                UIAlertView(title: "First Eat", message: "Error adding address. Try again.", delegate: nil, cancelButtonTitle: "OK").show()
            } else {
                if let dict = response as? NSDictionary {
                    
                    let userAddressObj = Helper.sharedInstance.getUserAddressObject() as? UserAddress
                    userAddressObj?.lineone = self.secondLine.text!;
                    userAddressObj?.linetwo = lineOne!;
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
                    UIApplication.sharedApplication().sendAction(#selector(AddAddressVC.dismissViewAfterAddingAddress), to: nil, from: self, forEvent: nil);
                }
            }
            self.activity?.stopAnimating()
        }
    }
    
}