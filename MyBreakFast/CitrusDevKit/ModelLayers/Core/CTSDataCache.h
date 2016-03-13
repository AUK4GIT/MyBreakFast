//
//  CTSDataCache.h
//  CTS iOS Sdk
//
//  Created by Yadnesh on 8/31/15.
//  Copyright (c) 2015 Citrus. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CTSDataCache : NSObject
@property(strong)NSMutableDictionary *cache;
+ (id)sharedCache;

@end
