//
//  WKURLResponse.m
//  WuKongWeibo
//
//  Created by 吴珂 on 15/6/12.
//  Copyright (c) 2015年 myCompany. All rights reserved.
//

#import "WKURLResponse.h"

@interface WKURLResponse ()

@property (nonatomic, assign, readwrite) WKURLResponseStatus status;
@property (nonatomic, copy, readwrite) NSString *contentString;
@property (nonatomic, copy, readwrite) id content;
@property (nonatomic, copy, readwrite) NSURLRequest *request;
@property (nonatomic, assign, readwrite) NSInteger requestId;
@property (nonatomic, copy, readwrite) NSData *responseData;
@property (nonatomic, assign, readwrite) BOOL isCache;

@end

@implementation WKURLResponse

#pragma mark - life cycle
- (instancetype)initWithResponseString:(NSString *)responseString requestId:(NSNumber *)requestId request:(NSURLRequest *)request responseData:(NSData *)responseData status:(WKURLResponseStatus)status
{
    self = [super init];
    if (self) {
        self.contentString = responseString;
        self.content = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:NULL];
        self.status = status;
        self.requestId = [requestId integerValue];
        self.request = request;
        self.responseData = responseData;
        self.isCache = NO;
    }
    return self;
}

- (instancetype)initWithResponseString:(NSString *)responseString requestId:(NSNumber *)requestId request:(NSURLRequest *)request responseData:(NSData *)responseData error:(NSError *)error
{
    self = [super init];
    if (self) {
        NSError *err;
        id contentObject;
        @try {
            contentObject = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:&err];
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
        }
        
        if (!err) {
            self.contentString = [contentObject description];
        }else{
            self.contentString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        }

        self.status = [self responseStatusWithError:error];
        self.requestId = [requestId integerValue];
        self.request = request;
        self.responseData = responseData;
        self.isCache = NO;
        
        if (responseData) {
            self.content = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:NULL];
        } else {
            self.content = nil;
        }
    }
    return self;
}

- (instancetype)initWithData:(NSData *)data
{
    self = [super init];
    if (self) {
        NSError *err;
        id contentObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&err];
        if (!err) {
            self.contentString = [contentObject description];
        }else{
            self.contentString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        }
        
        self.status = [self responseStatusWithError:nil];
        self.requestId = 0;
        self.request = nil;
        self.responseData = [data copy];
        self.content = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:NULL];
        self.isCache = YES;
    }
    return self;
}

#pragma mark - private methods
- (WKURLResponseStatus)responseStatusWithError:(NSError *)error
{
    if (error) {
        WKURLResponseStatus result = WKURLResponseStatusErrorNoNetwork;
        
        // 除了超时以外，所有错误都当成是无网络
        if (error.code == NSURLErrorTimedOut) {
            result = WKURLResponseStatusErrorNoNetwork;
        }
        return result;
    } else {
        return WKURLResponseStatusSuccess;
    }
}


@end
