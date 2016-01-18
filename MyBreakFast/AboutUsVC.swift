//
//  AboutUsVC.swift
//  MyBreakFast
//
//  Created by Uday Kiran Ailapaka on 29/10/15.
//  Copyright © 2015 AUK. All rights reserved.
//

import Foundation
import UIKit

class AboutUsVC: UIViewController {
    
    @IBOutlet var textView: UITextView!
    override func beginAppearanceTransition(isAppearing: Bool, animated: Bool) {
        super.beginAppearanceTransition(isAppearing, animated: animated)
        if isAppearing {
            let fadeTextAnimation: CATransition = CATransition();
            fadeTextAnimation.duration = 0.5;
            fadeTextAnimation.type = kCATransitionFade;
            
            let parentVC: ViewController = self.parentViewController as! ViewController
            parentVC.setNavBarTitle("About Us")
            parentVC.containerNavigationBar.layer.addAnimation(fadeTextAnimation, forKey: "fadeText");
        }
    }
    override func endAppearanceTransition() {
        super.endAppearanceTransition()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.textView.text = "Loading...";
        self.textView.text = nil;

        Helper.sharedInstance.getAboutusText { (response) -> () in
            print(response)
            self.textView.text = nil;
            
            let htmlString : String  = response as! String
            let modifiedFont = NSString(format:"<span style=\"font-family: 'HelveticaNeue-ThinItalic'; font-size: 18px; color: #696969;\">%@</span>", htmlString) as String

            do {
                let attributedStr : NSAttributedString = try NSAttributedString(data: modifiedFont.dataUsingEncoding(NSUnicodeStringEncoding, allowLossyConversion: true)!, options: [NSDocumentTypeDocumentAttribute : NSHTMLTextDocumentType, NSCharacterEncodingDocumentAttribute: NSUTF8StringEncoding], documentAttributes: nil)
            
            self.textView.attributedText = attributedStr;
            } catch {
            
            }
            
            self.textView.scrollRectToVisible(CGRectZero, animated: true)
            self.view.setNeedsDisplay()

        }
    }
}