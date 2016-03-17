//
//  ItemPreViewVC.swift
//  MyBreakFast
//
//  Created by Uday Kiran Ailapaka on 02/11/15.
//  Copyright © 2015 AUK. All rights reserved.
//

import Foundation
import UIKit

class ItemPreViewVC: UIViewController {
    
    @IBOutlet var trailingGuide: NSLayoutConstraint!
    @IBOutlet var topGuide: NSLayoutConstraint!
    @IBOutlet var descriptionView: UITextView!
    @IBOutlet var imageView: UIImageView!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        print(self.topGuide.constant)

        self.trailingGuide.constant = 200;
        self.topGuide.constant = 200;
        self.view.layoutIfNeeded()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(self.topGuide.constant)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        UIView.animateWithDuration(1.0, delay: 0.3, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
            self.trailingGuide.constant = 8;
            self.topGuide.constant = 0;
            self.view.layoutIfNeeded()
            }, completion: nil)
    }
    
    @IBAction func dismissView(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}