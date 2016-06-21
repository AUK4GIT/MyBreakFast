//
//  PlanCell.swift
//  MyBreakFast
//
//  Created by AUK on 18/06/16.
//  Copyright © 2016 AUK. All rights reserved.
//

import Foundation

class PlanCell: UICollectionViewCell {
    
    @IBOutlet  var nameLabel: UILabel!
    @IBOutlet  var priceLabel: UILabel!
    @IBOutlet  var imgView: UIImageView!
    @IBOutlet  var highlightView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override var selected: Bool {
        didSet{
            if selected {
                print("selected");
                self.imgView.hidden = false;
                self.highlightView.hidden = false;
            } else {
                print("unselected");
                self.imgView.hidden = true;
                self.highlightView.hidden = true;
            }
        }
    }
}