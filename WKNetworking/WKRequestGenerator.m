//
//  WKRequestGenerator.m
//  WKNetworking
//
//  Created by 吴珂 on 15/6/23.
//  Copyright (c) 2015年 吴珂. All rights reserved.
//

#import "WKRequestGenerator.h"
#import "WKNetworkingConfiguration.h"
#import "WKLogger.h"
#import <AFNetworking.h>

@interface WKRequestGenerator ()

@property (nonatomic, strong) AFHTTPRequestSerializer *httpRequestSerializer;

@end

@implementation WKRequestGenerator

- (AFHTTPRequestSerializer *)httpRequestSerializer
{
    if (_httpRequestSerializer == nil) {
        _httpRequestSerializer = [AFHTTPRequestSerializer serializer];
        _httpRequestSerializer.timeoutInterval = kWKNetworkingTimeoutSeconds;
        _httpRequestSerializer.cachePolicy = NSURLRequestUseProtocolCachePolicy;
    }
    return _httpRequestSerializer;
}

+ (instancetype)sharedInstance
{
    static WKRequestGenerator *sharedInstacnce = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstacnce = [[WKRequestGenerator alloc] init];
    });
    return sharedInstacnce;
}

- (NSURLRequest *)generateGETRequestWithServiceIdentifier:(NSString *)serviceIdentifier urlString:(NSString *)urlString requestParams:(NSDictionary *)requestParams methodName:(NSString *)methodName
{
    //1.生成request
    NSMutableURLRequest *request = [self.httpRequestSerializer requestWithMethod:@"GET" URLString:urlString parameters:requestParams error:NULL];
    request.timeoutInterval = kWKNetworkingTimeoutSeconds;
    
    [WKLogger logDebugInfoWithRequest:request apiName:methodName requestParams:requestParams httpMethod:@"GET"];
    
    
    return request;
}

- (NSURLRequest *)generatePOSTRequestWithServiceIdentifier:(NSString *)serviceIdentifier urlString:(NSString *)urlString requestParams:(NSDictionary *)requestParams methodName:(NSString *)methodName
{
    NSMutableURLRequest *request = [self.httpRequestSerializer requestWithMethod:@"POST" URLString:urlString parameters:requestParams error:NULL];
    request.timeoutInterval = kWKNetworkingTimeoutSeconds;
    
    [WKLogger logDebugInfoWithRequest:request apiName:methodName requestParams:requestParams httpMethod:@"POST"];
    
    return request;
}

@end
