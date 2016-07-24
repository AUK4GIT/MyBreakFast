//
//  FilterVC.swift
//  MyBreakFast
//
//  Created by Uday Kiran Ailapaka on 17/03/16.
//  Copyright © 2016 AUK. All rights reserved.
//

import Foundation
//@objc protocol FilterProtocol : class
//{
//    optional func didFilterWithString(searchString: Set<String>);
//}
class FIlterVC: CustomModalViewController {
    
    @IBOutlet var tableView: UITableView!
    var filtersArray: [AnyObject]?
//    weak var delegate: FilterProtocol?
    var filters: Set<String> = []
    
    override func viewDidLoad() {
        super.viewDidLoad();
//        self.filtersArray = Constants.StaticContent.Filters;
        self.filtersArray = [];
        self.tableView.registerNib(UINib(nibName: "FilterCell", bundle: nil), forCellReuseIdentifier: "PopCell")
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "FilterCell")

    }
    
    @IBAction func closeView(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: Tableview delegates & datasources
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

        self.filters.insert((self.filtersArray![indexPath.row]["filtervalue"] as! String))
//        self.delegate?.didFilterWithString!(self.filters)
    }
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
            self.filters.remove((self.filtersArray![indexPath.row]["filtervalue"] as! String))
//        self.delegate?.didFilterWithString!(self.filters)
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
        return cell
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first! as UITouch
        if !CGRectContainsPoint(self.tableView.frame, touch.locationInView(self.view)){
            self.closeView(self);
        }
    }
}