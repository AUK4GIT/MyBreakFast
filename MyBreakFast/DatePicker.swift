//
//  DatePicker.swift
//  MyBreakFast
//
//  Created by Uday Kiran Ailapaka on 16/11/15.
//  Copyright © 2015 AUK. All rights reserved.
//

import Foundation
import UIKit
import QuartzCore

@objc protocol DatePickerProtocol : class {
    
    optional func didSelectDate(date: AnyObject)
}

class DatePicker: UIViewController {

    @IBOutlet var maskView: UIView!
    @IBOutlet var horizantalCenterConstraint: NSLayoutConstraint!
    @IBOutlet var tableView: UITableView!
    var datesArray: [AnyObject] = Helper.sharedInstance.getWeekDates()
    let dateFormatter = NSDateFormatter()
    weak var delegate: DatePickerProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.registerNib(UINib(nibName: "PopCell", bundle: nil), forCellReuseIdentifier: "PopCell")
        self.horizantalCenterConstraint.constant = -self.view.bounds.size.width/2
        self.tableView.alpha = 0.0;
        dateFormatter.dateFormat = "EEEE, MMM dd"
        self.tableView.sectionHeaderHeight = 35;
        self.tableView.layer.cornerRadius = 10.0
        self.maskView.alpha = 0.0;
        
        let tempImageView : UIImageView = UIImageView(image: UIImage(named: "menu_logo.png"))
        tempImageView.autoresizingMask = [UIViewAutoresizing.FlexibleWidth, UIViewAutoresizing.FlexibleHeight]
        tempImageView.contentMode = UIViewContentMode.ScaleAspectFit
        tempImageView.alpha = 0.2
        self.tableView.backgroundView = tempImageView;
        self.tableView.sendSubviewToBack(tempImageView);
        tempImageView.contentMode = UIViewContentMode.Center

    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        self.horizantalCenterConstraint.constant = 0
        UIView.animateWithDuration(0.2, animations: { () -> Void in
            self.view.layoutIfNeeded()
            self.tableView.alpha = 1.0;
            self.maskView.alpha = 0.5;
            }, completion: nil)
        
    }
    
    // MARK: Tableview delegates & datasources
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Select any Date"
    }

    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            self.dismissViewControllerAnimated(true) { () -> Void in
                self.delegate?.didSelectDate!(self.datesArray[indexPath.row])                
            }

        }
        

    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.datesArray.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell:PopCell = tableView.dequeueReusableCellWithIdentifier("PopCell") as! PopCell
        cell.backgroundColor = UIColor.clearColor()
        cell.cellTextLabel?.text = self.dateFormatter.stringFromDate(self.datesArray[indexPath.row] as! NSDate)
        return cell
    }
    @IBAction func closeView(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

}