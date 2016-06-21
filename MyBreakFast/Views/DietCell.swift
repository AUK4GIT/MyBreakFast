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
    @IBOutlet  var highlightView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override var selected: Bool {
        didSet{
            if selected {
                print("selected");
//                self.contentView.backgroundColor = Constants.AppColors.lightGrey.color;
                self.nameLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 12.0)
//                self.recommendLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 11.0)

                self.highlightView.hidden = false;
            } else {
                print("unselected");
                self.nameLabel.font = UIFont(name: "HelveticaNeue-Medium", size: 10.0)
//                self.recommendLabel.font = UIFont(name: "HelveticaNeue-Medium", size: 10.0)

//                self.contentView.backgroundColor = UIColor.whiteColor();
                self.highlightView.hidden = true;
            }
        }
    }
}