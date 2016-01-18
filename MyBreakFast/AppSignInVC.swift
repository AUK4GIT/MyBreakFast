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
    
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet var faceBookButton: UIButton!
     var completionHandler:((NSDictionary)->Void)!
    @IBOutlet weak var userEmail: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var confirmPasswordField: UITextField!
    @IBOutlet weak var forgotPassword: UIButton!
    var isEditing: Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        self.isEditing = false;
        self.loginButton.layer.cornerRadius = 15.0;
        self.faceBookButton.layer.cornerRadius = 15.0;
        
        self.loginButton.titleLabel?.adjustFontToRealIPhoneSize = true;
        self.faceBookButton.titleLabel?.adjustFontToRealIPhoneSize = true;

        if let _ = Helper.sharedInstance.getDataFromUserDefaults(forKey: Constants.UserdefaultConstants.UserLoginStatus) {
        
        }
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
    }
    
    func presentRegistrationScreenAfterLogin(){
    
//        RegistrationVC
        
        let vc: RegistrationVC = (self.storyboard?.instantiateViewControllerWithIdentifier("RegistrationVC")) as! RegistrationVC
        self.presentViewController(vc, animated: true) { () -> Void in
            vc.setAfterLoginSettings(self.userEmail.text!, password: self.passwordField.text!);
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