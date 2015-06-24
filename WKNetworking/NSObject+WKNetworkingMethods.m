//
//  NSObject+WKNetworkingMethods.m
//  WKNetworking
//
//  Created by 吴珂 on 15/6/23.
//  Copyright (c) 2015年 吴珂. All rights reserved.
//

#import "NSObject+WKNetworkingMethods.h"

@implementation NSObject (WKNetworkingMethods)

- (id)WK_defaultValue:(id)defaultData
{
    if (![defaultData isKindOfClass:[self class]]) {
        return defaultData;
    }
    
    if ([self WK_isEmptyObject]) {
        return defaultData;
    }
    
    return self;
}

- (BOOL)WK_isEmptyObject
{
    if ([self isEqual:[NSNull null]]) {
        return YES;
    }
    
    if ([self isKindOfClass:[NSString class]]) {
        if ([(NSString *)self length] == 0) {
            return YES;
        }
    }
    
    if ([self isKindOfClass:[NSArray class]]) {
        if ([(NSArray *)self count] == 0) {
            return YES;
        }
    }
    
    if ([self isKindOfClass:[NSDictionary class]]) {
        if ([(NSDictionary *)self count] == 0) {
            return YES;
        }
    }
    
    return NO;
}


@end
