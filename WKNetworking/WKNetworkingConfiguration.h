//
//  WKNetworkingConfiguration.h
//  WKNetworking
//
//  Created by 吴珂 on 15/6/23.
//  Copyright (c) 2015年 吴珂. All rights reserved.
//

#ifndef WKNetworking_WKNetworkingConfiguration_h
#define WKNetworking_WKNetworkingConfiguration_h

typedef NS_ENUM(NSInteger, WKAppType) {
    WKAppTypeAnjuke,
    WKAppTypeBroker,
    WKAppTypeWKang,
    WKAppTypeErShouFang,
    WKAppTypeHaozu
};

typedef NS_ENUM(NSUInteger, WKURLResponseStatus)
{
    WKURLResponseStatusSuccess, //作为底层，请求是否成功只考虑是否成功收到服务器反馈。
    WKURLResponseStatusErrorTimeout,
    WKURLResponseStatusErrorNoNetwork // 默认除了超时以外的错误都是无网络错误。
};

static NSTimeInterval kWKNetworkingTimeoutSeconds = 20.0f;//超时

static BOOL kWKShouldCache = YES;
static NSTimeInterval kWKCacheOutdateTimeSeconds = 300; // 5分钟的cache过期时间
static NSUInteger kWKCacheCountLimit = 1000; // 最多1000条cache


#endif
