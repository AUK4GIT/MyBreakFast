//
//  ReferralVC.swift
//  MyBreakFast
//
//  Created by Uday Kiran Ailapaka on 13/01/16.
//  Copyright © 2016 AUK. All rights reserved.
//

import Foundation
import Social
import FBSDKShareKit

class ReferralVC: UIViewController {
    
    @IBOutlet weak var redeemPoints: UILabel!
    
    @IBOutlet weak var expiryDate: UILabel!
    @IBOutlet weak var referralCode: UILabel!
    var referCode : String?
    
    override func beginAppearanceTransition(isAppearing: Bool, animated: Bool) {
        super.beginAppearanceTransition(isAppearing, animated: animated)
        if isAppearing {
            let fadeTextAnimation: CATransition = CATransition();
            fadeTextAnimation.duration = 0.5;
            fadeTextAnimation.type = kCATransitionFade;
            
            let parentVC: ViewController = self.parentViewController as! ViewController
            parentVC.setNavBarTitle("Refer a Friend")
            parentVC.containerNavigationBar.layer.addAnimation(fadeTextAnimation, forKey: "fadeText");
        }
    }
    override func endAppearanceTransition() {
        super.endAppearanceTransition()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
            Helper.sharedInstance.showActivity()
            self.fetchRedeemPoints()
        }
        
    }
    
    func fetchRedeemPoints() {
        Helper.sharedInstance.fetchUserRedeemPoints { (response) -> () in
            
            dispatch_async(dispatch_get_main_queue()) { () -> Void in
                
                let responseStatus = (response as? String) ?? ""
                if responseStatus == "ERROR"{
                } else {
                    let responseStat = (response as? NSDictionary)
                    let pointsDict = responseStat?.objectForKey("points") as? NSDictionary
                    var points: AnyObject?
                    if let pointsStr = pointsDict?.objectForKey("total_points") as? NSNumber {
                        points = String(pointsStr)
                    } else {
                        points = pointsDict?.objectForKey("total_points") as? String
                    }
                    let userpoints = points ?? "0";
                    self.redeemPoints.text = (userpoints as? String)!
                    let referCode = responseStat?.objectForKey("referal_code")  ?? "----";
                    self.referralCode.text = referCode as? String;
                    self.referCode = referCode as? String;
                }
                Helper.sharedInstance.hideActivity()
            }
        }
    }
    
    @IBAction func orderNow(sender: AnyObject) {
        let parentVC = self.parentViewController as! ViewController
        parentVC.cycleFromViewController(nil, toViewController: (self.storyboard?.instantiateViewControllerWithIdentifier("MenuVC"))!)
    }
    
    @IBAction func whatsAppAction(sender: AnyObject) {
        if self.referCode == nil {
            return;
        }
        
        let referString = "whatsapp://"
        let whatsappURL = NSURL(string: referString);
        if UIApplication.sharedApplication().canOpenURL(whatsappURL!){
            let referString = "whatsapp://send?text=Please use this referral code \""+self.referCode!+"\" to register on First Eat and get credits"
            let url2 = referString.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
            let whatsappURL = NSURL(string: url2!);

            UIApplication.sharedApplication().openURL(whatsappURL!)
        } else {
            UIAlertView(title: "First Eat", message: "Whatsapp app not installed.", delegate: nil, cancelButtonTitle: "OK").show()
        }
    }
    
    @IBAction func faceBookAction(sender: AnyObject) {
        
        if self.referCode == nil {
            return;
        }
        let referString = "Please use this referral code \""+self.referCode!+"\" to register on First Eat and get credits"
        UIPasteboard.generalPasteboard().string = referString
        
        if SLComposeViewController.isAvailableForServiceType(SLServiceTypeFacebook) {
            
            let vc = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
            vc.setInitialText(referString)
            vc.addURL(NSURL(string: "https://facebook.com/firsteat"))
//            vc.addImage(self.textToImage(referString, inImage: UIImage(), atPoint: CGPointMake(5, 5)))
            presentViewController(vc, animated: true, completion: nil)
        } else {
        
            
            let content: FBSDKShareLinkContent = FBSDKShareLinkContent()
            content.contentURL = NSURL(string: "https://facebook.com/firsteat")
            content.contentTitle = "First Eat: "+referString
            content.contentDescription = "Have a healthy BreakFast"
            //        content.imageURL = NSURL(string: self.contentURLImage)
            FBSDKShareDialog.showFromViewController(self, withContent: content, delegate: nil)

        }
        
        UIAlertView(title: "First Eat", message: "Double tap to paste the referral code on you wall.", delegate: nil, cancelButtonTitle: "OK").show()

        
            }
    
    @IBAction func twitterAction(sender: AnyObject) {
        
        if self.referCode == nil {
            return;
        }
        
        if SLComposeViewController.isAvailableForServiceType(SLServiceTypeTwitter) {
            let referString = "Please use this referral code \""+self.referCode!+"\" to register on First Eat and get credits"

            let vc = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
            vc.setInitialText(referString)
            vc.addURL(NSURL(string: "https://twitter.com/firsteat_in"))
//            vc.addImage(self.textToImage(referString, inImage: UIImage(), atPoint: CGPointMake(5, 5)))
            presentViewController(vc, animated: true, completion: nil)
        } else {
        
        let referString = "twitter://"
        let whatsappURL = NSURL(string: referString);
        if UIApplication.sharedApplication().canOpenURL(whatsappURL!){
            let referString = "twitter://post?message=Please use this referral code \""+self.referCode!+"\" to register on First Eat and get credits"
            let url2 = referString.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
            let whatsappURL = NSURL(string: url2!);
            
            UIApplication.sharedApplication().openURL(whatsappURL!)
        } else {
            UIAlertView(title: "First Eat", message: "Twitter app not installed.", delegate: nil, cancelButtonTitle: "OK").show()
        }
        }
    }
    
    func textToImage(drawText: NSString, var inImage: UIImage, atPoint:CGPoint)->UIImage{
        
        // Setup the font specific variables
        let textColor: UIColor = UIColor.darkGrayColor()
        let textFont: UIFont = UIFont(name: "HelveticaNeue-Bold", size: 14)!
        
        //Setup the image context using the passed image.
        UIGraphicsBeginImageContext(CGSizeMake(300, 60))
        
        //Setups up the font attributes that will be later used to dictate how the text should be drawn
        let textFontAttributes = [
            NSFontAttributeName: textFont,
            NSForegroundColorAttributeName: textColor,
        ]
        
//        if inImage == nil {
            inImage = UIImage()
//        }
        //Put the image into a rectangle as large as the original image.
        inImage.drawInRect(CGRectMake(0, 0, 300, 60))
        
        // Creating a point within the space that is as bit as the image.
        let rect: CGRect = CGRectMake(5, 5, 290, 50)
        
        //Now Draw the text into an image.
        drawText.drawInRect(rect, withAttributes: textFontAttributes)
        
        // Create a new image out of the images we have created
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        
        // End the context now that we have the image we need
        UIGraphicsEndImageContext()
        
        //And pass it back up to the caller.
        return newImage
        
    }
    
}