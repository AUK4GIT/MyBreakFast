//
//  ContactUsVC.swift
//  MyBreakFast
//
//  Created by Uday Kiran Ailapaka on 29/10/15.
//  Copyright © 2015 AUK. All rights reserved.
//

import Foundation
import UIKit
import QuartzCore
import MessageUI

class ContactUsVC: UIViewController,MFMailComposeViewControllerDelegate {
    
    override func beginAppearanceTransition(isAppearing: Bool, animated: Bool) {
        super.beginAppearanceTransition(isAppearing, animated: animated)
        if isAppearing {
            let fadeTextAnimation: CATransition = CATransition();
            fadeTextAnimation.duration = 0.5;
            fadeTextAnimation.type = kCATransitionFade;
            
            let parentVC: ViewController = self.parentViewController as! ViewController
            parentVC.setNavBarTitle("Contact Us")
            parentVC.containerNavigationBar.layer.addAnimation(fadeTextAnimation, forKey: "fadeText");

        }
    }
    override func endAppearanceTransition() {
        super.endAppearanceTransition()
    }
    
    // 1
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        let userLoginStatus = Helper.sharedInstance.getDataFromUserDefaults(forKey: Constants.UserdefaultConstants.UserLoginStatus) as? Bool
        let userRegistrationStatus = Helper.sharedInstance.getDataFromUserDefaults(forKey: Constants.UserdefaultConstants.UserRegistration) as? Bool
        
        if userLoginStatus == nil {
            let vc: AppSignInVC = (self.storyboard?.instantiateViewControllerWithIdentifier("AppSignInVC")) as! AppSignInVC
            self.presentViewController(vc, animated: true, completion: nil)
            vc.completionHandler = {dict in
                print(dict);
                vc.dismissViewControllerAnimated(true, completion: { () -> Void in
                    //                    if let obj = dict.object
                })
            };
        } else if userRegistrationStatus == nil {
            
            let vc: AppSignInVC = (self.storyboard?.instantiateViewControllerWithIdentifier("AppSignInVC")) as! AppSignInVC
            self.presentViewController(vc, animated: true, completion: nil)
            vc.completionHandler = {dict in
                print(dict);
                vc.dismissViewControllerAnimated(true, completion: { () -> Void in
                    //                    if let obj = dict.object
                })
            };
            
        } else {
            
            
        }
        
    }

    
    @IBAction func emailAction(sender: AnyObject) {
        
        let mailVC = MFMailComposeViewController()
        mailVC.mailComposeDelegate = self
        mailVC.setSubject("First Eat")
        mailVC.setToRecipients(["contact@firsteat.in"])
        mailVC.navigationBar.tintColor = UIColor.whiteColor()
        self.presentViewController(mailVC, animated: true, completion: nil)
    }
    
    @IBAction func faceBookAction(sender: AnyObject) {
//        let url: NSURL = NSURL(string: "fb://profile/firsteat")!//[NSURL URLWithString:@"fb://profile/113810631976867"];
//        if UIApplication.sharedApplication().canOpenURL(url) {
//            UIApplication.sharedApplication().openURL(url);
//        } else {
            UIApplication.sharedApplication().openURL(NSURL(string: "https://facebook.com/firsteat")!);
//        }
        
    }
    
    @IBAction func twitterAction(sender: AnyObject) {

//        let url: NSURL = NSURL(string: "twitter:///")!
//        if UIApplication.sharedApplication().canOpenURL(url) {
//            UIApplication.sharedApplication().openURL(url);
//        } else {
            UIApplication.sharedApplication().openURL(NSURL(string: "https://twitter.com/firsteat_in")!);
//        }

    }
    
    @IBAction func phoneAction(sender: AnyObject) {
        UIApplication.sharedApplication().openURL(NSURL(string: "tel://9821706223")!);
    }
    
    @IBAction func instagramAction(sender: AnyObject) {
//        let url: NSURL = NSURL(string: "instagram://")!
//        if UIApplication.sharedApplication().canOpenURL(url) {
//            UIApplication.sharedApplication().openURL(url);
//        } else {
            UIApplication.sharedApplication().openURL(NSURL(string: "https://instagram.com/firsteat_in")!);
//        }


    }
    
    
    
}