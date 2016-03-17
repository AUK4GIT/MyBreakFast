//
//  ChangeCell.swift
//  MyBreakFast
//
//  Created by Uday Kiran Ailapaka on 04/01/16.
//  Copyright © 2016 AUK. All rights reserved.
//

import Foundation
class ChangeCell: UICollectionViewCell {
    
    @IBOutlet  var hundredButton: UIButton!
    @IBOutlet  var fiveHundredButton: UIButton!
//    @IBOutlet  var thousandButton: UIButton!
    
    @IBAction func changeAction(sender: UIButton) {
        
        self.hundredButton.selected = false;
        self.fiveHundredButton.selected = false;
//        self.thousandButton.selected = false;
        
        switch sender.tag {
        
        case 100:
            self.hundredButton.selected = true;
            Helper.sharedInstance.order?.change = "100";

        break;
            
        case 500:
            self.fiveHundredButton.selected = true;
            Helper.sharedInstance.order?.change = "500";
        break;
            
        case 1000:
//            self.thousandButton.selected = true;
            Helper.sharedInstance.order?.change = "1000";

        break;
            
        default:
            break;
        }
    }
    
}