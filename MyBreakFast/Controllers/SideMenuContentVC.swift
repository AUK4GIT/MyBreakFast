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

    @IBOutlet var headerBGView: UIView!
    @IBOutlet  var locationName: UILabel!
    @IBOutlet  var userName: UILabel!
//    let gradient: CAGradientLayer = CAGradientLayer()
    var contentArray: [String] = Constants.StaticContent.SideMenuList;
    weak var delegate: Slidemenuprotocol?

    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad(){
        super.viewDidLoad();
        self.headerBGView.backgroundColor = Constants.AppColors.blue.color;
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
    }
    // MARK: Tableview delegates & datasources
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch indexPath.row {
        case 0:
            self.delegate?.selectedViewController((self.storyboard?.instantiateViewControllerWithIdentifier("SubscriptionMenuVC"))!)
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
        case 6:
            self.delegate?.selectedViewController((self.storyboard?.instantiateViewControllerWithIdentifier("TermsVC"))!)
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
        bView.backgroundColor = Constants.AppColors.highlightedCellBG.color
        cell.selectedBackgroundView = bView
        
        switch indexPath.row {
        case 0:
            cell.imageView?.image = UIImage(imageLiteral: "Menu.png");
            break;
        case 1:
            cell.imageView?.image = UIImage(imageLiteral: "MyOrders.png");
            break;
        case 2:
            cell.imageView?.image = UIImage(imageLiteral: "Aboutus.png");
            break;
        case 3:
            cell.imageView?.image = UIImage(imageLiteral: "Contactus.png");
            break;
        case 4:
            cell.imageView?.image = UIImage(imageLiteral: "Rateus.png");
            break;
        case 5:
            cell.imageView?.image = UIImage(imageLiteral: "Refer.png");
            break;
        case 6:
            cell.imageView?.image = UIImage(imageLiteral: "Terms.png");
            break;
        default:
            break;
        }
        return cell
    }
}