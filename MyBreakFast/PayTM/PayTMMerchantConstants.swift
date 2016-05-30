//
//  PayTMMerchantConstants.swift
//  MyBreakFast
//
//  Created by AUK on 22/05/16.
//  Copyright © 2016 AUK. All rights reserved.
//

import Foundation

//Production

struct PayTMConstants {
 
     static let CheckSumGenURL: String = "http://www.firsteatwebportal.in/paytm-checksumgeneration.php"
     static let CheckSumValidURL: String = "http://www.firsteatwebportal.in/paytm-checksumvalidation.php"
     
     static let MID: String = "Fefood64366571835976"
     static let ChannelID: String = "WAP"
     static let IndustryTypeID: String = "Retail114"
     static let Website: String = "Fewap"
     static let MerchantKey: String = "Fy0vAKV!X34mrouk"
    static let ServerType: String = "production"

 
}

/*
//Staging
struct PayTMConstants {
    static let CheckSumGenURL: String = "http://www.firsteatwebportal.in/paytm-checksumgeneration.php"
    static let CheckSumValidURL: String = "http://www.firsteatwebportal.in/paytm-checksumvalidation.php"

    static let MID: String = "fefood32616579370614"
    static let ChannelID: String = "WAP"
    static let IndustryTypeID: String = "Retail"
    static let Website: String = "fefoodwap"
    static let MerchantKey: String = "k3M2vcm_vIXMMArF"
    static let ServerType: String = "staging"

    /*
    Staging Server URL –
    
    https://pguat.paytm.com/oltp-web/processTransaction?orderid=%3COrder_ID
    
    Dashboard Login Details :
    
    login URL     :    https://pguat.paytm.com/PayTMSecured1/app/auth/login
    Username      : fefood
    Password:        Paytm@197
    
    Kindly use below test wallet for testing:
    
    ·  Mobile Number - 7777777777
    ·  Password - Paytm12345
    ·  OTP - 489871 (fixed OTP)
 */

}
 */