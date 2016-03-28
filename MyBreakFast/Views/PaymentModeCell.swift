//
//  PaymentModeCell.swift
//  MyBreakFast
//
//  Created by Uday Kiran Ailapaka on 04/01/16.
//  Copyright © 2016 AUK. All rights reserved.
//

import Foundation

class PaymentModeCell: UICollectionViewCell {
    
    @IBOutlet var citrusButton: UIButton!
    @IBOutlet var codButton: UIButton!
    @IBAction func selectModeOfPayment(sender: AnyObject) {
        
        if let button = sender as? UIButton {
            if button.isEqual(self.codButton) {
                button.selected = true;
                self.citrusButton.selected = false;
                Helper.sharedInstance.order!.modeOfPayment = paymentType.COD;
            } else {
                button.selected = true;
                self.codButton.selected = false;
                Helper.sharedInstance.order!.modeOfPayment = paymentType.PG;
                
            }
        }
        
    }
}