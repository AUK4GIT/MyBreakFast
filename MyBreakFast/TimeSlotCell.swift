//
//  TimeSlotCell.swift
//  MyBreakFast
//
//  Created by Uday Kiran Ailapaka on 28/12/15.
//  Copyright © 2015 AUK. All rights reserved.
//

import Foundation

class TimeSlotCell: UICollectionViewCell {
    
    @IBOutlet  var timeLabel: UILabel!
    var currentTime = NSDate()
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let timeFormtter = NSDateFormatter()
        timeFormtter.dateFormat = "hh:mm a"
        self.currentTime = timeFormtter.dateFromString(timeFormtter.stringFromDate(self.currentTime))!
        
        if Helper.sharedInstance.currenttimeSlot != "" {
            timeFormtter.dateFormat = "HH:mm:ss"
            self.currentTime = timeFormtter.dateFromString(Helper.sharedInstance.currenttimeSlot)!
        }
        self.timeLabel.font = UIFont(name: "HelveticaNeue-Light", size: 13.0);

    }
    
    override var selected: Bool {
        get {
            return super.selected
        }
        set {
            self.timeLabel.font = UIFont(name: "HelveticaNeue-Light", size: 13.0);

            if newValue {
                super.selected = true
                self.timeLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 14.0);
            } else if newValue == false {
                super.selected = false
                self.timeLabel.font = UIFont(name: "HelveticaNeue-Light", size: 13.0);
            }
        }
    }
    
    func setContent(timeSlot: TimeSlots){
        
        let timeFormtter = NSDateFormatter()
        timeFormtter.dateFormat = "HH:mm:ss"
        timeFormtter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        let startTime = timeFormtter.dateFromString(timeSlot.starttime!);
        var endTime = timeFormtter.dateFromString(timeSlot.endtime!);
        if endTime == nil {
            endTime = timeFormtter.dateFromString("00:00:00");
        }
        
        timeFormtter.dateFormat = "hh:mm a"
        
        let result: NSComparisonResult  = endTime?.compare(self.currentTime) ?? NSComparisonResult.OrderedAscending
        if result == NSComparisonResult.OrderedAscending && !Helper.sharedInstance.isOrderForTomorrow
        {
            print("endTime is before than currentime");
            timeSlot.status = "InActive"
        }

        self.timeLabel.text = timeFormtter.stringFromDate(startTime!)+" - "+timeFormtter.stringFromDate(endTime!)
        if timeSlot.status == "Active"{
            self.timeLabel.textColor = Constants.StaticContent.AppThemeColor;
        } else {
            self.timeLabel.textColor = UIColor.grayColor()
        }
    
    }

}