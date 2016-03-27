//
//  CTSCVVEncryptor.h
//  CTS iOS Sdk
//
//  Created by Yadnesh Wankhede on 12/28/15.
//  Copyright © 2015 Citrus. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CTSCVVEncryptor : NSObject{
    int seedState;
    NSString *cryptoPassString;


}

-(instancetype)initWithPass:(NSString *)passString;
-(instancetype)initWithDefaultLoginId;
-(void)storeCVV:(NSString *)cvv signature:(NSString *)signature;
-(NSString *)getCVVForSignature:(NSString *)signature;
-(BOOL)isCVVStored:(NSString *)signature;
-(NSMutableDictionary *)getDecryptedCVVStore;
+(void)removeStoredCVV;
@end
