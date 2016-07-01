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
    
    func disableSegmentAtIndex(index :Int){
        let sView = self.viewWithTag(index)
        sView?.userInteractionEnabled = true;
        sView?.backgroundColor = UIColor.lightGrayColor();
        let label: UILabel = sView!.viewWithTag(5) as! UILabel
        label.text = "No Meal";

    }
    
    func setSelectedSlot(slot: String?, forIndex index: Int){
        let sView = self.viewWithTag(index)
        let label: UILabel = sView!.viewWithTag(6) as! UILabel
        label.text = slot;
    }
    
    func displayNewSelectedIndex(){
        for (_, view) in self.subviews.enumerate() {
            view.backgroundColor = dColor
            let label: UILabel = view.viewWithTag(5) as! UILabel
            label.textColor = sColor;
            if view.tag == selectedIndex {
                view.backgroundColor = sColor
                let label: UILabel = view.viewWithTag(5) as! UILabel
                label.textColor = dColor;
            } else if view.userInteractionEnabled == true {
                view.backgroundColor = UIColor.lightGrayColor()
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
}