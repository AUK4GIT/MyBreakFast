//
//  DatePickerVC.swift
//  MyBreakFast
//
//  Created by Uday Kiran Ailapaka on 24/12/15.
//  Copyright © 2015 AUK. All rights reserved.
//

import Foundation
//import PIDatePicker

@objc protocol DatePickerVCDelegate : class {
    
    optional func didSelectDate(date: AnyObject)
}

class DatePickerVC: UIViewController {
    
    @IBOutlet weak var maskView: UIView!
//    @IBOutlet weak var datePicker: PIDatePicker!
    
    weak var delegate: DatePickerVCDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.maskView.alpha = 0.0
//        self.datePicker.textColor = UIColor(red: 200.0/255.0, green: 5.0/255.0, blue: 15.0/255.0, alpha: 1.0)
//        self.datePicker.locale = NSLocale(localeIdentifier: "en_US");
//        self.datePicker.setDate(NSDate(), animated: true);
//        self.datePicker.minimumDate = NSDate()
//        self.datePicker.maximumDate = NSDate().dateByAddingTimeInterval(NSTimeInterval(60*60*24*6));
//        self.datePicker.addTarget(self, action: "didChangeDate:", forControlEvents: UIControlEvents.ValueChanged)

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        UIView.animateWithDuration(0.3, delay: 0.2, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
            self.maskView.alpha = 0.5
            }, completion: nil)
        
    }
    
//    @IBAction func didSelectDate(sender: PIDatePicker){
    
//        print(self.datePicker.date);
//        self.delegate?.didSelectDate!(self.datePicker.date);
//        self.dismissVC()
//    }
    
//    @IBAction func didChangeDate(sender: PIDatePicker){
//        
//        
//        // When `setDate:` is called, if the passed date argument exactly matches the Picker's date property's value, the Picker will do nothing. So, offset the passed date argument by one second, ensuring the Picker scrolls every time.
//        let oneSecondAfterPickersDate: NSDate = sender.date.dateByAddingTimeInterval(1)
//        if ( sender.date.compare(sender.minimumDate) == NSComparisonResult.OrderedSame ) {
//            print("date is at or below the minimum") ;
//            sender.setDate(oneSecondAfterPickersDate, animated: true);
//        }
//        else if ( sender.date.compare(sender.maximumDate) == NSComparisonResult.OrderedSame ) {
//            print("date is at or above the maximum") ;
//            sender.setDate(oneSecondAfterPickersDate, animated: true);
//            
//        }
//        
//    }

    
    @IBAction func cancelAction(sender: AnyObject) {
        self.dismissVC()
    }
    
    func dismissVC() {
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.maskView.alpha = 0.0;
            }) { (Bool) -> Void in
                self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
}