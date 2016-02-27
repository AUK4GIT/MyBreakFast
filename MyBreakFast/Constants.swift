//
//  Constants.swift
//  MyBreakFast
//
//  Created by Uday Kiran Ailapaka on 07/11/15.
//  Copyright © 2015 AUK. All rights reserved.
//

import Foundation

struct Constants {
    
//    Development
    struct API {
        static let GCMRegistration: String = "http://firsteatwebportal.in/api/v1/gcm/registeruser"
        static let UserRegistration: String = "http://www.firsteat.in/dev/index.php/ws/register/user"
        static let UserLogin: String = "http://www.firsteat.in/dev/index.php/ws/verify/user"
        static let MenuToday: String = "http://firsteatwebportal.in/api/v1/menu"//
        static let MenuonDate: String = "http://www.firsteat.in/dev/index.php/ws/menu/all"
        static let MenuonDateLocation: String = "http://www.firsteat.in/dev/index.php/ws/menu/location/"
        static let UserAddresses: String = "http://www.firsteat.in/dev/index.php/ws/users/address/list/"
        static let UpdateUserAddress: String = "http://www.firsteat.in/dev/index.php/ws/users/address/add"
        static let TimeSlots: String = "http://www.firsteat.in/dev/index.php/ws/kitchen/slots"

        static let PlaceTestOrder: String = "http://firsteatwebportal.in/api/v1/order/placeTestOrder"
        static let AboutUs: String = "http://firsteatwebportal.in/api/v1/contactus/aboutUs"
        static let ContactUsMessage: String = "http://firsteatwebportal.in/api/v1/contactus/add"
        static let UserFeedback: String = "http://www.firsteat.in/dev/index.php/ws/user/feedback/"

        static let ServiceCoverage: String = "http://firsteatwebportal.in/api/v1/locations/getServiceRadius"
        static let MyOrders: String = "http://www.firsteat.in/dev/index.php/ws/users/orders/all/"
        static let LocationsURL: String = "http://www.firsteat.in/dev/index.php/ws/get/all/locations"
        static let DeliveryLocationsURL: String = "http://www.firsteat.in/dev/index.php/ws/locations/delivery/all"
        static let GETRedeemPoints: String = "http://www.firsteat.in/dev/index.php/ws/users/points/all/"
        static let RedeemPoints: String = "http://www.firsteat.in/dev/index.php/ws/points/redeem/"
        static let ValidateCoupon: String = "http://www.firsteat.in/dev/index.php/ws/orders/coupon/apply?coupon="
        static let PlaceOrder: String = "http://www.firsteat.in/dev/index.php/ws/orders/add/new/"

        static let UpdateOrderWithMenuIds: String = "http://www.firsteat.in/dev/index.php/ws/orders/add/new/item/"
        static let UpdateOrderWithOfferIds: String = "http://www.firsteat.in/dev/index.php/ws/orders/add/menu/offers/"
        static let UpdateOrderWithBill: String = "http://www.firsteat.in/dev/index.php/ws/orders/update/"

        static let FavouritesMenu: String = "http://www.firsteat.in/dev/index.php/ws/user/favorite/menu/"
        static let UploadFavouritesMenu: String = "http://www.firsteat.in/dev/index.php/ws/menu/user/favorite?user="
        
        static let SpecialNotifications: String = "http://www.firsteat.in/dev/index.php/ws/notifications/special"
        static let OrderDetails: String = "http://www.firsteat.in/dev/index.php/ws/user/order/details/"
        
        static let GOOGLE_DISTENCE_MATRIX: String = "https://maps.googleapis.com/maps/api/distancematrix/json";
        
        static let  URL_KITCHENS: String = "http://www.firsteat.in/dev/index.php/ws/kitchens/all";

        static let  GOOGLE_BROWSER_KEY : String = "AIzaSyCQeMJ_iTUeitPnr71dHMFgK_T6ZXj1BMo";

    }
    
