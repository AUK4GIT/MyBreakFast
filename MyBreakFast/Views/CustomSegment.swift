//
//  CustomSegment.swift
//  MyBreakFast
//
//  Created by Uday Kiran Ailapaka on 20/12/15.
//  Copyright © 2015 AUK. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable class CustomSegment: UIView {
       
    override func awakeFromNib() {
        super.awakeFromNib()
        print("gggg: \(self.subviews)")
        if (self.subviews.count == 0) {
            let array: [AnyObject] = NSBundle.mainBundle().loadNibNamed("CustomSegment", owner: self, options: nil);
            let cusView: UIView = array[0] as! UIView;
            self.addSubview(cusView);
        }
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

    }
    
    @IBAction func buttonSelected(sender: UIButton) {
        if sender.selected {
            return;
        } else {
            for vw in self.subviews {
                let button = vw as! UIButton;
                button.selected = false;
            }
            sender.selected = true;
            sender.addTarget(nil, action: "segmentAction:", forControlEvents: UIControlEvents.TouchUpInside);
        }
    }
    
}