//
//  CitrusPay.m
//  CTS iOS Sdk
//
//  Created by Yadnesh on 9/14/15.
//  Copyright (c) 2015 Citrus. All rights reserved.
//

#import "CitrusPay.h"
#import "CTSAuthLayer.h"
#import "Version.h"
#import "CTSOauthManager.h"
@implementation CitrusPaymentSDK

+(void)initializeWithKeyStore:(CTSKeyStore *)keyStore environment:(CTSEnvironment)env{
    
    switch (env) {
        case CTSEnvSandbox:
            [CitrusPaymentSDK initializeWithKeyStore:keyStore environmentPath:@"SandboxEnv"];
            break;
        case CTSEnvProduction:
            [CitrusPaymentSDK initializeWithKeyStore:keyStore environmentPath:@"ProductionEnv"];
            break;
        default:
            [CitrusPaymentSDK initializeWithKeyStore:keyStore environmentPath:@"SandboxEnv"];
            break;
    }
}

+(void)initializeWithKeyStore:(CTSKeyStore *)keyStore environmentPath:(NSString *)envPlist{
    [[CTSDataCache sharedCache] cacheData:keyStore key:CACHE_KEY_KEY_STORE];
    [self disableLoader];
    [self enableOneTapPayment];
    
    NSString *path = [[NSBundle mainBundle] pathForResource: envPlist ofType: @"plist"];
    if([[NSFileManager defaultManager] fileExistsAtPath:path] == NO){
        [NSException raise:@"FILE NOT FOUND" format:@"file not found at %@.%@",envPlist,@"plist"];
    }
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile: path];
    [[CTSDataCache sharedCache] cacheData:dict key:CACHE_KEY_ENV];
    
    NSString *bankLogoPath = [[NSBundle mainBundle] pathForResource: @"BankImagesList" ofType: @"plist"];
    if([[NSFileManager defaultManager] fileExistsAtPath:bankLogoPath] == NO){
        [NSException raise:@"FILE NOT FOUND" format:@"File not found at BankImagesList.plist"];
    }
    NSDictionary *bankImagesDict = [NSDictionary dictionaryWithContentsOfFile:bankLogoPath];
    [[CTSDataCache sharedCache] cacheData:bankImagesDict key:BANK_LOGO_KEY];
    
    NSString *bankLogoPath1 = [[NSBundle mainBundle] pathForResource: @"BankImagesListWithBankName" ofType: @"plist"];
    if([[NSFileManager defaultManager] fileExistsAtPath:bankLogoPath1] == NO){
        [NSException raise:@"FILE NOT FOUND" format:@"File not found at BankImagesListWithBankName.plist"];
    }
    NSDictionary *bankImagesDict1 = [NSDictionary dictionaryWithContentsOfFile:bankLogoPath1];
    [[CTSDataCache sharedCache] cacheData:bankImagesDict1 key:BANK_LOGO_WITH_BANK_NAME_KEY];
    
    
    NSString *schemeLogoPath = [[NSBundle mainBundle] pathForResource: @"SchemeImagesList" ofType: @"plist"];
    if([[NSFileManager defaultManager] fileExistsAtPath:schemeLogoPath] == NO){
        [NSException raise:@"FILE NOT FOUND" format:@"File not found at SchemeImagesList.plist"];
    }
    NSDictionary *schemeImagesDict = [NSDictionary dictionaryWithContentsOfFile:schemeLogoPath];
    [[CTSDataCache sharedCache] cacheData:schemeImagesDict key:SCHEME_LOGO_KEY];
    
    
    
    
    
    NSString *prepaidOauth = [CTSOauthManager readPrepaidSigninOuthData].accessToken;
    BOOL isOauthExpired =  [CTSOauthManager hasPrepaidSigninOauthTokenExpired];
    
    
    if(prepaidOauth != nil && isOauthExpired == YES){
        CTSAuthLayer *authLayer = [self fetchSharedAuthLayer];
        LogTrace(@"prepaid token ");
        
        [authLayer requestUpdatePrepaidTokenCompletionHandler:^(NSError *error) {
            LogTrace(@"error %@",error);
        }];
    }
    else if(prepaidOauth == nil){
        NSString *signinOauth = [CTSOauthManager readPasswordSigninOuthData].accessToken;
        if(signinOauth){
            CTSAuthLayer *authLayer = [self fetchSharedAuthLayer];
            LogTrace(@"will fetch new prepaid token for seamless migration ");
            [authLayer requestRefreshOauthTokenCallback:^(NSError *error) {
                LogTrace(@"requestRefreshOauthTokenCallback error %@",error);
            } ];
            
        }
    }
}

