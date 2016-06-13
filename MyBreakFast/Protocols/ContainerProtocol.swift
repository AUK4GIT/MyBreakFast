//
//  ContainerProtocol.swift
//  MyBreakFast
//
//  Created by AUK on 10/06/16.
//  Copyright © 2016 AUK. All rights reserved.
//

import Foundation

class ContainerVC: UIViewController {
    
}
protocol ContainerProtocol {
    func cycleFromViewController(oldC: AnyObject?,
                                 toViewController newC: UIViewController, onContainer mainContainer: UIView)
}

extension ContainerVC: ContainerProtocol { //Make all the UIViewControllers that conform to ContainerProtocol have a default implementation of cycleFromViewController
    
    func cycleFromViewController(oldC: AnyObject?,
                                 toViewController newC: UIViewController, onContainer mainContainer: UIView)    {
        
        guard let oldView = mainContainer.viewWithTag(101) else {
            print(mainContainer.viewWithTag(101));
            newC.view.tag = 101;
            self.addChildViewController(newC)
            newC.view.autoresizingMask = [UIViewAutoresizing.FlexibleWidth, UIViewAutoresizing.FlexibleHeight]
            newC.view.frame = mainContainer.bounds;
            mainContainer.addSubview(newC.view);
            
            newC.view.alpha = 0.0;
            
            
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                newC.view.alpha = 1.0;
                }, completion: { (Bool) -> Void in
                    newC.didMoveToParentViewController(self);
            })
            
            return;
        }
        
        newC.view.tag = 101;
        let _oldC: UIViewController = oldView.nextResponder() as! UIViewController;
        
        _oldC.willMoveToParentViewController(nil)
        self.addChildViewController(newC)
        newC.view.autoresizingMask = [UIViewAutoresizing.FlexibleWidth, UIViewAutoresizing.FlexibleHeight]
        newC.view.frame = mainContainer.bounds;
        newC.view.alpha = 0.0;
        _oldC.view.alpha = 1.0;
        
        if let _ = _oldC as UIViewController? {
            self.transitionFromViewController(_oldC, toViewController: newC, duration: 0.3, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
                newC.view.alpha = 1.0;
                _oldC.view.alpha = 0.0;
            }) { (Bool) -> Void in
                _oldC.removeFromParentViewController();
                newC.didMoveToParentViewController(self);
                _oldC.view.removeFromSuperview();
            }
        }
        else {
            newC.view.alpha = 1.0;
            mainContainer.addSubview(newC.view);
            newC.didMoveToParentViewController(self);
        }
        
    }
}
