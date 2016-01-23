//
//  SideMenuContentVC.swift
//  MyBreakFast
//
//  Created by Uday Kiran Ailapaka on 28/10/15.
//  Copyright © 2015 AUK. All rights reserved.
//

import Foundation
import UIKit
//import QuartzCore

protocol Slidemenuprotocol: class  {
    func selectedViewController(vc: UIViewController)
}

class SideMenuContentVC: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var locationName: UILabel!
    @IBOutlet weak var userName: UILabel!
//    let gradient: CAGradientLayer = CAGradientLayer()
    var contentArray: [String] = Constants.StaticContent.SideMenuList;
    weak var delegate: Slidemenuprotocol?

    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad(){
        super.viewDidLoad();

        self.tableView.registerNib(UINib(nibName: "SideMenuCell", bundle: nil), forCellReuseIdentifier: "cell")
        self.tableView.rowHeight = (UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Phone) ? 55.0 : 75.0;
        self.tableView.backgroundColor = UIColor.clearColor()
//        self.view.layer.insertSublayer(self.gradient, atIndex: 0)
        
        self.userName.text = "Hello! Guest"
        self.locationName.text = "----------";
            }
    
    func setUserDetails(){
        if let userdetails = Helper.sharedInstance.getUserNameandUserPhoneNumber()
        {
            if let usrName = userdetails.userName {
                self.userName.text = "Hello! "+usrName;
            }
            if let phName = userdetails.phoneNumber {
                self.locationName.text = phName;
            }
        }

    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.setUserDetails();

    }

    override func viewWillLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
//        self.gradient.frame = self.view.bounds;
//        self.gradient.colors = [UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1.0).CGColor, UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 150.0/255.0, alpha: 1.0).CGColor];

    }
    // MARK: Tableview delegates & datasources
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch indexPath.row {
        case 0:
            self.delegate?.selectedViewController((self.storyboard?.instantiateViewControllerWithIdentifier("MenuVC"))!)
            break;
        case 1:
            self.delegate?.selectedViewController((self.storyboard?.instantiateViewControllerWithIdentifier("MyOrdersVC"))!)
            break;
        case 2:
            self.delegate?.selectedViewController((self.storyboard?.instantiateViewControllerWithIdentifier("AboutUsVC"))!)
            break;
        case 3:
            self.delegate?.selectedViewController((self.storyboard?.instantiateViewControllerWithIdentifier("ContactUsVC"))!)
            break;
        case 4:
            self.delegate?.selectedViewController((self.storyboard?.instantiateViewControllerWithIdentifier("FeedBackVC"))!)
            break;
        case 5:
            self.delegate?.selectedViewController((self.storyboard?.instantiateViewControllerWithIdentifier("ReferralVC"))!)
            break;
    
        default:
            break;
        }
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return contentArray.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell:SideMenuCell = tableView.dequeueReusableCellWithIdentifier("cell")! as! SideMenuCell
        cell.backgroundColor = UIColor.clearColor()
//        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator;
        cell.cellTextLabel?.textColor = UIColor.darkGrayColor()
        cell.cellTextLabel?.text = contentArray[indexPath.row]
//        cell.cellTextLabel?.font = UIFont(name: "Helvetica Neue", size: 22.0)

        let bView = UIView(frame: cell.bounds)
        bView.backgroundColor = UIColor(red: 200.0/255.0, green: 200.0/255.0, blue: 200.0/255.0, alpha: 1.0)
        cell.selectedBackgroundView = bView
        return cell
    }
}