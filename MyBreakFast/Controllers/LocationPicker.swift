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
    optional func didPickLocation(location: AnyObject?)
}
class LocationPicker: CustomModalViewController {
    
    @IBOutlet  var searchField: UITextField!
    @IBOutlet var horizantalCenterConstraint: NSLayoutConstraint!
    @IBOutlet var tableView: UITableView!
    var locationsArray: [AnyObject]?
    weak var locationDelegate : LocationPickerDelegate?
    var searchString = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        self.locationsArray = [];
        self.tableView.registerNib(UINib(nibName: "PopCell", bundle: nil), forCellReuseIdentifier: "PopCell")
        self.tableView.sectionHeaderHeight = 0;

    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        self.locationsArray = Helper.sharedInstance.getLocations()
            if self.locationsArray?.count == 0 {
                Helper.sharedInstance.fetchLocations({ (response) -> () in
                    self.locationsArray = Helper.sharedInstance.getLocations()
                    
                    if self.locationsArray?.count == 0 {
                    let alertController = UIAlertController(title: "First Eat", message: "Location not found. Please check your internet connection.", preferredStyle: .Alert)
                    let searchAction = UIAlertAction(title: "OK", style: .Default) { (_) in
                        
                            self.dismissViewControllerAnimated(true, completion: nil)
                    }
                    alertController.addAction(searchAction)
                    self.presentViewController(alertController, animated: true) {
                        alertController.view.tintColor = Constants.StaticContent.AppThemeColor;
                    }
                    } else {
                        self.searchField.becomeFirstResponder();
                    }
                    
                })
            } else {
                self.searchField.becomeFirstResponder();
        }

    }

    
    // MARK: Tableview delegates & datasources
    
//    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return "  Choose a delivery location"
//    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.view.endEditing(true);
        self.locationDelegate?.didPickLocation!(self.locationsArray![indexPath.row])
        self.closeView(self)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.locationsArray!.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell:PopCell = tableView.dequeueReusableCellWithIdentifier("PopCell") as! PopCell
        cell.backgroundColor = UIColor.clearColor()
        let location: Locations = self.locationsArray![indexPath.row] as! Locations
        cell.cellTextLabel?.text = location.locationName
        cell.cellTextLabel?.textColor = UIColor.whiteColor()
        return cell
    }
   
    @IBAction func closeView(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: TextField Delegates
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        self.locationDelegate?.didPickLocation!(nil)
        self.dismissViewControllerAnimated(true, completion: nil)
        return true
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool
    {
        if string == "" {
            self.searchString = textField.text!.substringToIndex(textField.text!.characters.endIndex.predecessor());
        } else {
            self.searchString = textField.text!+string;
        }
        self.locationsArray = Helper.sharedInstance.getLocationsForSearchString(self.searchString);
        print(self.searchString, self.locationsArray?.count);

        self.tableView.reloadData()

        return true;
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first! as UITouch
        if !CGRectContainsPoint(self.tableView.frame, touch.locationInView(self.view)){
            self.locationDelegate?.didPickLocation!(nil)
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
}