//
//  LocationPicker.swift
//  MyBreakFast
//
//  Created by Uday Kiran Ailapaka on 16/11/15.
//  Copyright © 2015 AUK. All rights reserved.
//

import Foundation
import UIKit
import QuartzCore
@objc protocol LocationPickerDelegate: class{
    optional func didPickLocation(location: AnyObject)
}
class LocationPicker: UIViewController {
    
    @IBOutlet var maskView: UIView!
    @IBOutlet var horizantalCenterConstraint: NSLayoutConstraint!
    @IBOutlet var tableView: UITableView!
    var locationsArray: [AnyObject] = Helper.sharedInstance.getLocations()
    weak var locationDelegate : LocationPickerDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.horizantalCenterConstraint.constant = -self.view.bounds.size.width/2
        self.tableView.alpha = 0.0
        self.tableView.registerNib(UINib(nibName: "PopCell", bundle: nil), forCellReuseIdentifier: "PopCell")
        self.tableView.layer.cornerRadius = 10.0
        self.tableView.sectionHeaderHeight = 35;
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
            self.tableView.alpha = 1.0
            self.maskView.alpha = 0.5;
            }, completion: nil)
        
    }

    
    // MARK: Tableview delegates & datasources
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Choose delivery location"
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.closeView(self)
        self.locationDelegate?.didPickLocation!(self.locationsArray[indexPath.row])
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.locationsArray.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell:PopCell = tableView.dequeueReusableCellWithIdentifier("PopCell") as! PopCell
        cell.backgroundColor = UIColor.clearColor()
        let location: Locations = self.locationsArray[indexPath.row] as! Locations
        cell.cellTextLabel?.text = location.locationName
        return cell
    }
   
    @IBAction func closeView(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)

    }
}