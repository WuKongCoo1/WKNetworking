//
//  WKLogger.h
//  WKNetworking
//
//  Created by 吴珂 on 15/6/23.
//  Copyright (c) 2015年 吴珂. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WKLogger : NSObject

+ (instancetype)sharedInstance;

+ (void)logDebugInfoWithRequest:(NSURLRequest *)request apiName:(NSString *)apiName requestParams:(id)requestParams httpMethod:(NSString *)httpMethod;
+ (void)logDebugInfoWithResponse:(NSHTTPURLResponse *)response resposeString:(NSString *)responseString request:(NSURLRequest *)request error:(NSError *)error;

@end
