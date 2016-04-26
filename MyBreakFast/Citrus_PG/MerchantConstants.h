//
//  MerchantConstants.h
//  CTS iOS Sdk
//
//  Created by Yadnesh Wankhede on 13/08/14.
//  Copyright (c) 2014 Citrus. All rights reserved.
//


#ifndef CTS_iOS_Sdk_MerchantConstants_h
#define CTS_iOS_Sdk_MerchantConstants_h


// Keys
#define SignInId @"zc7st7huse-signin"
#define SignInSecretKey @"fe59e1f884e587838117bdce0ef7b03d"
#define SubscriptionId @"zc7st7huse-signup" //signup
#define SubscriptionSecretKey @"6d2e949ea213d683557206b853cba16a" //signup


#ifdef DEBUG
// URLs Sandbox
#define VanityUrl @"khaleeque-ansari"
#define BillUrl @"http://firsteat.in/andro/index.php/ws/orders/bill/generator"
#define LoadWalletReturnUrl @"http://firsteatwebportal.in/redirectUrlLoadCash.php"
#else

//URLs Production
#define VanityUrl @"khaleeque-ansari"
#define BillUrl @"http://firsteat.in/andro/index.php/ws/orders/bill/generator"
#define LoadWalletReturnUrl @"http://firsteat.in/andro/index.php/admin/returndata"
#endif

/*
 #define SignInId @"test-signin"
 #define SignInSecretKey @"52f7e15efd4208cf5345dd554443fd99"
 #define SubscriptionId @"test-signup"
 #define SubscriptionSecretKey @"c78ec84e389814a05d3ae46546d16d2e"
 
 // URLs Sandbox
 
 #define VanityUrl @"nativeSDK"
 #define LoadWalletReturnUrl @"https://salty-plateau-1529.herokuapp.com/redirectURL.sandbox.php"
 #define BillUrl @"https://salty-plateau-1529.herokuapp.com/billGenerator.sandbox.php"
 */

#endif