    //Production
//    struct API {
//        static let GCMRegistration: String = "http://www.firsteat.in/dev/index.php/ws/first/app"
//        static let UserRegistration: String = "http://www.firsteat.in/app/index.php/ws/register/user"
//        static let UserLogin: String = "http://www.firsteat.in/app/index.php/ws/verify/user"
////        static let MenuToday: String = "http://firsteatwebportal.in/api/v1/menu"//
//        static let MenuonDate: String = "http://www.firsteat.in/app/index.php/ws/menu/all"
//    static let MenuonDateLocation: String = "http://www.firsteat.in/app/index.php/ws/menu/location/"
//        static let UserAddresses: String = "http://www.firsteat.in/app/index.php/ws/users/address/list/"
//        static let UpdateUserAddress: String = "http://www.firsteat.in/app/index.php/ws/users/address/add"
//        static let TimeSlots: String = "http://www.firsteat.in/app/index.php/ws/kitchen/slots"
//        
////        static let PlaceTestOrder: String = "http://firsteatwebportal.in/api/v1/order/placeTestOrder"
//        static let AboutUs: String = "http://firsteatwebportal.in/api/v1/contactus/aboutUs"
//        static let ContactUsMessage: String = "http://firsteatwebportal.in/api/v1/contactus/add"
//        static let UserFeedback: String = "http://www.firsteat.in/app/index.php/ws/user/feedback/"
//        
////        static let ServiceCoverage: String = "http://firsteatwebportal.in/api/v1/locations/getServiceRadius"
//        static let MyOrders: String = "http://www.firsteat.in/app/index.php/ws/users/orders/all/"
//        static let LocationsURL: String = "http://www.firsteat.in/app/index.php/ws/get/all/locations"
//        static let DeliveryLocationsURL: String = "http://www.firsteat.in/app/index.php/ws/locations/delivery/all"
//        static let GETRedeemPoints: String = "http://www.firsteat.in/app/index.php/ws/users/points/all/"
//        static let RedeemPoints: String = "http://www.firsteat.in/app/index.php/ws/points/redeem/"
//        static let ValidateCoupon: String = "http://www.firsteat.in/app/index.php/ws/orders/coupon/apply?coupon="
//        static let PlaceOrder: String = "http://www.firsteat.in/app/index.php/ws/orders/add/new/"
//        
//        static let UpdateOrderWithMenuIds: String = "http://www.firsteat.in/app/index.php/ws/orders/add/new/item/"
//        static let UpdateOrderWithOfferIds: String = "http://www.firsteat.in/app/index.php/ws/orders/add/menu/offers/"
//        static let UpdateOrderWithBill: String = "http://www.firsteat.in/app/index.php/ws/orders/update/"
//        
//        static let FavouritesMenu: String = "http://www.firsteat.in/app/index.php/ws/user/favorite/menu/"
//        static let UploadFavouritesMenu: String = "http://www.firsteat.in/app/index.php/ws/menu/user/favorite?user="
//        
//        static let SpecialNotifications: String = "http://www.firsteat.in/app/index.php/ws/notifications/special"
//        static let OrderDetails: String = "http://www.firsteat.in/app/index.php/ws/user/order/details/"
//        
//        static let GOOGLE_DISTENCE_MATRIX: String = "https://maps.googleapis.com/maps/api/distancematrix/json";
//        
//        static let  URL_KITCHENS: String = "http://www.firsteat.in/app/index.php/ws/kitchens/all";
//        
//        static let  GOOGLE_BROWSER_KEY : String = "AIzaSyCQeMJ_iTUeitPnr71dHMFgK_T6ZXj1BMo";
//        
//    }

    
    struct StaticContent {
        static let SideMenuList : [String] = ["Menu", "My Orders", "About Us", "Contact Us", "Rate Us", "Refer a Friend"];
        static let AppThemeColor = UIColor(red: 200.0/255.0, green: 5.0/255.0, blue: 15.0/255.0, alpha: 1.0);
    }
    
    struct ServiceLocation {
        static let SLatitude: Double = 28.486257
        static let SLongitude: Double = 77.104092
    }
    
    struct DeviceConstants {
        static let IS_IPAD = (UIDevice.currentDevice().userInterfaceIdiom == .Pad)
        static let IS_IPHONE = (UIDevice.currentDevice().userInterfaceIdiom == .Phone)
        static let IS_RETINA = (UIScreen.mainScreen().scale >= 2.0)
        
        static let SCREEN_WIDTH  = UIScreen.mainScreen().bounds.size.width
        static let SCREEN_HEIGHT = UIScreen.mainScreen().bounds.size.height
        static let SCREEN_MAX_LENGTH = max(SCREEN_WIDTH, SCREEN_HEIGHT)
        static let SCREEN_MIN_LENGTH = min(SCREEN_WIDTH, SCREEN_HEIGHT)
        
        static let IS_IPHONE_5_OR_LESS = (IS_IPHONE && SCREEN_MAX_LENGTH <= 568.0)
    }
    
    struct UserdefaultConstants {
        static let DeviceId: String = "DeviceId"
        static let GCMRegistrationToken: String = "RegistrationToken"
        static let UserLoginStatus: String = "UserLogInStatus"
        static let UserRegistration: String = "UserRegistration"
        static let LastSelectedAddressId: String = "LastSelectedAddressId"
        static let LastSelectedLocationId: String = "LastSelectedLocationId"

    }
}