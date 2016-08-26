//
//  RegistrationVC.swift
//  MyBreakFast
//
//  Created by Uday Kiran Ailapaka on 25/12/15.
//  Copyright © 2015 AUK. All rights reserved.
//

import Foundation

class RegistrationVC: UIViewController {
    
    @IBOutlet  var emailField: UITextField!
    @IBOutlet  var usernameField: UITextField!
    @IBOutlet  var phonenumberField: UITextField!
    @IBOutlet  var referralField: UITextField!
    @IBOutlet  var loginButton: UIButton!
    @IBOutlet  var topConstraint: NSLayoutConstraint!
    var userObj: UserDetails?
    var isEditing: Bool?
    var isOTPResent: Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.isEditing = false;
        self.isOTPResent = false;
        self.userObj = Helper.sharedInstance.getUserDetailsObj() as? UserDetails
        self.phonenumberField.keyboardType = UIKeyboardType.NumberPad;
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.view.layoutIfNeeded()
    }
    
    @IBAction func dismissViewController(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //this is called by login vc when mobile number is new/new user
    func setAfterLoginSettings(phoneNumber: String, password: String){
        self.emailField.text = "";
        self.phonenumberField.text = phoneNumber;
        self.view.layoutIfNeeded()
        self.phonenumberField.enabled = false;
        UIAlertView(title: "Registration", message: "Please enter Username and Email address.", delegate: nil, cancelButtonTitle: "OK").show()
        
    }
    
    @IBAction func registerAction(sender: AnyObject) {
        self.isEditing = false;
        self.view.endEditing(true)
        
        if validateAllFields() {
            self.userObj?.userName = self.usernameField.text;
            self.userObj?.emailId = self.emailField.text;
            self.userObj?.phoneNumber = self.phonenumberField.text;
            self.userObj?.address = Helper.sharedInstance.userLocation;
            var referralText = "";
            if self.referralField.text?.characters.count == 0{
                referralText = "null";
            } else {
                referralText = self.referralField.text!
            }
            
            Helper.sharedInstance.registerUser(self.userObj!,password: "firsteat", referralId: referralText, completionHandler: { (response) -> () in
                let responseStatus = (response as? String) ?? ""
                if responseStatus == "ERROR" {
                    UIAlertView(title: "Registration Unsuccessful!", message: "Please try again.", delegate: nil, cancelButtonTitle: "OK").show()
                    
                } else if responseStatus == "SUCCESS" {
                    self.showOTPInputViewWithUserId(Helper.sharedInstance.getUserId());
                } else if responseStatus == "DEVICEIDALREADYREGISTERED" {
                    UIAlertView(title: "Registration Unsuccessful!", message: "Device is already registered, please login using your registered mobile number", delegate: nil, cancelButtonTitle: "OK").show()
                }
            })
        }
    }
    
    func showOTPInputViewWithUserId(userId: String){
        var inputTextField: UITextField?
        let passwordPrompt = UIAlertController(title: "First Eat  ", message: "Please enter the OTP received", preferredStyle: UIAlertControllerStyle.Alert)
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
        self.presentViewController(passwordPrompt, animated: true){
            
            var actionDelayTimer: NSTimer?
            var timer: Int = 15;
            let block: NSBlockOperation = NSBlockOperation(block: {
                passwordPrompt.title = "First Eat "+String(timer);
                timer = timer-1;
                if let _ = actionDelayTimer where timer == 0{
                    passwordPrompt.title = "First Eat   ";
                    actionDelayTimer?.invalidate()
                    actionDelayTimer = nil;
                    passwordPrompt.addAction(UIAlertAction(title: ((self.isOTPResent == true) ? "Skip/Verify Later" : "Resend"), style: UIAlertActionStyle.Default, handler:{ (action) -> Void in
                        
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
                        let dQueue = dispatch_queue_create("asyncQueue", DISPATCH_QUEUE_SERIAL);
                        dispatch_async(dQueue, { () -> Void in
                            Helper.sharedInstance.saveToUserDefaults(forKey: Constants.UserdefaultConstants.UserLoginStatus, value: true)
                            Helper.sharedInstance.saveToUserDefaults(forKey: Constants.UserdefaultConstants.UserRegistration, value: true)
                            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                self.dismissViewControllerAnimated(true, completion: nil)
                            })
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
                    let dQueue = dispatch_queue_create("asyncQueue", DISPATCH_QUEUE_SERIAL);
                    dispatch_async(dQueue, { () -> Void in
                        Helper.sharedInstance.saveToUserDefaults(forKey: Constants.UserdefaultConstants.UserLoginStatus, value: true)
                        Helper.sharedInstance.saveToUserDefaults(forKey: Constants.UserdefaultConstants.UserRegistration, value: true)
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            self.dismissViewControllerAnimated(true, completion: nil)
                        })
                    });
                } else {
                    let warning = UIAlertController(title: "First Eat", message: "Please enter the correct OTP.", preferredStyle: UIAlertControllerStyle.Alert)
                    warning.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
                        
                        guard let userid = self.userObj!.userId else{
                            return;
                        }
                        self.showOTPInputViewWithUserId(userid);
                    }))
                    self.presentViewController(warning, animated: true, completion: nil)
                }
            } else {
                let status = respo?.objectForKey("status") as? NSNumber
                if status == 1 {
                    let dQueue = dispatch_queue_create("asyncQueue", DISPATCH_QUEUE_SERIAL);
                    dispatch_async(dQueue, { () -> Void in
                        Helper.sharedInstance.saveToUserDefaults(forKey: Constants.UserdefaultConstants.UserLoginStatus, value: true)
                        Helper.sharedInstance.saveToUserDefaults(forKey: Constants.UserdefaultConstants.UserRegistration, value: true)
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            self.dismissViewControllerAnimated(true, completion: nil)
                        })
                    });
                } else {
                    let warning = UIAlertController(title: "First Eat", message: "Please enter the correct OTP.", preferredStyle: UIAlertControllerStyle.Alert)
                    warning.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
                        guard let userid = self.userObj!.userId else{
                            return;
                        }
                        self.showOTPInputViewWithUserId(userid);
                    }))
                    self.presentViewController(warning, animated: true, completion: nil)
                }
            }
        })
    }
    
    func validateAllFields()->Bool {
        if self.emailField.text?.characters.count == 0 || self.usernameField.text?.characters.count == 0 || self.phonenumberField.text?.characters.count == 0 {
            UIAlertView(title: "Error", message: "Please fill all the fields.", delegate: nil, cancelButtonTitle: "OK").show()
            return false;
        } else if Helper.sharedInstance.isvalidaEmailId(self.emailField.text!) == false {
            UIAlertView(title: "Error", message: "Invalid Email Address.", delegate: nil, cancelButtonTitle: "OK").show()
            return false;
        } else if self.phonenumberField.text?.characters.count != 10 {
            UIAlertView(title: "Error", message: "Please enter correct hpone number.", delegate: nil, cancelButtonTitle: "OK").show()
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
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        if (textField == self.phonenumberField) && (range.location >= 10) {
            return false
        }
        return true;
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