+(NSString *)sdkVersion{
    return SDK_VERSION;
    
}
   
    
+(void)enablePush{
    [[CTSDataCache sharedCache] cacheData:[NSNumber numberWithBool:YES] key:CACHE_KEY_PUSH_VIEW_CONTROLLER] ;
}

+(void)disablePush{
    [[CTSDataCache sharedCache] cacheData:[NSNumber numberWithBool:NO] key:CACHE_KEY_PUSH_VIEW_CONTROLLER] ;
}

+(BOOL)isPushEnabled{
    NSNumber *oneTap  = [[CTSDataCache sharedCache] fetchCachedDataForKey:CACHE_KEY_PUSH_VIEW_CONTROLLER] ;
    return [oneTap boolValue];

}


+(BOOL)isKeyStoreConfigured{
    id keystore = [[CTSDataCache sharedCache] fetchCachedDataForKey:CACHE_KEY_KEY_STORE];
    if(keystore){
        return YES;
    }
    return NO;
}


+(CTSAuthLayer*)fetchSharedAuthLayer{
    if([self isKeyStoreConfigured] == NO){
        [self raiseKeystoreExpection];
        return nil;
    }
    return [CTSAuthLayer fetchSharedAuthLayer];
}

+(CTSProfileLayer *)fetchSharedProfileLayer{
    if([self isKeyStoreConfigured] == NO){
        [self raiseKeystoreExpection];
        return nil;
    }
    return [CTSProfileLayer fetchSharedProfileLayer];
}

+(CTSPaymentLayer *)fetchSharedPaymentLayer{
    if([self isKeyStoreConfigured] == NO){
        [self raiseKeystoreExpection];
        return nil;
    }
    return [CTSPaymentLayer fetchSharedPaymentLayer];
}

+(void)raiseKeystoreExpection{
    [NSException raise:@"Citrus SDK Exception: No CTSKeyStore Configured" format:@"Please First Configure KeyStore Using [CitrusPaymentSDK initializeWithKeyStore: environment:]"];
}

+(void)disableOneTapPayment{
    [[CTSDataCache sharedCache] cacheData:[NSNumber numberWithBool:NO] key:CACHE_KEY_ONE_TAP_PAYMENT] ;

}
+(void)disableLoader{
    [[CTSDataCache sharedCache] cacheData:[NSNumber numberWithBool:NO] key:CACHE_KEY_LOADER_OVERLAY] ;
}

+(void)enableOneTapPayment{
    [[CTSDataCache sharedCache] cacheData:[NSNumber numberWithBool:YES] key:CACHE_KEY_ONE_TAP_PAYMENT] ;
}
+(void)enableLoader{
    [[CTSDataCache sharedCache] cacheData:[NSNumber numberWithBool:YES] key:CACHE_KEY_LOADER_OVERLAY] ;
}

+(BOOL)isOneTapPaymentEnabled{
   NSNumber *oneTap  = [[CTSDataCache sharedCache] fetchCachedDataForKey:CACHE_KEY_ONE_TAP_PAYMENT] ;
    return [oneTap boolValue];
}
+(BOOL)isLoaderEnabled{
    return [[[CTSDataCache sharedCache] fetchCachedDataForKey:CACHE_KEY_LOADER_OVERLAY] boolValue];
}

+(void)setLoaderColor:(UIColor *)loaderColor{
    if(loaderColor && [loaderColor respondsToSelector:@selector(setFill)]){
        [self enableLoader];
        [[CTSDataCache sharedCache] cacheData:loaderColor key:CACHE_KEY_LOADER_COLOR] ;
    }
}

+(UIColor *)getLoaderColor{
    return (UIColor *)[[CTSDataCache sharedCache] fetchCachedDataForKey:CACHE_KEY_LOADER_COLOR] ;
}

@end
