//
//  CustomSegmentControl.swift
//  MyBreakFast
//
//  Created by AUK on 13/06/16.
//  Copyright © 2016 AUK. All rights reserved.
//

import Foundation

@IBDesignable class CustomSegmentControl: UIControl {
    
    @IBInspectable var dColor: UIColor = UIColor.whiteColor()
    @IBInspectable var sColor: UIColor = UIColor.greenColor()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    var selectedIndex : Int = 0 {
        didSet {
            displayNewSelectedIndex()
        }
    }
    
    func displayNewSelectedIndex(){
        for (index, view) in self.subviews.enumerate() {
            view.backgroundColor = dColor
            let label: UILabel = view.viewWithTag(5) as! UILabel
            label.textColor = sColor;
            if view.tag == selectedIndex {
                view.backgroundColor = sColor
                let label: UILabel = view.viewWithTag(5) as! UILabel
                label.textColor = dColor;
            }
        }
    }
    
    override internal func beginTrackingWithTouch(touch: UITouch, withEvent event: UIEvent?) -> Bool {
        
        let location = touch.locationInView(self)
        
        var calculatedIndex : Int?
        for (index, item) in self.subviews.enumerate() {
            if item.frame.contains(location) {
                calculatedIndex = index
            }
        }
        if calculatedIndex != nil {
            selectedIndex = calculatedIndex!
            sendActionsForControlEvents(.ValueChanged)
        }
        
        return false
    }
    /*
    override internal func continueTrackingWithTouch(touch: UITouch, withEvent event: UIEvent?) -> Bool {
    
    }
    override internal func endTrackingWithTouch(touch: UITouch?, withEvent event: UIEvent?) {
    
    }
    override internal func cancelTrackingWithEvent(event: UIEvent?) {
    
    }
 */
}