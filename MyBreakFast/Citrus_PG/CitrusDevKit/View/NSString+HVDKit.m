//
//  NSString+HVDKit.m
//
//  Created by Harshad on 01/08/14.
//  Copyright (c) 2014 Laughing Buddha Software. All rights reserved.
//

#import "NSString+HVDKit.h"

NSString *const HVDStringEmailRegex =   @"(?:[a-z0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[a-z0-9!#$%\\&'*+/=?\\^_`{|}"
                                        @"~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\"
                                        @"x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-"
                                        @"z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5"
                                        @"]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-"
                                        @"9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21"
                                        @"-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])";

@implementation NSString (HVDKit)

- (BOOL)HVD_isValidEmailAddress {
    BOOL isValid = NO;

    NSPredicate *regExPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", HVDStringEmailRegex];

    isValid = [regExPredicate evaluateWithObject:[self lowercaseString]];

    return isValid;
}

// Source: http://stackoverflow.com/questions/2159341/nsstring-method-to-percent-escape-for-url
+ (instancetype)HVD_URLEncodedString:(NSString *)string {

    NSString *result = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)string, NULL, CFSTR(":/?#[]@!$&’()*+,;="), kCFStringEncodingUTF8));
    return result;
}

- (BOOL)HVD_isValidPhoneNumber {
    BOOL isValid = NO;

    if (self.length == 10) {
        NSCharacterSet *validCharacets = [NSCharacterSet decimalDigitCharacterSet];
        NSCharacterSet *inSet = [NSCharacterSet characterSetWithCharactersInString:self];
        if ([validCharacets isSupersetOfSet:inSet]) {
            isValid = YES;
        }
    }

    return isValid;
}

+ (instancetype)HVD_naturalLanguageDay:(NSInteger)day {
    NSString *suffix = @"th";
    if (!((day % 100) >= 10 && (day % 100) < 21)) {
        NSInteger lastDigit = day % 10;
        switch (lastDigit) {
            case 1:
                suffix = @"st";
                break;

            case 2:
                suffix = @"nd";
                break;

            case 3:
                suffix = @"rd";
                break;
                
            default:
                break;
        }
    }

    return [self stringWithFormat:@"%ld%@", (long)day, suffix];
}

+ (instancetype)HVD_shortNameForMonth:(NSInteger)monthNumber {
    NSString *monthName = nil;
    switch (monthNumber) {
        case 1:
            monthName = @"Jan";
            break;

        case 2:
            monthName = @"Feb";
            break;

        case 3:
            monthName = @"Mar";
            break;

        case 4:
            monthName = @"Apr";
            break;

        case 5:
            monthName = @"May";
            break;

        case 6:
            monthName = @"Jun";
            break;

        case 7:
            monthName = @"Jul";
            break;

        case 8:
            monthName = @"Aug";
            break;

        case 9:
            monthName = @"Sep";
            break;

        case 10:
            monthName = @"Oct";
            break;

        case 11:
            monthName = @"Nov";
            break;

        case 12:
            monthName = @"Dec";

        default:
            break;
    }
    
    return monthName;
}

+ (instancetype)HVD_stringFromPushTokenData:(NSData *)pushTokenData {

    NSData *deviceToken = pushTokenData;
    const char* data = [deviceToken bytes];
    NSMutableString* token = [NSMutableString string];
    NSUInteger length = [deviceToken length];
    for (int i = 0; i != length; ++i) {
        [token appendFormat:@"%02.2hhX", data[i]];
    }

    return [token copy];
}

+ (instancetype)HVD_extractEmailAddressFromString:(NSString *)string {
    NSString *email = nil;
    NSRange emailRange = [string rangeOfString:HVDStringEmailRegex options:(NSRegularExpressionSearch)];
    if (emailRange.location != NSNotFound) {
        email = [string substringWithRange:emailRange];
    }
    return email;
}

@end
