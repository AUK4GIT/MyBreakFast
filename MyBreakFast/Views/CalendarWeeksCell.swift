//
//  CalendarWeeksCell.swift
//  MyBreakFast
//
//  Created by AUK on 25/06/16.
//  Copyright © 2016 AUK. All rights reserved.
//

import Foundation

class CalendarWeeksCell: UICollectionViewCell {
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var highlightView: UIView!
    
    override var selected: Bool {
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