//
//  AddressCell.swift
//  MyBreakFast
//
//  Created by Uday Kiran Ailapaka on 17/01/16.
//  Copyright © 2016 AUK. All rights reserved.
//

import Foundation

class AddressCell: UICollectionViewCell {
    
    @IBOutlet  var secondLine: UITextField!
    @IBOutlet  var firstLine: UILabel!
    @IBOutlet  var locationButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}