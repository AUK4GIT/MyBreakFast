//
//  MultiSelCell.swift
//  MultiSelectSegmentCollectionView
//
//  Created by AUK on 04/07/16.
//  Copyright © 2016 AUK. All rights reserved.
//

import Foundation
import UIKit

class MultiSelCell: UICollectionViewCell {
    @IBOutlet var celllabel: UILabel!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var highlightView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override var selected: Bool{
        
        didSet{
            if selected {
                print("selected");
                self.highlightView.hidden = false;
            } else {
                print("unselected");
                self.highlightView.hidden = true;

            }
        }
    }
}