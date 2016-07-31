//
//  PaymentModeCell.swift
//  MyBreakFast
//
//  Created by Uday Kiran Ailapaka on 04/01/16.
//  Copyright © 2016 AUK. All rights reserved.
//

import Foundation

class PaymentModeCell: UICollectionViewCell {
    
    @IBOutlet weak var bgView: UIView!
    @IBOutlet var PaymentRadioButton: [UIButton]!
    @IBAction func selectModeOfPayment(sender: AnyObject) {
        
        for view in bgView.subviews{
            if let button = view as? UIButton{
                button.selected = false;
            }
        }
        
        if let button = sender as? UIButton {
            button.selected = true;
            switch button.tag {
            case 0:
                Helper.sharedInstance.order!.modeOfPayment = PaymentType.COD;

                break;
            case 1:
                Helper.sharedInstance.order!.modeOfPayment = PaymentType.PAYTM;

                break;
            case 2:
                
                Helper.sharedInstance.order!.modeOfPayment = PaymentType.CITRUS;

                break;
            case 3:
                Helper.sharedInstance.order!.modeOfPayment = PaymentType.CARDS;

                break;
            default:
                Helper.sharedInstance.order!.modeOfPayment = PaymentType.COD;
                
                break;
            }
        }
        sender.sendAction(#selector(CartVC.didPickPaymentType), to: nil, forEvent: nil)
    }
}