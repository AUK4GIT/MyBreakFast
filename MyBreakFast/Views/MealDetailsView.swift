//
//  MealDetailsView.swift
//  MyBreakFast
//
//  Created by AUK on 25/06/16.
//  Copyright © 2016 AUK. All rights reserved.
//

import Foundation

class MealDetailsView: UIView {
    
    @IBOutlet var descrView: UIView!
    @IBOutlet var descrLbl: UILabel!

override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
    
    if self.descrLbl.hidden {
        self.showDescription()
    } else {
        self.hideDescription();
    }
}
    func setDescription(descr: String?){
        self.hideDescription()
        if let description = descr {
            self.descrLbl.text = description;
        }
    }
    
    func showDescription(){
        self.descrLbl.hidden = false
        self.descrLbl.alpha = 0.0;
        self.descrView.hidden = false
        self.descrView.alpha = 0.0;
        UIView.animateWithDuration(0.3, animations: {
            self.descrLbl.alpha = 1.0;
            self.descrView.alpha = 0.3;
            }, completion: { (completion) in
        })
    }
    
    func hideDescription(){
        UIView.animateWithDuration(0.3, animations: {
            self.descrLbl.alpha = 0.0;
            self.descrView.alpha = 0.0;
            }, completion: { (completion) in
                self.descrLbl.hidden = true
                self.descrView.hidden = true
        })
    }
}