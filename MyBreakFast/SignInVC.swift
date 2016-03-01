//
//  SignInVC.swift
//  MyBreakFast
//
//  Created by Uday Kiran Ailapaka on 31/10/15.
//  Copyright © 2015 AUK. All rights reserved.
//

import Foundation
import UIKit

class SignInVC: UIViewController {
    
//    var placesClient: GMSPlacesClient?

    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate: AppDelegate =  UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.performSelector("loadMainView", withObject: nil, afterDelay: 2.0)
    }
    
    

       // MARK: UITextField Delegates
    
     func textFieldDidBeginEditing(textField: UITextField) {
        
        UIView.animateWithDuration(0.3, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
//            self.horizantalCenterConstraint.constant = -100;
//            self.view.layoutIfNeeded()

            }, completion: nil)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
//        self.emailTextField.resignFirstResponder()
        return true
    }

    
     func textFieldDidEndEditing(textField: UITextField) {
    
        UIView.animateWithDuration(0.3, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
//            self.horizantalCenterConstraint.constant = 0;
//            self.view.layoutIfNeeded()
            }) { (Bool) -> Void in
//                self.validateEmailId();
            }
    }
}