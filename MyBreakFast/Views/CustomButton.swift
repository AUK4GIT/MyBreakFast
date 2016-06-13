//
//  CustomButton.swift
//  MyBreakFast
//
//  Created by AUK on 10/06/16.
//  Copyright © 2016 AUK. All rights reserved.
//

import Foundation

@IBDesignable class CustomButton: UIControl {
    
    var dColor: UIColor? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        dColor = self.backgroundColor
    }
    
    override var highlighted: Bool {
        didSet{
            if highlighted {
                self.backgroundColor = UIColor.lightGrayColor()
            } else {
                self.backgroundColor = dColor
            }
        }
    }
    
}