//
//  MealSummaryVC.swift
//  MyBreakFast
//
//  Created by AUK on 01/07/16.
//  Copyright © 2016 AUK. All rights reserved.
//

import Foundation

class MealSummaryVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let doneButton: UIButton = UIButton(type: .Custom)
        doneButton.frame = CGRectMake(0, 0, 60, 44)
        doneButton.setTitle("Done", forState: .Normal)
        doneButton.titleLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 17.0);
        doneButton.titleLabel?.adjustFontToRealIPhoneSize = true;
        doneButton.addTarget(self, action: #selector(MyOrderDetailsVC.dismissViewController), forControlEvents: .TouchUpInside)
        doneButton.titleEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0)
        
        self.navigationItem.title = "MyOrder";
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: doneButton)
        
        //        self.tableView.registerClass(MyOrdersDetailsCell.self, forCellReuseIdentifier: "MyOrdersDetailsCell")
//        self.tableView.registerNib(UINib(nibName: "MyOrdersDetailsCell", bundle: nil), forCellReuseIdentifier: "MyOrdersDetailsCell")
        
    }
    
    func dismissViewController(){
        self.dismissViewControllerAnimated(true, completion: nil);
    }
    
    override func beginAppearanceTransition(isAppearing: Bool, animated: Bool) {
        super.beginAppearanceTransition(isAppearing, animated: animated)
        if isAppearing {
            let fadeTextAnimation: CATransition = CATransition();
            fadeTextAnimation.duration = 0.5;
            fadeTextAnimation.type = kCATransitionFade;
            
            let parentVC: ViewController = self.parentViewController as! ViewController
            parentVC.setNavBarTitle("My Subscription")
            parentVC.containerNavigationBar.layer.addAnimation(fadeTextAnimation, forKey: "fadeText");
        }
    }
    override func endAppearanceTransition() {
        super.endAppearanceTransition()
    }
}