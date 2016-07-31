//
//  DummyVC.swift
//  MyBreakFast
//
//  Created by Uday Kiran Ailapaka on 24/12/15.
//  Copyright © 2015 AUK. All rights reserved.
//

import Foundation

class DummyVC: UIViewController {
    var loadSubscription = false;
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated);
        
        
        if let parentVC = self.parentViewController as? ViewController {
            parentVC.cycleFromViewController(nil, toViewController: (self.storyboard?.instantiateViewControllerWithIdentifier("SubscriptionMenuVC"))!)
        } else if let parentVC = self.parentViewController as? SubscriptionMenuVC {
                if self.loadSubscription {
                    parentVC.cycleFromViewController(nil, toViewController: (self.storyboard?.instantiateViewControllerWithIdentifier("SubscriptionVC"))!)
                    
                } else {
                    Helper.sharedInstance.getDefaultScreen({ (response) in
                        var subscr = "0"
                        if let defaultScreen = response["default_screen"] as? NSDictionary {
                            subscr = (defaultScreen["subsc"] as? String)!
                        }
                        if let popupD = response["popup"] as? NSDictionary {
                            let popup = (popupD["popup"] as? String)!
                            Helper.sharedInstance.isAddPopuprequired = (popup=="1") ? true : false;
                            Helper.sharedInstance.popupURL = (popupD["popup_img_url"] as? String)!
                        }
//                        let alarct = response["ala"] as? String
                        
                        if subscr == "1" {
                            parentVC.cycleFromViewController(nil, toViewController: (self.storyboard?.instantiateViewControllerWithIdentifier("SubscriptionVC"))!)

                        } else {
                            parentVC.cycleFromViewController(nil, toViewController: (self.storyboard?.instantiateViewControllerWithIdentifier("MenuVC"))!)
                        }
                        
                        
                    })
                    
            }
        }
    }
}