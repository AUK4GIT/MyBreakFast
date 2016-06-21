//
//  DietCell.swift
//  MyBreakFast
//
//  Created by AUK on 18/06/16.
//  Copyright © 2016 AUK. All rights reserved.
//

import Foundation

class DietCell: UICollectionViewCell {
    
    @IBOutlet  var nameLabel: UILabel!
    @IBOutlet  var recommendLabel: UILabel!
    @IBOutlet  var imageV: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override var selected: Bool {
        didSet{
            if selected {
                print("selected");
                self.contentView.backgroundColor = Constants.AppColors.lightGrey.color;
            } else {
                print("unselected");
                self.contentView.backgroundColor = UIColor.whiteColor();
            }
        }
    }
}