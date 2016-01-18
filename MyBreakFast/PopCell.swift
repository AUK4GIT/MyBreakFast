//
//  PopCell.swift
//  MyBreakFast
//
//  Created by Uday Kiran Ailapaka on 29/11/15.
//  Copyright © 2015 AUK. All rights reserved.
//

import Foundation

class PopCell: UITableViewCell {
    
    @IBOutlet var imageSelected: UIImageView!
    @IBOutlet var cellTextLabel: UILabel!
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if self.selected {
            self.imageSelected.hidden = false;
        } else {
            self.imageSelected.hidden = true;
        }
    }
}