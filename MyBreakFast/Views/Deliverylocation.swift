//
//  Deliverylocation.swift
//  MyBreakFast
//
//  Created by Uday Kiran Ailapaka on 22/11/15.
//  Copyright © 2015 AUK. All rights reserved.
//

import Foundation
class Deliverylocation: UICollectionViewCell {
    
    @IBOutlet var textView: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.textView.layer.borderColor = UIColor.blackColor().CGColor
        self.textView.layer.borderWidth = 1
        
    }

}