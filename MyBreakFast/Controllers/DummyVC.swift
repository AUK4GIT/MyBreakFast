//
//  DummyVC.swift
//  MyBreakFast
//
//  Created by Uday Kiran Ailapaka on 24/12/15.
//  Copyright © 2015 AUK. All rights reserved.
//

import Foundation

class DummyVC: UIViewController {
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated);
        
        
        if let parentVC = self.parentViewController as? ViewController {
            parentVC.cycleFromViewController(nil, toViewController: (self.storyboard?.instantiateViewControllerWithIdentifier("SubscriptionMenuVC"))!)
        } else if let parentVC = self.parentViewController as? SubscriptionMenuVC {
            parentVC.cycleFromViewController(nil, toViewController: (self.storyboard?.instantiateViewControllerWithIdentifier("SubscriptionVC"))!)
        }


    }
}