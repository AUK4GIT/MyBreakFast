//
//  FilterVC.swift
//  MyBreakFast
//
//  Created by Uday Kiran Ailapaka on 17/03/16.
//  Copyright © 2016 AUK. All rights reserved.
//

import Foundation
@objc protocol FilterProtocol : class
{
    optional func didFilterWithString(searchString: String);
}
class FIlterVC: CustomModalViewController {
    
    @IBOutlet var tableView: UITableView!
    var filtersArray: [AnyObject]?
    weak var delegate: FilterProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad();
        self.filtersArray = Constants.StaticContent.Filters;
        self.tableView.registerNib(UINib(nibName: "FilterCell", bundle: nil), forCellReuseIdentifier: "PopCell")
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "FilterCell")

    }
    
    @IBAction func closeView(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: Tableview delegates & datasources
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.view.endEditing(true);
        let str = self.filtersArray![indexPath.row]["filtervalue"] as! String
        self.delegate?.didFilterWithString!(str)
        self.closeView(self)
//        self.locationDelegate?.didPickLocation!(self.locationsArray![indexPath.row])
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.filtersArray!.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier("FilterCell")!
        cell.textLabel?.text = self.filtersArray![indexPath.row]["filterName"] as? String
        cell.imageView?.image = UIImage(named: (self.filtersArray![indexPath.row]["imageName"] as? String)!);
        cell.textLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 14.0);
        cell.textLabel?.adjustFontToRealIPhoneSize = true;
        let color = self.filtersArray![indexPath.row]["color"] as? String;
        if color == "green" {
            cell.textLabel?.textColor = UIColor.greenColor()
        } else if color == "red" {
            cell.textLabel?.textColor = UIColor.redColor()
        } else if color == "yellow"{
            cell.textLabel?.textColor = UIColor.yellowColor()
        } else {
            cell.textLabel?.textColor = UIColor.darkTextColor()
        }
        return cell
    }
    
}