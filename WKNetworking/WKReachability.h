//
//  WKReachability.h
//  WKNetworking
//
//  Created by 吴珂 on 15/6/23.
//  Copyright (c) 2015年 吴珂. All rights reserved.
//  网络状态检查

#import <Foundation/Foundation.h>

@interface WKReachability : NSObject

@property (nonatomic, assign) BOOL isReachable;

+ (instancetype)sharedInstance;

- (void)startMonitoring;


@end
