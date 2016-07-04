//
//  TermsVC.swift
//  MyBreakFast
//
//  Created by Uday Kiran Ailapaka on 29/02/16.
//  Copyright © 2016 AUK. All rights reserved.
//

import Foundation

class TermsVC: UIViewController {

    
    override func beginAppearanceTransition(isAppearing: Bool, animated: Bool) {
        super.beginAppearanceTransition(isAppearing, animated: animated)
        if isAppearing {
            let fadeTextAnimation: CATransition = CATransition();
            fadeTextAnimation.duration = 0.5;
            fadeTextAnimation.type = kCATransitionFade;
            
            let parentVC: ViewController = self.parentViewController as! ViewController
            parentVC.setNavBarTitle("Terms & Conditions")
            parentVC.containerNavigationBar.layer.addAnimation(fadeTextAnimation, forKey: "fadeText");
            parentVC.containerNavigationItem.rightBarButtonItem = nil;

        }
    }
    override func endAppearanceTransition() {
        super.endAppearanceTransition()
    }
    
}