//
//  ViewController.swift
//  MyBreakFast
//
//  Created by Uday Kiran Ailapaka on 28/10/15.
//  Copyright © 2015 AUK. All rights reserved.
//

import UIKit

public extension UIDevice {
    
    var modelName: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8 where value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        switch identifier {
        case "iPod5,1":                                 return "iPod Touch 5"
        case "iPod7,1":                                 return "iPod Touch 6"
        case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return "iPhone 4"
        case "iPhone4,1":                               return "iPhone 4s"
        case "iPhone5,1", "iPhone5,2":                  return "iPhone 5"
        case "iPhone5,3", "iPhone5,4":                  return "iPhone 5c"
        case "iPhone6,1", "iPhone6,2":                  return "iPhone 5s"
        case "iPhone7,2":                               return "iPhone 6"
        case "iPhone7,1":                               return "iPhone 6 Plus"
        case "iPhone8,1":                               return "iPhone 6s"
        case "iPhone8,2":                               return "iPhone 6s Plus"
        case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":return "iPad 2"
        case "iPad3,1", "iPad3,2", "iPad3,3":           return "iPad 3"
        case "iPad3,4", "iPad3,5", "iPad3,6":           return "iPad 4"
        case "iPad4,1", "iPad4,2", "iPad4,3":           return "iPad Air"
        case "iPad5,3", "iPad5,4":                      return "iPad Air 2"
        case "iPad2,5", "iPad2,6", "iPad2,7":           return "iPad Mini"
        case "iPad4,4", "iPad4,5", "iPad4,6":           return "iPad Mini 2"
        case "iPad4,7", "iPad4,8", "iPad4,9":           return "iPad Mini 3"
        case "iPad5,1", "iPad5,2":                      return "iPad Mini 4"
        case "iPad6,7", "iPad6,8":                      return "iPad Pro"
        case "AppleTV5,3":                              return "Apple TV"
        case "i386", "x86_64":                          return "Simulator"
        default:                                        return identifier
        }
    }
    
}

extension UILabel {
    @IBInspectable var adjustFontToRealIPhoneSize: Bool {
        set {
            if newValue {
                let currentFont = self.font
                var sizeScale: CGFloat = 1
                let model = UIDevice.currentDevice().modelName
                
                if model == "iPhone 6" {
                    sizeScale = 1.1
                }
                else if model == "iPhone 6 Plus" {
                    sizeScale = 1.2
                }
                if model == "iPhone 6s" {
                    sizeScale = 1.1
                }
                else if model == "iPhone 6s Plus" {
                    sizeScale = 1.2
                }
                else if model == "iPhone 5" {
                    sizeScale = 1.0
                }
                else if model == "iPhone 4" {
                    sizeScale = 0.8
                }
                else if model == "iPhone 4s" {
                    sizeScale = 0.9
                }
                else if model == "Simulator" {
                    sizeScale = 1.0
                }
                else {
                    sizeScale = 1.1
                }
                
                self.font = currentFont.fontWithSize(currentFont.pointSize * sizeScale)
            }
        }
        
        get {
            return false
        }
    }
}


class ViewController: ContainerVC, Slidemenuprotocol, UIGestureRecognizerDelegate {


    @IBOutlet var containerBGView: UIView!
    @IBOutlet var mainContainer: UIView!
    @IBOutlet var sideBGMaskView: UIView!
    
    @IBOutlet var sideContainerBGView: UIView!
    @IBOutlet var sideContainerView: UIView!
    
    @IBOutlet var containerNavigationBar: UINavigationBar!
    @IBOutlet var containerNavigationItem: UINavigationItem!
    
    var sideMenuVC: SideMenuContentVC?
    var isSliderOpen: Bool!
    
    var leftSwipeGesture: UISwipeGestureRecognizer!;
    var rightSwipeGesture: UISwipeGestureRecognizer!;
    let titleView : UILabel = UILabel();
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.sideContainerBGView.hidden = true;
        self.sideContainerBGView.alpha = 0.0;
        self.view .bringSubviewToFront(self.containerBGView);
                
//        UISearchBar.appearance().setSearchFieldBackgroundImage(UIImage(named: "SplashImage.png"), forState: .Normal)
        UISearchBar.appearance().setImage(UIImage(named: "arrow-down.png"), forSearchBarIcon: UISearchBarIcon.ResultsList, state: .Normal)
        UISearchBar.appearance().setImage(UIImage(named: "arrow-down.png"), forSearchBarIcon: UISearchBarIcon.Search, state: .Normal)

        
        self.containerNavigationItem.leftBarButtonItem = UIBarButtonItem.init(image: UIImage(named: "menu_icon.png"), style: UIBarButtonItemStyle.Plain, target: self, action: #selector(ViewController.toggleSideView));
//        self.initNavigationItemTitleView();

        
        leftSwipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(ViewController.swipeOnScreen(_:)))
        leftSwipeGesture.direction = UISwipeGestureRecognizerDirection.Left;
        self.view.addGestureRecognizer(leftSwipeGesture)
        
        rightSwipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(ViewController.swipeOnScreen(_:)))
        rightSwipeGesture.direction = UISwipeGestureRecognizerDirection.Right;
        self.view.addGestureRecognizer(rightSwipeGesture)
        
        self.isSliderOpen = false;
        
        
        Helper.sharedInstance.fetchLocations { () -> Void in
            
        }
        
        Helper.sharedInstance.fetchKitchenAddressess({ (response) -> () in
        });
        
        self.performSelector(#selector(checkForAppUpdate), withObject: nil, afterDelay: 0.7);
    }
    
    func checkForAppUpdate(){
        
        dispatch_async(dispatch_queue_create("backgroundQueue", nil)) {
            if Helper.sharedInstance.appUpdateAvailable(nil) == true {
                dispatch_async(dispatch_get_main_queue(), {
                    let notifPrompt = UIAlertController(title: "First Eat", message: "A better version of the app is available. Please update for a smoother experience.", preferredStyle: UIAlertControllerStyle.Alert)
                    notifPrompt.addAction(UIAlertAction(title: "Update", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
                        UIApplication.sharedApplication().openURL(NSURL(string: Constants.API.APPSTORE_URL)!);
                    }))
//                    notifPrompt.addAction(UIAlertAction(title: "Later", style: UIAlertActionStyle.Default, handler: nil))

                    self.presentViewController(notifPrompt, animated: true, completion: nil);
                })
            }
        }
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
//        self.backToMenu();
    }
    func setNavBarTitle(title: String) {
        self.titleView.font = UIFont(name: "HelveticaNeue-Medium", size: 18)
        self.titleView.textColor = UIColor.whiteColor()
        self.titleView.textAlignment = NSTextAlignment.Center;
        let width = self.titleView.sizeThatFits(CGSizeMake(CGFloat.max, CGFloat.max)).width
        self.titleView.frame = CGRect(origin:CGPointZero, size:CGSizeMake(width, 500))
        self.containerNavigationItem.titleView = self.titleView;
        self.titleView.text = title
        let width1 = self.titleView.sizeThatFits(CGSizeMake(CGFloat.max, CGFloat.max)).width
        self.titleView.bounds = CGRect(origin:CGPointZero, size:CGSizeMake(width1, 100))
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func searchBarShouldBeginEditing(searchBar: UISearchBar) -> Bool {
        return false
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar)
    {
        searchBar.resignFirstResponder()
    }

    func backToMenu() {
        self.cycleFromViewController(nil, toViewController: (self.storyboard?.instantiateViewControllerWithIdentifier("SubscriptionMenuVC"))!);
    }
    
    func swipeOnScreen(gesture: UIGestureRecognizer){
        if let swipeGesture = gesture as? UISwipeGestureRecognizer  {
        switch swipeGesture.direction    {
        case UISwipeGestureRecognizerDirection.Left:
            if self.isSliderOpen == true   {
                self.toggleSideView()
            }
                break;
        case UISwipeGestureRecognizerDirection.Right:
            if self.isSliderOpen == false   {
                self.toggleSideView()
            }
                break;
        default:
            break;
        }
        }
    }
    
    func toggleSideView(){
        
        if self.sideContainerBGView.hidden {
        // open
            self.isSliderOpen = true;
            self.showSideView();
        }
        else {
        // close
            self.isSliderOpen = false;
            self.hideSideView();
        }
    }
    

    func showSideView(){
        
        self.sideContainerBGView.hidden = false;
        self.view .bringSubviewToFront(self.sideContainerBGView);
        self.sideContainerView.transform = CGAffineTransformMakeTranslation(-self.sideContainerView.bounds.size.width, 0);
        self.sideContainerBGView.alpha = 1.0;
        UIView.animateWithDuration(0.3, delay: 0.0, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
            self.sideBGMaskView.alpha = 0.5;
            self.containerBGView.transform = CGAffineTransformConcat(CGAffineTransformMakeScale(0.9, 0.9), CGAffineTransformMakeTranslation(100, 0));
            self.sideContainerView.transform = CGAffineTransformMakeTranslation(0, 0);
            self.sideMenuVC!.setUserDetails();
            }) { (Bool) -> Void in }
    }
    
    func hideSideView(){
        
        UIView.animateWithDuration(0.3, delay: 0.0, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
            self.sideContainerView.transform = CGAffineTransformMakeTranslation(-self.sideContainerView.bounds.size.width, 0);
            self.sideBGMaskView.alpha = 0.0;
            self.containerBGView.transform = CGAffineTransformIdentity;
            }) { (Bool) -> Void in
                self.sideContainerBGView.hidden = true;
                self.view .bringSubviewToFront(self.containerBGView);
            }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let segueName = segue.identifier {
            print(segueName)
            if segueName == "SideMenuContentVC" {
                let sidemenuVC: SideMenuContentVC = segue.destinationViewController as! SideMenuContentVC
                sidemenuVC.delegate = self
                self.sideMenuVC  = sidemenuVC
            }
            else if segueName == "MenuVC" {
                let menuVC: MenuVC = segue.destinationViewController as! MenuVC
                menuVC.view.tag = 101;
            } else if segueName == "DummyVC" {
                let dummyVC: DummyVC = segue.destinationViewController as! DummyVC
                dummyVC.view.tag = 101;
            }
            else    {
            }
        }
    }
    
    // MARK: slidemenuprotocol
    
    func selectedViewController(vc: UIViewController)   {
        print("@@@@@@@@@@ vc",vc);
        self.toggleSideView()
        self.cycleFromViewController(nil, toViewController: vc);
        self.containerNavigationItem.leftBarButtonItem?.image = UIImage(named: "menu_icon.png");
        self.containerNavigationItem.leftBarButtonItem?.action = #selector(ViewController.toggleSideView);
    }
    
    // MARK: transition method

    
    func cycleFromViewController(oldC: AnyObject?,
        toViewController newC: UIViewController)    {
        
        self.cycleFromViewController(oldC, toViewController: newC, onContainer: self.mainContainer)
    }
 
}

