//
//  FeedBackVC.swift
//  MyBreakFast
//
//  Created by Uday Kiran Ailapaka on 06/01/16.
//  Copyright © 2016 AUK. All rights reserved.
//

/*
<div>Icon made by <a href="http://www.google.com" title="Google">Google</a> from <a href="http://www.flaticon.com" title="Flaticon">www.flaticon.com</a> is licensed under <a href="http://creativecommons.org/licenses/by/3.0/" title="Creative Commons BY 3.0">CC BY 3.0</a></div>
*/


import Foundation


class FeedBackVC: UIViewController, FloatRatingViewDelegate {
    
    @IBOutlet var sendButton: UIButton!
    @IBOutlet var floatRatingView: FloatRatingView!

    @IBOutlet var heightConstraint: NSLayoutConstraint!
    @IBOutlet var textView: UITextView!
    
    var rating: String = "0";
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.floatRatingView.delegate = self;
        self.floatRatingView.tintColor = Constants.AppColors.green.color;
    }
    
    override func beginAppearanceTransition(isAppearing: Bool, animated: Bool) {
        super.beginAppearanceTransition(isAppearing, animated: animated)
        if isAppearing {
            let fadeTextAnimation: CATransition = CATransition();
            fadeTextAnimation.duration = 0.5;
            fadeTextAnimation.type = kCATransitionFade;
            
            let parentVC: ViewController = self.parentViewController as! ViewController
            parentVC.setNavBarTitle("Rate Us")
            parentVC.containerNavigationBar.layer.addAnimation(fadeTextAnimation, forKey: "fadeText");
            parentVC.containerNavigationItem.rightBarButtonItem = nil;

//            self.textView.layer.borderColor = UIColor.lightGrayColor().CGColor
//            self.textView.layer.borderWidth = 1;
//            self.textView.layer.cornerRadius = 10
            
            self.sendButton.enabled = false;
            
            self.heightConstraint.constant = self.view.bounds.size.width/2 - 50;
            self.view.setNeedsLayout()
        }
    }
    override func endAppearanceTransition() {
        super.endAppearanceTransition()
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
    
    @IBAction func send(sender: AnyObject) {
        self.textView.resignFirstResponder()
        
        if self.textView.text.characters.count == 0 {
            UIAlertView(title: "First Eat", message: "Please add comment.", delegate: nil, cancelButtonTitle: "OK").show()            
        } else {
            self.sendQuery();
        }
    }
    
    func sendQuery() {
        Helper.sharedInstance.sendUserFeedback(self.textView.text, rating: self.rating) { (response) -> () in
            if response as? String == "ERROR" {
                UIAlertView(title: "Error", message: "Please try again", delegate: nil, cancelButtonTitle: "OK").show()
            } else {
                self.textView.text = ""
                self.floatRatingView.rating = 1.0;
                UIAlertView(title: "First Eat!", message: "Thank You for the feedback", delegate: nil, cancelButtonTitle: "OK").show()
            }
        }
    }
    
    func validateandEnableSubmit() {
        if self.textView.text.characters.count > 0 {
            self.sendButton.enabled = true;
        }   else    {
            self.sendButton.enabled = false;
        }
    }
    
    
    // MARK: UITextField Delegates
    
    func textViewDidBeginEditing(textView: UITextView)
    {
        if textView.text == "Type your Feedback here" {
            textView.text = "";
            textView.textColor = UIColor.darkGrayColor() //optional
        }
        textView.becomeFirstResponder()
    }
    
    func textViewDidEndEditing(textView: UITextView)
    {
        if textView.text == "" {
            textView.text = "Type your Feedback here"
            textView.textColor = UIColor.lightGrayColor() //optional
        }
        textView.resignFirstResponder()
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool
    {
        
        NSObject.cancelPreviousPerformRequestsWithTarget(self, selector: #selector(FeedBackVC.validateandEnableSubmit), object: nil)
        self.performSelector(#selector(FeedBackVC.validateandEnableSubmit), withObject: nil, afterDelay: 0.5)
        
        //        if (range.location > 299) {
        //            return false
        //        }
        
        return true;
    }
    
    // MARK: FloatRatingViewDelegate
    
    func floatRatingView(ratingView: FloatRatingView, isUpdating rating:Float) {
//        self.liveLabel.text = NSString(format: "%.2f", self.floatRatingView.rating) as String
    }
    
    func floatRatingView(ratingView: FloatRatingView, didUpdate rating: Float) {
        self.rating = NSString(format: "%.0f", self.floatRatingView.rating) as String
        print(self.rating)
    }

    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
}