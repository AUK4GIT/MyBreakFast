//
//  ActivityIndicator.swift
//  MyBreakFast
//
//  Created by Uday Kiran Ailapaka on 14/11/15.
//  Copyright © 2015 AUK. All rights reserved.
//

import Foundation
import UIKit
import QuartzCore

class ActivityIndicator: UIView {
    
    var v_superView: UIView?
    let maskLayer: CALayer = CALayer()
//    let imageLayer: CALayer = CALayer()
    
    var activity: UIActivityIndicatorView?

    
    init(onView: UIView){
        self.v_superView = onView;
        super.init(frame: onView.bounds)
        self.activity = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)
        self.addSubview(self.activity!);
        self.activity?.translatesAutoresizingMaskIntoConstraints = false;
        self.activity?.color = Constants.AppColors.blue.color;
        self.activity?.startAnimating()
        self.activity?.hidesWhenStopped = true;
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.v_superView = self.superview
//        self.setupSubLayers()
    }
    
    override func willMoveToSuperview(newSuperview: UIView?) {
        super.willMoveToSuperview(newSuperview)
        if let _ = newSuperview {
            self.v_superView = newSuperview
            self.setupSubLayers()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.frame = (self.superview?.bounds)!;
        self.maskLayer.frame = self.bounds;
//        self.imageLayer.position = CGPointMake(self.maskLayer.bounds.size.width/2, self.maskLayer.bounds.size.height/2)
//        self.imageLayer.anchorPoint = CGPointMake(0.5, 0.60);
//        self.imageLayer.bounds = CGRectMake(0, 0, 80, 80);
        self.v_superView?.bringSubviewToFront(self)
        
        self.addConstraint(NSLayoutConstraint(item: self.activity!, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.CenterX, multiplier: 1.0, constant: 0.0));
        self.addConstraint(NSLayoutConstraint(item: self.activity!, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.CenterY, multiplier: 1.0, constant: 0.0));
    }
    
    func setupSubLayers()
    {
        self.autoresizingMask = [UIViewAutoresizing.FlexibleWidth, UIViewAutoresizing.FlexibleHeight]
        self.maskLayer.backgroundColor = UIColor.blackColor().CGColor
        self.maskLayer.opacity = 0.4;
//        self.imageLayer.contents = UIImage(named: "menu_logo")?.CGImage
        
        self.layer.addSublayer(self.maskLayer)
//        self.maskLayer.addSublayer(self.imageLayer)

        /* let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotateAnimation.fromValue = 0.0
        rotateAnimation.toValue = CGFloat(M_PI * 2.0)
        rotateAnimation.duration = 0.5
        rotateAnimation.repeatDuration = CFTimeInterval.infinity
        rotateAnimation.cumulative = true;
        rotateAnimation.removedOnCompletion = false; */

        /*
        let translateAnimation = CABasicAnimation(keyPath: "transform.translation.x")
        let startVal = Float((self.v_superView?.bounds.width)!/2)
        translateAnimation.fromValue = -startVal-20
        translateAnimation.toValue = Float((self.v_superView?.bounds.width)!/2+20)
        translateAnimation.duration = 1.5
        translateAnimation.repeatDuration = CFTimeInterval.infinity
//        translateAnimation.cumulative = true;
        translateAnimation.removedOnCompletion = false;
        */
       /* let groupAnimation = CAAnimationGroup()
        groupAnimation.animations = [rotateAnimation, translateAnimation];
        groupAnimation.removedOnCompletion = false;
        groupAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        groupAnimation.removedOnCompletion = false;
        groupAnimation.fillMode = kCAFillModeForwards;
        groupAnimation.repeatDuration = CFTimeInterval.infinity
        groupAnimation.duration = 1 */

//        self.imageLayer.addAnimation(translateAnimation, forKey: "animateLayer")

    }
    
    func hideActivity() {
        self.removeFromSuperview();
    }
    
}