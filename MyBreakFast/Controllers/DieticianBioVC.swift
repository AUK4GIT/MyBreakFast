//
//  DieticianBioVC.swift
//  MyBreakFast
//
//  Created by AUK on 23/06/16.
//  Copyright © 2016 AUK. All rights reserved.
//

import Foundation

class DieticianBioVC: UIViewController {
    
    @IBOutlet var textView: UILabel!
    @IBOutlet var labelBGView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.labelBGView!.alpha = 0.0;
        self.labelBGView!.layer.cornerRadius = 10.0;
    }
    
    func showDieticianDescription(descr: String?){
        self.labelBGView!.alpha = 0.0;
        UIView.animateWithDuration(0.3, animations: {
            self.textView.text = descr;
            self.labelBGView!.alpha = 1.0;
            self.view.layoutIfNeeded()
            }) { (completion) in
                
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        let touch = touches.first! as UITouch
        if !CGRectContainsPoint(self.labelBGView.frame, touch.locationInView(self.view)){
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
}