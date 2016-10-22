//
//  BaseViewController.m
//  CubeDemo
//
//  Created by Vikas Singh on 8/25/15.
//  Copyright (c) 2015 Vikas Singh. All rights reserved.
//

#import "BaseViewController.h"
//#import "TestParams.h"
#import "MerchantConstants.h"
#import "MyBreakFast-Swift.h"


@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self initializeLayers];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - initializers

// Initialize the SDK layer viz CTSAuthLayer/CTSProfileLayer/CTSPaymentLayer
-(void)initializeLayers{
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    
    CTSKeyStore *keyStore = [[CTSKeyStore alloc] init];
    keyStore.signinId = SignInId;
    keyStore.signinSecret = SignInSecretKey;
    keyStore.signUpId = SubscriptionId;
    keyStore.signUpSecret = SubscriptionSecretKey;
    keyStore.vanity = VanityUrl;
    
//#ifdef DEBUG
//    [CitrusPaymentSDK initializeWithKeyStore:keyStore environment:CTSEnvSandbox];
//#else
    NSLog(@"********CTSEnvProduction ********CTSEnvProduction:  %@",SignInId);
    [CitrusPaymentSDK initializeWithKeyStore:keyStore environment:CTSEnvProduction];
//#endif
    
    authLayer = [CTSAuthLayer fetchSharedAuthLayer];
    proifleLayer = [CTSProfileLayer fetchSharedProfileLayer];
    paymentLayer = [CTSPaymentLayer fetchSharedPaymentLayer];
    
    NSDictionary *userData = [[Helper sharedInstance] getUserDetailsDict];
    
    if (userData != nil) {
        
        contactInfo = [[CTSContactUpdate alloc] init];
        contactInfo.firstName = [userData objectForKey:@"firstName"];
        contactInfo.lastName = @"";
        contactInfo.email = [userData objectForKey:@"email"];
        contactInfo.mobile = @"9650503675";//[userData objectForKey:@"mobile"];
        
        addressInfo = [[CTSUserAddress alloc] init];
        addressInfo.city = @"Gurgoan";
        addressInfo.country = @"India";
        addressInfo.state = @"Haryana";
        addressInfo.street1 = [userData objectForKey:@"address"];
        addressInfo.street2 = @"";
        addressInfo.zip = @"";
    }

    /*
        Update this for loading money into Citrus.
     */
    customParams = @{
                     @"USERDATA2":@"MOB_RC|9988776655",
                     @"USERDATA10":@"test",
                     @"USERDATA4":@"MOB_RC|test@gmail.com",
                     @"USERDATA3":@"MOB_RC|4111XXXXXXXX1111",
                     };
}

@end
