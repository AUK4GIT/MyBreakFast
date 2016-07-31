//
//  ADDVC.swift
//  MyBreakFast
//
//  Created by AUK on 27/07/16.
//  Copyright © 2016 AUK. All rights reserved.
//

import Foundation

class ADDVC: UIViewController {
    @IBOutlet var contentView: UIView!
    
    @IBOutlet var centerY: NSLayoutConstraint!
    @IBOutlet var imgView: UIImageView!
    @IBOutlet var textLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad();
        self.contentView.clipsToBounds = true;
        self.contentView.layer.cornerRadius = 7.0;
    }
    
    @IBAction func dismissView(sender: AnyObject) {
        self.centerY.constant = -(self.view.bounds.size.height - self.contentView.bounds.size.height + self.contentView.bounds.size.height/2);
        UIView.animateWithDuration(0.5, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.3, options: UIViewAnimationOptions.CurveEaseIn, animations: {
            self.view.layoutIfNeeded()
        }) { (finished) in
            self.dismissViewControllerAnimated(false, completion: nil)

        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.centerY.constant = 0;
        UIView.animateWithDuration(0.5, delay: 0.5, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.3, options: UIViewAnimationOptions.CurveEaseIn, animations: {
            self.view.layoutIfNeeded()
            }) { (finished) in
        }
    }
}