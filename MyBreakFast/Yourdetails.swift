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
        
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.endEditing(true)
        return true
    }
    
    
    @IBAction func addorChangeAddress(sender: UIButton) {
        sender.sendAction("showAddAddressVC", to: nil, forEvent: nil)
    }
    
}