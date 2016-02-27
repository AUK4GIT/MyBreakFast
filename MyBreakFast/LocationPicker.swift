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
class LocationPicker: CustomModalViewController {
    
    @IBOutlet weak var searchField: UITextField!
    @IBOutlet var horizantalCenterConstraint: NSLayoutConstraint!
    @IBOutlet var tableView: UITableView!
    var locationsArray: [AnyObject]?
    weak var locationDelegate : LocationPickerDelegate?
    var searchString = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.locationsArray = Helper.sharedInstance.getLocations()
        self.tableView.registerNib(UINib(nibName: "PopCell", bundle: nil), forCellReuseIdentifier: "PopCell")
        self.tableView.sectionHeaderHeight = 0;
        self.searchField.becomeFirstResponder();

    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if self.locationsArray?.count == 0 {
            let alertController = UIAlertController(title: "First Eat", message: "Location not found.", preferredStyle: .Alert)
            let searchAction = UIAlertAction(title: "OK", style: .Default) { (_) in
                self.dismissViewControllerAnimated(true, completion: nil)
            }
            alertController.addAction(searchAction)
            self.presentViewController(alertController, animated: true) {
                alertController.view.tintColor = Constants.StaticContent.AppThemeColor;
                
            }
        }

    }

    
    // MARK: Tableview delegates & datasources
    
//    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return "  Choose a delivery location"
//    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.view.endEditing(true);
        self.closeView(self)
        self.locationDelegate?.didPickLocation!(self.locationsArray![indexPath.row])
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
        return true
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool
    {
        if string == "" {
            self.searchString = textField.text!.substringToIndex(textField.text!.characters.endIndex.predecessor());
        } else {
            self.searchString = textField.text!+string;
        }
        print(self.searchString);
        self.locationsArray = Helper.sharedInstance.getLocationsForSearchString(self.searchString);
        self.tableView.reloadData()

        return true;
    }
    
//    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
//        let touch = touches.first! as UITouch
//        if !CGRectContainsPoint(self.tableView.frame, touch.locationInView(self.view)){
//            self.dismissViewControllerAnimated(true, completion: nil)
//        }
//    }
}