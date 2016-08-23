//
//  AppSignInVC.swift
//  MyBreakFast
//
//  Created by Uday Kiran Ailapaka on 09/12/15.
//  Copyright © 2015 AUK. All rights reserved.
//

import Foundation
//import FBSDKCoreKit
//import FBSDKLoginKit

class AppSignInVC: UIViewController {
    
    @IBOutlet  var topConstraint: NSLayoutConstraint!
    @IBOutlet  var loginButton: UIButton!
    var completionHandler:((NSDictionary)->Void)!
    @IBOutlet  var passwordField: UITextField!
    var isEditing: Bool?
    var isOTPResent: Bool?
    var userObj: UserDetails?
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        self.isEditing = false;
        self.isOTPResent = false;
        self.userObj = Helper.sharedInstance.getUserDetailsObj() as? UserDetails
        
        self.loginButton.titleLabel?.adjustFontToRealIPhoneSize = true;
        self.passwordField.keyboardType = UIKeyboardType.NumberPad;

        if let _ = Helper.sharedInstance.getDataFromUserDefaults(forKey: Constants.UserdefaultConstants.UserLoginStatus) {
        
        }
    }
    
    @IBAction func dismissViewController(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        let userLoginStatus = Helper.sharedInstance.getDataFromUserDefaults(forKey: Constants.UserdefaultConstants.UserLoginStatus) as? Bool
        
        let userRegistrationStatus = Helper.sharedInstance.getDataFromUserDefaults(forKey: Constants.UserdefaultConstants.UserRegistration) as? Bool
        
        if userLoginStatus != nil && userRegistrationStatus != nil {
        self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    @IBAction func loginSignUpAction(sender: AnyObject){

        self.isEditing = false;
        self.passwordField.resignFirstResponder()
        
        if self.passwordField.text?.characters.count == 0{
            
            UIAlertView(title: "First Eat!", message: "Please Fill all the details.", delegate: nil, cancelButtonTitle: "OK").show()
            
            return
        } else if self.passwordField.text?.characters.count != 10 {
            UIAlertView(title: "Error", message: "Please enter correct hpone number.", delegate: nil, cancelButtonTitle: "OK").show()
            return
        }
        
        Helper.sharedInstance.validatePhoneNumber(self.passwordField.text!, completionHandler:{ (response) -> () in
            
            let responseStatus = (response as? String) ?? ""
            if responseStatus == "ERROR" {
                UIAlertView(title: "Login Unsuccessful!", message: "Please try again.", delegate: nil, cancelButtonTitle: "OK").show()
                
            } else {
                let responsestatus = (response as? NSDictionary)
                let status = responsestatus?.objectForKey("status") as? String
                let msg = responsestatus?.objectForKey("msg") as? String
                if status == "0" || msg == "Mobile does not exists"{
                    self.presentRegistrationScreenAfterLogin();

                } else if status == "1" || msg == "Mobile Exists" {
                    if let userId = responsestatus?.objectForKey("user_id") as? String {
                        self.userObj?.userId = userId;
                        self.userObj?.phoneNumber = self.passwordField.text!;
                        self.showOTPInputViewWithUserId(userId);
                    } else {
                        let userId = responsestatus?.objectForKey("user_id") as? NSNumber
                        self.userObj?.userId = userId?.stringValue;
                        self.userObj?.phoneNumber = self.passwordField.text!;
                        self.showOTPInputViewWithUserId((userId?.stringValue)!);
                    }
                } else {
                    UIAlertView(title: "Unknown Error", message: "Please try again after sometime.", delegate: nil, cancelButtonTitle: "OK").show()
                }
            }
        })
        
    }
    
    func showOTPInputViewWithUserId(userId: String){
       
        var inputTextField: UITextField?
        let passwordPrompt = UIAlertController(title: "First Eat", message: "Please enter the OTP received.", preferredStyle: UIAlertControllerStyle.Alert)
        passwordPrompt.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
            if inputTextField?.text?.characters.count > 0 {
                self.verifyOTPWith((inputTextField?.text)!, userObject: self.userObj!)
            } else {
                self.showOTPInputViewWithUserId(userId);
            }
        }))
        passwordPrompt.addTextFieldWithConfigurationHandler({(textField: UITextField!) in
            textField.placeholder = "OTP"
            textField.secureTextEntry = true
            inputTextField = textField
        })
        
        presentViewController(passwordPrompt, animated: true) {
            
            var actionDelayTimer: NSTimer?
            var timer: Int = 0;
            let block: NSBlockOperation = NSBlockOperation(block: {
                /* do work */
                
                timer = timer+1;
                passwordPrompt.message = "Please enter the OTP received. "+String(timer);
                
                if let _ = actionDelayTimer where timer == 15{
                    actionDelayTimer?.invalidate()
                    actionDelayTimer = nil;
                    passwordPrompt.addAction(UIAlertAction(title: ((self.isOTPResent == true) ? "Skip/Verify Later" : "resend"), style: UIAlertActionStyle.Default, handler:{ (action) -> Void in
                        
                        if self.isOTPResent == false {
                            self.resendOTP((self.userObj?.phoneNumber)!, userId: userId)
                        } else {
                            self.skipOTP((self.userObj?.phoneNumber)!, userId: userId)
                        }
                    }))
                }
            })
            actionDelayTimer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: block, selector: #selector(block.main), userInfo: nil, repeats: true)
        }
    }
    
    func resendOTP(phoneNumber: String, userId: String){
        Helper.sharedInstance.resendOTP(phoneNumber, userId: userId, completionHandler: { (response) in
            let responseStatus = (response as? String) ?? ""
            if responseStatus == "ERROR" {
                UIAlertView(title: "Login Unsuccessful!", message: "Please try again.", delegate: nil, cancelButtonTitle: "OK").show()
                
            } else {
                let responsestatus = (response as? NSDictionary)
                let status = responsestatus?.objectForKey("status") as? String
                if status == "1" {
                    self.isOTPResent = true;
                    self.showOTPInputViewWithUserId(userId)
                } else {
                    UIAlertView(title: "Login Unsuccessful!", message: "Please try again.", delegate: nil, cancelButtonTitle: "OK").show()
                }
            }
        })
    }
    
    func skipOTP(phoneNumber: String, userId: String){
        Helper.sharedInstance.skipOTP(phoneNumber, userId: userId, completionHandler: { (response) in
            let responseStatus = (response as? String) ?? ""
            if responseStatus == "ERROR" {
                UIAlertView(title: "Login Unsuccessful!", message: "Please try again.", delegate: nil, cancelButtonTitle: "OK").show()
                
            } else {
                let responsestatus = (response as? NSDictionary)
                let status = responsestatus?.objectForKey("status") as? String
                if status == "1" {
                    self.isOTPResent = false;
                    self.dismissViewControllerAnimated(true, completion: { () -> Void in
                        Helper.sharedInstance.saveToUserDefaults(forKey: Constants.UserdefaultConstants.UserLoginStatus, value: true)
                        Helper.sharedInstance.saveToUserDefaults(forKey: Constants.UserdefaultConstants.UserRegistration, value: true)
                        
                    });
                } else {
                    UIAlertView(title: "Login Unsuccessful!", message: "Please try again.", delegate: nil, cancelButtonTitle: "OK").show()
                }
            }
        })
    }
    
    func verifyOTPWith(otpText: String, userObject: AnyObject) {
        // Now do whatever you want with inputTextField (remember to unwrap the optional)
        Helper.sharedInstance.VerifyOTP(otpText, userObject: userObject as! UserDetails, completionHandler: { (response) -> () in
            let respo = response as? NSDictionary
            if let status = respo?.objectForKey("status") as? String {
                if status == "1" {
                    self.fetchUserDetails();
                } else {
                    let warning = UIAlertController(title: "First Eat", message: "Please enter the correct OTP.", preferredStyle: UIAlertControllerStyle.Alert)
                    warning.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
                        self.showOTPInputViewWithUserId((self.userObj?.userId!)!);
                    }))
                    self.presentViewController(warning, animated: true, completion: nil)
                }
            } else {
                let status = respo?.objectForKey("status") as? NSNumber
                if status == 1 {
                    self.dismissViewControllerAnimated(true, completion: { () -> Void in
                        Helper.sharedInstance.saveToUserDefaults(forKey: Constants.UserdefaultConstants.UserLoginStatus, value: true)
                        Helper.sharedInstance.saveToUserDefaults(forKey: Constants.UserdefaultConstants.UserRegistration, value: true)
                        
                    });
                } else {
                    let warning = UIAlertController(title: "First Eat", message: "Please enter the correct OTP", preferredStyle: UIAlertControllerStyle.Alert)
                    warning.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
                        self.showOTPInputViewWithUserId((self.userObj?.userId!)!);
                    }))
                    self.presentViewController(warning, animated: true, completion: nil)
                    
                }
            }
        })
    }
    
    func fetchUserDetails(){
    
        Helper.sharedInstance.getUserDetails((self.userObj?.userId)!) { (response) -> () in
            
            let responseStatus = (response as? String) ?? ""
            if responseStatus == "ERROR" {
                UIAlertView(title: "Login Unsuccessful!", message: "Please try again.", delegate: nil, cancelButtonTitle: "OK").show()
                
            } else {
                let responsestatus = (response as? NSDictionary)
                
                self.userObj?.emailId = responsestatus?.objectForKey("user_email") as? String;
                self.userObj?.userName = responsestatus?.objectForKey("full_name") as? String;
                Helper.sharedInstance.saveContext();
                
                self.dismissViewControllerAnimated(true, completion: { () -> Void in
                    Helper.sharedInstance.saveToUserDefaults(forKey: Constants.UserdefaultConstants.UserLoginStatus, value: true)
                    Helper.sharedInstance.saveToUserDefaults(forKey: Constants.UserdefaultConstants.UserRegistration, value: true)
                    
                });

            }
           
        }
    
    }
    
    
    func presentRegistrationScreenAfterLogin(){
    
//        RegistrationVC
        
        let vc: RegistrationVC = (self.storyboard?.instantiateViewControllerWithIdentifier("RegistrationVC")) as! RegistrationVC
        self.presentViewController(vc, animated: true) { () -> Void in
            vc.setAfterLoginSettings(self.passwordField.text!, password: "firsteat");
        }
    }

    @IBAction func registerAction(sender: AnyObject) {
        
        self.loginButton.setTitle("SIGNUP", forState: .Normal)
    }
    
    // MARK: UITextField Delegates
    
    func textFieldDidBeginEditing(textField: UITextField) {
        
        if self.isEditing == true {
            return;
        }
        self.isEditing = true;
        UIView.animateWithDuration(0.3, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
            self.topConstraint.constant -= 50;
            self.view.layoutIfNeeded()
            
            }, completion: nil)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.isEditing = false;
        self.view.endEditing(true)
        return true
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        if (textField == self.passwordField) && (range.location >= 10) {
            return false
        }
        return true;
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        if self.isEditing == true {
            return;
        }
        UIView.animateWithDuration(0.3, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
            self.topConstraint.constant += 50;
            self.view.layoutIfNeeded()
            
            }) { (Bool) -> Void in
                //                self.validateEmailId();
        }
    }
}