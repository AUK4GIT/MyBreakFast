//
//  AppSignInVC.swift
//  MyBreakFast
//
//  Created by Uday Kiran Ailapaka on 09/12/15.
//  Copyright © 2015 AUK. All rights reserved.
//

import Foundation
import FBSDKCoreKit
import FBSDKLoginKit

class AppSignInVC: UIViewController {
    
    @IBOutlet  var topConstraint: NSLayoutConstraint!
    @IBOutlet  var loginButton: UIButton!
    @IBOutlet var faceBookButton: UIButton!
     var completionHandler:((NSDictionary)->Void)!
    @IBOutlet  var userEmail: UITextField!
    @IBOutlet  var passwordField: UITextField!
    @IBOutlet  var confirmPasswordField: UITextField!
    @IBOutlet  var forgotPassword: UIButton!
    var isEditing: Bool?
    var userObj: UserDetails?
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        self.isEditing = false;
        self.userObj = Helper.sharedInstance.getUserDetailsObj() as? UserDetails

//        self.loginButton.layer.cornerRadius = 15.0;
//        self.faceBookButton.layer.cornerRadius = 15.0;
        
        self.loginButton.titleLabel?.adjustFontToRealIPhoneSize = true;
        self.faceBookButton.titleLabel?.adjustFontToRealIPhoneSize = true;
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
    
    @IBAction func forgotPasswordAction(sender: AnyObject) {
    }
    
    @IBAction func loginSignUpAction(sender: AnyObject){

        self.isEditing = false;
        self.userEmail.resignFirstResponder()
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
                        self.verifyOTPWithUserId(userId);
                    } else {
                        let userId = responsestatus?.objectForKey("user_id") as? NSNumber
                        self.userObj?.userId = userId?.stringValue;
                        self.userObj?.phoneNumber = self.passwordField.text!;
                        self.verifyOTPWithUserId((userId?.stringValue)!);
                    }
                } else {
                    UIAlertView(title: "Unknown Error", message: "Please try again after sometime.", delegate: nil, cancelButtonTitle: "OK").show()
                }
            }
        })
        
      /*
        if self.userEmail.text?.characters.count == 0 || self.passwordField.text?.characters.count == 0{
            
            UIAlertView(title: "First Eat!", message: "Please Fill all the details.", delegate: nil, cancelButtonTitle: "OK").show()

        return
        }
        
        
        Helper.sharedInstance.doUserLogin(self.userEmail.text!, password: self.passwordField.text!) { (response) -> () in
            
            let responseStatus = (response as? String) ?? ""
            if responseStatus == "ERROR" {
                UIAlertView(title: "Login Unsuccessful!", message: "Please try again.", delegate: nil, cancelButtonTitle: "OK").show()
                
            } else {
                let responsestatus = (response as? NSDictionary)
                if (responsestatus?.objectForKey("authentication"))! as! String == "invalid" {
                    UIAlertView(title: "Login Unsuccessful!", message: "Please try again using correct Username and Password.", delegate: nil, cancelButtonTitle: "OK").show()

                    return;
                } else {
                
                    let userRegistrationStatus = Helper.sharedInstance.getDataFromUserDefaults(forKey: Constants.UserdefaultConstants.UserRegistration) as? Bool
                    Helper.sharedInstance.saveToUserDefaults(forKey: Constants.UserdefaultConstants.UserLoginStatus, value: true)

                    if userRegistrationStatus != nil{
                    
                        self.dismissViewControllerAnimated(true, completion: { () -> Void in
                        })

                    } else {
                        self.presentRegistrationScreenAfterLogin();
                    }
                }
            }
        }
        */
    }
    
    func verifyOTPWithUserId(userId: String){
       
        var inputTextField: UITextField?
        let passwordPrompt = UIAlertController(title: "First Eat", message: "Please enter the OTP received.", preferredStyle: UIAlertControllerStyle.Alert)
        passwordPrompt.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: nil))
        passwordPrompt.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
            // Now do whatever you want with inputTextField (remember to unwrap the optional)
            print("%@",inputTextField?.text);
            Helper.sharedInstance.VerifyOTP((inputTextField?.text)!, userObject: self.userObj!, completionHandler: { (response) -> () in
                let respo = response as? NSDictionary
                if let status = respo?.objectForKey("status") as? String {
                    if status == "1" {
                        self.fetchUserDetails();
                    } else {
                        let warning = UIAlertController(title: "First Eat", message: "Please enter the correct OTP.", preferredStyle: UIAlertControllerStyle.Alert)
                        warning.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
                            self.verifyOTPWithUserId((self.userObj?.userId!)!);
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
                            self.verifyOTPWithUserId((self.userObj?.userId!)!);
                        }))
                        self.presentViewController(warning, animated: true, completion: nil)

                    }
                }
            })
        }))
        passwordPrompt.addTextFieldWithConfigurationHandler({(textField: UITextField!) in
            textField.placeholder = "OTP"
            textField.secureTextEntry = true
            inputTextField = textField
        })
        
        presentViewController(passwordPrompt, animated: true, completion: nil)
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
    
    
    @IBAction func facebookLoginAction(sender: AnyObject) {
        let login: FBSDKLoginManager = FBSDKLoginManager();
        
//        if ((FBSDKAccessToken.currentAccessToken()) != nil) {
//            // User is logged in, do work such as go to next view controller.
//            return;
//        }
        
        login.logInWithReadPermissions(["public_profile","email","user_friends"], fromViewController: self) { (result, error) -> Void in
            if let error = error {
                print("Process error:->  ",error);
//                if self.completionHandler != nil {
//                    self.completionHandler(["ERROR":"ERROR"]);
//                }
                UIAlertView(title: "Error!", message: "Please try again.", delegate: nil, cancelButtonTitle: "OK").show()
            } else if (result.isCancelled) {
                print("Cancelled");
//                if self.completionHandler != nil {
//                    self.completionHandler(["ERROR":"CANCELLED"]);
//                }
            } else {
                
                FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email"]).startWithCompletionHandler({ (connection, result, error) -> Void in
                    if (error == nil){
                        let dict = result as! NSDictionary
                        print(result)
                        print(dict)
                        print(dict.objectForKey("picture")?.objectForKey("data")?.objectForKey("url") as! String)
                        Helper.sharedInstance.saveUserDetailsFromFaceBook(dict);
                        Helper.sharedInstance.saveToUserDefaults(forKey: Constants.UserdefaultConstants.UserLoginStatus, value: true);
//                        self.showUserSignUpPage();
//                        if self.completionHandler != nil {
//                            self.completionHandler(dict);
//                        }        
                        
                        
                        let userRegistrationStatus = Helper.sharedInstance.getDataFromUserDefaults(forKey: Constants.UserdefaultConstants.UserRegistration) as? Bool
                        
                        if userRegistrationStatus == nil{
                            self.presentRegistrationScreenAfterLoginFromFaceBook();
                        }
                    }
                });
                
                
            }
        }
    }
    func presentRegistrationScreenAfterLoginFromFaceBook(){
        //        RegistrationVC
        let vc: RegistrationVC = (self.storyboard?.instantiateViewControllerWithIdentifier("RegistrationVC")) as! RegistrationVC
        self.presentViewController(vc, animated: true) { () -> Void in
            vc.setAfterFaceBookLoginSettings();
        }
    }
    
    
    @IBAction func registerAction(sender: AnyObject) {
        
        self.confirmPasswordField.hidden = false;
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