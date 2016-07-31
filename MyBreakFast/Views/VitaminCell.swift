//
//  VitaminCell.swift
//  MyBreakFast
//
//  Created by Uday Kiran Ailapaka on 06/12/15.
//  Copyright © 2015 AUK. All rights reserved.
//

import Foundation

class VitaminCell: UICollectionViewCell {
    
    @IBOutlet var calValue: UILabel!
    @IBOutlet var label: UILabel!
    @IBOutlet var circleView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.circleView.layer.cornerRadius = 5.0;
        self.circleView.layer.borderWidth = 1.0;
        self.circleView.layer.borderColor = (Constants.AppColors.blue.color as UIColor).CGColor;

    }
}