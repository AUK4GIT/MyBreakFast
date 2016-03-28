//
//  NSString+HVDKit.h
//
//  Created by Harshad on 01/08/14.
//  Copyright (c) 2014 Laughing Buddha Software. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (HVDKit)

/*!
 * Checks if the receiver is a valid email address
 */
- (BOOL)HVD_isValidEmailAddress;

/*!
 * URL encodes the string
 */
+ (instancetype)HVD_URLEncodedString:(NSString *)string;

/*!
 * Checks if the receiver is a valid phone number (10 digits)
 */
- (BOOL)HVD_isValidPhoneNumber;

/*!
 * Returns the day in the natural language.
 *
 * example: passing '5' will return '5th'
 */
+ (instancetype)HVD_naturalLanguageDay:(NSInteger)day;

/*!
 * Returns the short month name from the month number
 */
+ (instancetype)HVD_shortNameForMonth:(NSInteger)monthNumber;

/*!
 * Returns the push token as a string
 */
+ (instancetype)HVD_stringFromPushTokenData:(NSData *)pushTokenData;

+ (instancetype)HVD_extractEmailAddressFromString:(NSString *)string;


@end
