//
//  WKReachability.m
//  WKNetworking
//
//  Created by 吴珂 on 15/6/23.
//  Copyright (c) 2015年 吴珂. All rights reserved.
//

#import "WKReachability.h"
#import <AFNetworking.h>

@interface WKReachability ()

@property (nonatomic, strong) AFHTTPRequestOperationManager *manager;

@end

@implementation WKReachability

+ (instancetype)sharedInstance
{
    static WKReachability *reachability = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        reachability = [[WKReachability alloc] init];
        NSURL *baseURL = [NSURL URLWithString:@"http://example.com/"];
        reachability.manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:baseURL];
    });
    return reachability;
}

- (void)startMonitoring
{
    NSOperationQueue *operationQueue = self.manager.operationQueue;
    [self.manager.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusReachableViaWWAN:
            case AFNetworkReachabilityStatusReachableViaWiFi:
                _isReachable = YES;
                [operationQueue setSuspended:NO];
                break;
            case AFNetworkReachabilityStatusNotReachable:
            default:
                _isReachable = NO;
                [operationQueue setSuspended:YES];
                break;
        }
    }];
    
    [self.manager.reachabilityManager startMonitoring];
}

- (BOOL)isReachable
{
    return _manager.reachabilityManager.networkReachabilityStatus;
}
@end
