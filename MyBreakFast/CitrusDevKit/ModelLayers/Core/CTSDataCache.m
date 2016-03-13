//
//  CTSDataCache.m
//  CTS iOS Sdk
//
//  Created by Yadnesh on 8/31/15.
//  Copyright (c) 2015 Citrus. All rights reserved.
//

#import "CTSDataCache.h"

@implementation CTSDataCache
@synthesize cache;

+ (id)sharedCache {
    static CTSDataCache *sharedCache = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedCache = [[self alloc] init];
    });
    return sharedCache;
}

- (id)init {
    if (self = [super init]) {
        cache = [[NSMutableDictionary alloc] init];
    }
    return self;
}

@end
