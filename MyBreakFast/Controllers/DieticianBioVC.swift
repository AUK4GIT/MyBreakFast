//
//  DieticianBioVC.swift
//  MyBreakFast
//
//  Created by AUK on 23/06/16.
//  Copyright © 2016 AUK. All rights reserved.
//

import Foundation

class DieticianBioVC: UIViewController {
    
    @IBOutlet var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.textView.layer.cornerRadius = 10.0;
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}