//
//  SignInVC.swift
//  MyBreakFast
//
//  Created by Uday Kiran Ailapaka on 31/10/15.
//  Copyright © 2015 AUK. All rights reserved.
//

import Foundation
import UIKit
import GoogleMaps

class SignInVC: UIViewController, GIDSignInUIDelegate {
    
    var placesClient: GMSPlacesClient?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.fetchCurrentLocation();
        let appDelegate: AppDelegate =  UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.performSelector("loadMainView", withObject: nil, afterDelay: 2.0)
    }
    
    func fetchCurrentLocation() {
        
        self.placesClient = GMSPlacesClient()
        self.placesClient!.currentPlaceWithCallback({ (placeLikelihoods: GMSPlaceLikelihoodList?, error) -> Void in
            if error != nil {
                print("Current Place error: \(error!.localizedDescription)")
                
                UIAlertView(title: "Location", message: "Your current location is out of our service area. Please select your delivery area from the list.", delegate: nil, cancelButtonTitle: "OK").show()
//                self.fetchMenuData()
                return
            }
            var from : CLLocation?
            var to : CLLocation?
            for likelihood in placeLikelihoods!.likelihoods {
                if let likelihood = likelihood as? GMSPlaceLikelihood {
                    let place = likelihood.place
                    print("Current Place name \(place.name) at likelihood \(likelihood.likelihood)")
                    print("Current Place address \(place.formattedAddress)")
                    print("Current Place attributions \(place.attributions)")
                    print("Current PlaceID \(place.placeID)")
                    print("Current Coordinates \(place.coordinate)")
                    from = CLLocation(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
                }
            }
            
            to = CLLocation(latitude: CLLocationDegrees(Constants.ServiceLocation.SLatitude), longitude: CLLocationDegrees(Constants.ServiceLocation.SLongitude))
            let distance = NSNumber(double: from!.distanceFromLocation(to!));
            print(distance, distance.integerValue)
            if 4.compare(distance) == .OrderedAscending {
                UIAlertView(title: "Location", message: "Your current location is out of our service area. Please select your delivery area from the list.", delegate: nil, cancelButtonTitle: "OK").show()
            }
        })
    }
    

       // MARK: UITextField Delegates
    
     func textFieldDidBeginEditing(textField: UITextField) {
        
        UIView.animateWithDuration(0.3, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
//            self.horizantalCenterConstraint.constant = -100;
//            self.view.layoutIfNeeded()

            }, completion: nil)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
//        self.emailTextField.resignFirstResponder()
        return true
    }

    
     func textFieldDidEndEditing(textField: UITextField) {
    
        UIView.animateWithDuration(0.3, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
//            self.horizantalCenterConstraint.constant = 0;
//            self.view.layoutIfNeeded()
            }) { (Bool) -> Void in
//                self.validateEmailId();
            }
    }
}