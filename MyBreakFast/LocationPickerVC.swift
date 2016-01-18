//
//  LocationPickerVC.swift
//  MyBreakFast
//
//  Created by Uday Kiran Ailapaka on 25/12/15.
//  Copyright © 2015 AUK. All rights reserved.
//

import Foundation

@objc protocol LocationPickerVCDelegate : class {
    optional func didSelectLocation(locationObj: AnyObject)
}

class LocationPickerVC: UIViewController {
    
    @IBOutlet weak var maskView: UIView!
    @IBOutlet weak var locationPicker: UIPickerView!
    weak var delegate: LocationPickerVCDelegate?
    var locationsArray: [AnyObject]?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.locationsArray = Helper.sharedInstance.getLocations()
        if self.locationsArray?.count == 0 {
            Helper.sharedInstance.fetchLocations({ (response) -> () in
                self.locationsArray = Helper.sharedInstance.getLocations()
                self.locationPicker.reloadAllComponents();
            })
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        UIView.animateWithDuration(0.3, delay: 0.2, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
            self.maskView.alpha = 0.5
            }, completion: nil)
        
    }
    
    @IBAction func didSelectLocation(locationObj: AnyObject){
    
        if self.locationsArray?.count>0{
        self.delegate?.didSelectLocation!(self.locationsArray![self.locationPicker.selectedRowInComponent(0)]);
        }
        self.dismissVC()
    }
    
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
    
    // MARK: UIPickerViewDataSource
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView)->Int
    {
        return 1;
    }
    
     func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return (self.locationsArray?.count)!;
    }
    
    // MARK: UIPickerViewDelegate
    
    func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView!) -> UIView {
        
        let locObj = self.locationsArray![row] as! Locations
        var pickerLabel = view as? UILabel;
        
        if (pickerLabel == nil)
        {
            pickerLabel = UILabel()
            pickerLabel?.textColor = UIColor(red: 200.0/255.0, green: 5.0/255.0, blue: 15.0/255.0, alpha: 1.0);
            pickerLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 16)
            pickerLabel?.textAlignment = NSTextAlignment.Center
        }
        
        pickerLabel?.text = locObj.locationName
        
        return pickerLabel!;
    }


}