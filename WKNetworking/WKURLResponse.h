//
//  WKURLResponse.h
//  WuKongWeibo
//
//  Created by 吴珂 on 15/6/12.
//  Copyright (c) 2015年 myCompany. All rights reserved.
//  Response

#import <Foundation/Foundation.h>
#import "WKNetworkingConfiguration.h"
@interface WKURLResponse : NSObject

@property (nonatomic, assign, readonly) WKURLResponseStatus status;
@property (nonatomic, copy, readonly) NSString *contentString;
@property (nonatomic, copy, readonly) id content;
@property (nonatomic, assign, readonly) NSInteger requestId;
@property (nonatomic, copy, readonly) NSURLRequest *request;
@property (nonatomic, copy, readonly) NSData *responseData;
@property (nonatomic, copy) NSDictionary *requestParams;
@property (nonatomic, assign, readonly) BOOL isCache;

- (instancetype)initWithResponseString:(NSString *)responseString requestId:(NSNumber *)requestId request:(NSURLRequest *)request responseData:(NSData *)responseData status:(WKURLResponseStatus)status;
- (instancetype)initWithResponseString:(NSString *)responseString requestId:(NSNumber *)requestId request:(NSURLRequest *)request responseData:(NSData *)responseData error:(NSError *)error;


@end
