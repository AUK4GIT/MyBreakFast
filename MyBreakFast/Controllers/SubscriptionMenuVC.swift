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
    
    @IBOutlet var alacarteButton: UIControl!
    @IBOutlet var subscriptionButton: UIControl!
    @IBOutlet var alacarteDateLabel: UIControl!
    var loadSubscription = false;
    override func viewDidLoad() {
        super.viewDidLoad()
        let dateFormatter = NSDateFormatter()
        dateFormatter.locale = NSLocale(localeIdentifier: "en_US")
        dateFormatter.doesRelativeDateFormatting = true;
        dateFormatter.timeStyle = NSDateFormatterStyle.NoStyle;
        dateFormatter.dateStyle = NSDateFormatterStyle.FullStyle;
        let label = self.alacarteDateLabel.viewWithTag(3) as! UILabel
        let dtFormat = NSDateFormatter()
        dtFormat.dateFormat = "EEEE dd, MMM"
        let date = NSDate()
        label.text = dateFormatter.stringFromDate(date)+" ("+dtFormat.stringFromDate(date)+")"
        
        let alacarteHighlightView = self.alacarteButton.viewWithTag(7);
        let subscrHighlightView = self.subscriptionButton.viewWithTag(7);
        if self.loadSubscription {
            subscrHighlightView?.hidden = false;
            alacarteHighlightView?.hidden = true;
        } else {
            subscrHighlightView?.hidden = true;
            alacarteHighlightView?.hidden = false;
        }
    }
    
    func cycleFromViewController(oldC: AnyObject?,
                                 toViewController newC: UIViewController)    {
        
        self.cycleFromViewController(oldC, toViewController: newC, onContainer: self.mainContainer)
    }
    
    @IBAction func categorySelected(sender: UIControl) {
        
        let alacarteHighlightView = self.alacarteButton.viewWithTag(7);
        let subscrHighlightView = self.subscriptionButton.viewWithTag(7);
        
        if sender.tag == 1 {
            let menuVC = (self.storyboard?.instantiateViewControllerWithIdentifier("MenuVC")) as! MenuVC
            self.cycleFromViewController(nil, toViewController: menuVC)
            alacarteHighlightView?.hidden = false;
            subscrHighlightView?.hidden = true;
        }
        else {
            self.cycleFromViewController(nil, toViewController: (self.storyboard?.instantiateViewControllerWithIdentifier("SubscriptionVC"))!)
            alacarteHighlightView?.hidden = true;
            subscrHighlightView?.hidden = false;
        }
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let segueName = segue.identifier {
            print(segueName)
            if segueName == "DummyVC" {
                let dummyVC: DummyVC = segue.destinationViewController as! DummyVC
                dummyVC.loadSubscription = self.loadSubscription;
                dummyVC.view.tag = 101;
            }
        }
    }
    
    
    @IBAction func showDatePicker(sender: UIControl){
        
        if let nxtRespnder = self.mainContainer.viewWithTag(101)?.nextResponder() as? MenuVC {
//            UIApplication.sharedApplication().sendAction(#selector(MenuVC.showDatePicker(_:)), to: nil, from: nxtRespnder, forEvent: nil)
            sender.sendAction(#selector(MenuVC.showDatePicker(_:)), to: nxtRespnder, forEvent: nil)
        }
    }
}
