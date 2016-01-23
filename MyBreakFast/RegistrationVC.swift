//
//  RegistrationVC.swift
//  MyBreakFast
//
//  Created by Uday Kiran Ailapaka on 25/12/15.
//  Copyright © 2015 AUK. All rights reserved.
//

import Foundation

class RegistrationVC: UIViewController {
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var newPasswordField: UITextField!
    @IBOutlet weak var confirmPasswordField: UITextField!
    @IBOutlet weak var phonenumberField: UITextField!
    @IBOutlet weak var referralField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    var userObj: UserDetails?
    var isEditing: Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.isEditing = false;
//        self.loginButton.layer.cornerRadius = 12.0;
        self.userObj = Helper.sharedInstance.getUserDetailsObj() as? UserDetails
    }
    @IBAction func dismissViewController(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func setAfterLoginSettings(emailid: String, password: String){
        self.emailField.text = emailid;
        self.newPasswordField.text = password;
        self.confirmPasswordField.text = password;
        
        self.emailField.enabled = false;
        self.newPasswordField.enabled = false;
        self.confirmPasswordField.enabled = false;
        
        UIAlertView(title: "Registration", message: "Please enter Username and Phone number.", delegate: nil, cancelButtonTitle: "OK").show()
    }
    
    func setAfterFaceBookLoginSettings(){
        self.emailField.text = Helper.sharedInstance.getUserEmailId();
        self.usernameField.text = Helper.sharedInstance.getUserName();

        self.emailField.enabled = false;
        self.referralField.enabled = false;
        
        UIAlertView(title: "Registration", message: "Please set Password and Phone number.", delegate: nil, cancelButtonTitle: "OK").show()
    }
    
    @IBAction func registerAction(sender: AnyObject) {
        self.isEditing = false;
        self.view.endEditing(true)
        
        if validateAllFields() {
            self.userObj?.userName = self.usernameField.text;
            self.userObj?.emailId = self.emailField.text;
            self.userObj?.phoneNumber = self.phonenumberField.text;
            self.userObj?.address = Helper.sharedInstance.userLocation;
            
            if self.referralField.text?.characters.count == 0{
                self.referralField.text = "";
            }
            
            Helper.sharedInstance.doUserRegistration(self.userObj!,password: self.newPasswordField.text!, referralId: self.referralField.text!, completionHandler: { (response) -> () in
                let responseStatus = (response as? String) ?? ""
                if responseStatus == "ERROR" {
                    UIAlertView(title: "Registration Unsuccessful!", message: "Please try again.", delegate: nil, cancelButtonTitle: "OK").show()

                } else {
                    Helper.sharedInstance.saveToUserDefaults(forKey: Constants.UserdefaultConstants.UserRegistration, value: true)
                    self.dismissViewControllerAnimated(true, completion: { () -> Void in
                    })
                }
            })
        }
    }
    
    func validateAllFields()->Bool {
        if self.emailField.text?.characters.count == 0 || self.usernameField.text?.characters.count == 0 || self.newPasswordField.text?.characters.count == 0 || self.confirmPasswordField.text?.characters.count == 0 || self.phonenumberField.text?.characters.count == 0 {
            UIAlertView(title: "Error", message: "Please fill all the fields.", delegate: nil, cancelButtonTitle: "OK").show()
            return false;
        } else if self.newPasswordField.text != self.confirmPasswordField.text{
            UIAlertView(title: "Error", message: "Passwords donot match.", delegate: nil, cancelButtonTitle: "OK").show()
            return false;
        } else if Helper.sharedInstance.isvalidaEmailId(self.emailField.text!) == false {
            UIAlertView(title: "Error", message: "Invalid Email Address.", delegate: nil, cancelButtonTitle: "OK").show()
            return false;
        }
        return true;
    }
    
    // MARK: UITextField Delegates
    
    func textFieldDidBeginEditing(textField: UITextField) {
        
        if self.isEditing == true {
            return;
        }
        self.isEditing = true;
        UIView.animateWithDuration(0.3, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
            self.topConstraint.constant -= 170;
            self.view.layoutIfNeeded()
            
            }, completion: nil)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.isEditing = false;
        self.view.endEditing(true)
        return true
    }
    
    
    func textFieldDidEndEditing(textField: UITextField) {
        if self.isEditing == true {
            return;
        }
        UIView.animateWithDuration(0.3, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
            self.topConstraint.constant += 170;
            self.view.layoutIfNeeded()
            
            }) { (Bool) -> Void in
                //                self.validateEmailId();
        }
    }

}