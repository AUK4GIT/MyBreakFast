//
//  TotalBill.swift
//  MyBreakFast
//
//  Created by Uday Kiran Ailapaka on 04/01/16.
//  Copyright © 2016 AUK. All rights reserved.
//

import Foundation

class TotalBill: UICollectionViewCell {
    @IBOutlet weak var billLabel: UILabel!
 
    override func awakeFromNib() {
        super.awakeFromNib()
        
//        Helper.sharedInstance.getOrderCountandPrice { (count, price) -> () in
//            let vatPercent = 0.125;
//            let scPercent = 0.005;
//            let vatAmount = Double(price) * vatPercent
//            let scAmount = vatAmount * scPercent
//            let totalPayableAmount = price+Int(ceil(vatAmount+scAmount))
//            Helper.sharedInstance.order?.totalAmountPayable = String(totalPayableAmount);
//            Helper.sharedInstance.order?.vatAmount = String(vatAmount);
//            Helper.sharedInstance.order?.serviceChargeAmount = String(scAmount);
//            self.billLabel.text = "₹ "+String(totalPayableAmount)
//        }
    }
}