//
//  SubscriptionMenuVC.swift
//  MyBreakFast
//
//  Created by AUK on 10/06/16.
//  Copyright © 2016 AUK. All rights reserved.
//

import Foundation

class SubscriptionMenuVC: ContainerVC {
    
    @IBOutlet var mainContainer: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.cycleFromViewController(nil, toViewController: (self.storyboard?.instantiateViewControllerWithIdentifier("MenuVC"))!)

    }
    
    func cycleFromViewController(oldC: AnyObject?,
                                 toViewController newC: UIViewController)    {
        
        self.cycleFromViewController(oldC, toViewController: newC, onContainer: self.mainContainer)
    }
    
    @IBAction func categorySelected(sender: AnyObject) {
        
        if sender.tag == 1 {
            self.cycleFromViewController(nil, toViewController: (self.storyboard?.instantiateViewControllerWithIdentifier("MenuVC"))!)

        }
        else {
            self.cycleFromViewController(nil, toViewController: (self.storyboard?.instantiateViewControllerWithIdentifier("SubscriptionVC"))!)

        }
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let segueName = segue.identifier {
            print(segueName)
            if segueName == "DummyVC" {
                let dummyVC: DummyVC = segue.destinationViewController as! DummyVC
                dummyVC.view.tag = 101;
            }
        }
    }
}
