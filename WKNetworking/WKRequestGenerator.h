//
//  WKRequestGenerator.h
//  WKNetworking
//
//  Created by 吴珂 on 15/6/23.
//  Copyright (c) 2015年 吴珂. All rights reserved.
//  请求生成类

#import <Foundation/Foundation.h>

@interface WKRequestGenerator : NSObject

+ (instancetype)sharedInstance;

- (NSURLRequest *)generateGETRequestWithServiceIdentifier:(NSString *)serviceIdentifier urlString:(NSString *)urlString requestParams:(NSDictionary *)requestParams methodName:(NSString *)methodName;
- (NSURLRequest *)generatePOSTRequestWithServiceIdentifier:(NSString *)serviceIdentifier urlString:(NSString *)urlString requestParams:(NSDictionary *)requestParams methodName:(NSString *)methodName;

@end
